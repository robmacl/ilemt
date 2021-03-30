// Basic server to copy ILEMT data to/from a TCP socket as transport
// to the Labview ilemt_ui.vi.
//
// Template from https://www.bogotobogo.com/cplusplus/sockets_server_client.php

/* The port number is passed as an optional argument */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>

void error(const char *msg)
{
    perror(msg);
    exit(1);
}

const PORTNO_DEFAULT = 6666;

int accept_fd;

void init_listener (int portno) {
  struct sockaddr_in serv_addr;
  // create a socket
  // socket(int domain, int type, int protocol)
  accept_fd = socket(AF_INET, SOCK_STREAM, 0);
  if (accept_fd < 0) 
    error("ERROR opening socket");

  // clear address structure
  bzero((char *) &serv_addr, sizeof(serv_addr));

  /* setup the host_addr structure for use in bind call */
  // server byte order
  serv_addr.sin_family = AF_INET;  

  // automatically be filled with current host's IP address
  serv_addr.sin_addr.s_addr = INADDR_ANY;  

  // convert short integer value for port must be converted into network byte
  // order
  serv_addr.sin_port = htons(portno);

  // bind(int fd, struct sockaddr *local_addr, socklen_t addr_length) bind()
  // passes file descriptor, the address structure, and the length of the
  // address structure This bind() call will bind the socket to the current IP
  // address on port, portno
  if (bind(accept_fd, (struct sockaddr *) &serv_addr,
	   sizeof(serv_addr)) < 0) 
    error("ERROR on binding");

  // This listen() call tells the socket to listen to the incoming
  // connections.  The listen() function places all incoming connection into a
  // backlog queue until accept() call accepts the connection.  Here, we set
  // the maximum size for the backlog queue to 5.
  listen(accept_fd,5);
}


int accept_fd () {
  struct sockaddr_in cli_addr;
  // The accept() call actually accepts an incoming connection
  clilen = sizeof(cli_addr);

  // This accept() function will write the connecting client's address info
  // into the the address structure and the size of that structure is clilen.
  // The accept() returns a new socket file descriptor for the accepted
  // connection.  So, the original socket file descriptor can continue to be
  // used for accepting new connections while the new socker file descriptor
  // is used for communicating with the connected client.
  int newsockfd =
    accept(sockfd, (struct sockaddr *) &cli;_addr, &clilen;);

  if (newsockfd < 0) 
    error("ERROR on accept");

  printf("server: got connection from %s port %d\n",
	 inet_ntoa(cli_addr.sin_addr), ntohs(cli_addr.sin_port));
  return newsockfd;
}


/*
   Plain read() may not read all bytes requested in the buffer, so
   read_all() loops until all data was indeed read, or exits in
   case of failure, except for EINTR. The way the EINTR condition is
   handled is the standard way of making sure the process can be suspended
   with CTRL-Z and then continue running properly.

   Returns false on read error or EOF.
*/

bool read_all (int fd, unsigned char *buf, int len) {
  int received = 0;
  int rc;

  while (received < len) {
    rc = read(fd, buf + received, len - received);

    if ((rc < 0) && (errno == EINTR))
      continue;

    if (rc < 0) {
      perror("read_all() failed to read");
      return false;
    }

    if (rc == 0) {
      fprintf(stderr, "Reached read EOF\n");
      return false;
    }

    received += rc;
  }
  return true;
}


/*
   Plain write() may not write all bytes requested in the buffer, so
   write_all() loops until all data was indeed written, or exits in
   case of failure, except for EINTR. The way the EINTR condition is
   handled is the standard way of making sure the process can be suspended
   with CTRL-Z and then continue running properly.

   Returns true on success, false if there is a write error or EOF.
*/

bool write_all(int fd, unsigned char *buf, int len) {
  int sent = 0;
  int rc;

  while (sent < len) {
    rc = write(fd, buf + sent, len - sent);

    if ((rc < 0) && (errno == EINTR))
      continue;

    if (rc < 0) {
      perror("write_all() failed to write");
      return false;
    }

    if (rc == 0) {
      fprintf(stderr, "Reached write EOF (?!)\n");
      return false;
    }

    sent += rc;
  }
  return true;
}



// Number of input channels configured in the FPGA, 3 per card.
const int READ_CHANNELS = 6;

// Number of write channels to DAC board.
const int WRITE_CHANNELS = 4;

// Number of samples in each read/write block.  See "Modulation info"
// "Read size" in Labview.
const int READ_SAMPLES = 4096;

// Size in bytes of read and write blocks.
const int READ_SIZE = READ_SAMPLES * READ_CHANNELS * sizeof(int32);
const int WRITE_SIZE = WRITE_SAMPLES * WRITE_CHANNELS * sizeof(int32);

const char *read_fifo_name = "/dev/xillybus_read_32";
const char *write_fifo_name = "/dev/xillybus_write_32";

// We want the DAC output to the source and the ADC input to stay in lock-step
// synchronization, one DAC output buffer per ADC input block.  The simplest
// way to do that is to just do all the IOs sequentially in a single loop.
// 
// ### would be better to use two threads here.  On the client end the
// alternate sequential write/read is good because it meters the output rate,
// but here both the read and write are metered by the hardware
// itself. The sequential write/read just creates unnecessary problems with
// underrun/overrun and latency. 
// 
// While there is a fixed alignment (phase relationship) between input and
// output, we need to have considerable latency, with multiple buffers "in
// flight" in order to cover network delays upstream between here and the
// Labview client, and also and downstream between here and the hardware
// FIFOs.
//
// In order to get the fixed synchronization between the DAC output and ADC
// input, the FPGA begins ADC input when the first output data arrives at the
// DAC.  Once the hardware starts, it is necessary for there to be new output
// data whenever the DAC is ready (or there is an underrun), and the read FIFO
// needs to stay sufficiently drained that the the DAC doesn't drop data (and
// overrun).  Currently all the buffering is happening elswhere, in the
// local and remote network stacks, and in the Xillybus code.
//
// The case of DAC underrun needs more explicit management from us.  Since we
// read and write 1-1 there is no way for writing to "get ahead" unless we
// make it happen.  What we do is "write ahead".  The client writes several
// buffers before it starts reading anything.  This allows writing of the first
// buffers to happen faster than the steady-state conversion rate.  The client
// also does the same 1-1 write->read sequence.  We expect that normally the
// client will (on its end) be blocking on the read of input data from the TCP
// connection, and that we here will be block on the read of input data from
// the hardware.
//
// We want to minimize the latency seen by the ADC data, which is what
// blocking on the reads gets us.  Delay in the write pipe is not so much of a
// concern because the write data does not change rapidly from one buffer to
// the next (if at all).
//
void serve_client (int fd) {
  char read_buf [READ_SIZE];
  char write_buf [WRITE_SIZE];

  int read_fd = open(read_fifo_name, O_RDONLY);
  if (read_fd < 0) 
    error("Failed to open %s", read_fifo_name);
  int write_fd = open(write_fifo_name, O_WRONLY);
  if (write_fd < 0) 
    error("Failed to open %s", write_fifo_name);

  while (1) {
    if (!read_all(fd, &write_buf, WRITE_SIZE))
      return;
    if (!write_all(write_fd, &write_buf, WRITE_SIZE))
      return;
    if (!read_all(read_fd, &read_buf, READ_SIZE))
      return;
    if (!write_all(fd, &read_buf, READ_SIZE))
      return;
  }
}

int main(int argc, char *argv[])
{
  int portno;
  socklen_t clilen;
  char buffer[256];
  int n;
  if (argc >= 2) {
    portno = atoi(argv[1]);
  } else {
    portno = PORTNO_DEFAULT;
  }
     
  init_listener(portno);
  while (true) {
    int client_fd = accept_fd();
    serve_client(client_fd);
    close(client_fd);
  }
  return 0; 
}
