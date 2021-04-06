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
#include <arpa/inet.h>
#include <errno.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/time.h>
#include <pthread.h>
#include <signal.h>

// If true, spew output about each IO
int io_trace = 0;

uint64_t ms_time () {
  struct timeval time_now;
  gettimeofday(&time_now, NULL);
  return  (time_now.tv_sec * 1000) + (time_now.tv_usec / 1000);
}


const int PORTNO_DEFAULT = 6666;

int accept_fd;

void init_listener (int portno) {
  struct sockaddr_in serv_addr;
  // create a socket
  // socket(int domain, int type, int protocol)
  accept_fd = socket(AF_INET, SOCK_STREAM, 0);
  if (accept_fd < 0) {
    perror("ERROR opening socket");
    exit(1);
  }

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
	   sizeof(serv_addr)) < 0) {
    perror("ERROR on binding");
    exit(1);
  }

  // This listen() call tells the socket to listen to the incoming
  // connections.  The listen() function places all incoming connection into a
  // backlog queue until accept() call accepts the connection.  Here, we set
  // the maximum size for the backlog queue to 5.
  listen(accept_fd,5);
}


int accept_connection () {
  struct sockaddr_in cli_addr;
  // The accept() call actually accepts an incoming connection
  socklen_t clilen = sizeof(cli_addr);

  // This accept() function will write the connecting client's address info
  // into the the address structure and the size of that structure is clilen.
  // The accept() returns a new socket file descriptor for the accepted
  // connection.  So, the original socket file descriptor can continue to be
  // used for accepting new connections while the new socker file descriptor
  // is used for communicating with the connected client.
  int newsockfd =
    accept(accept_fd, (struct sockaddr *) &cli_addr, &clilen);

  if (newsockfd < 0) {
    perror("ERROR on accept");
    exit(1);
  }

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
const int IO_SAMPLES = 4096;

// Size in bytes of read and write blocks.
const int READ_SIZE = IO_SAMPLES * READ_CHANNELS * sizeof(int32_t);
const int WRITE_SIZE = IO_SAMPLES * WRITE_CHANNELS * sizeof(int32_t);

const char *read_fifo_name = "/dev/xillybus_read_32";
const char *write_fifo_name = "/dev/xillybus_write_32";

struct IOState {
  int client_fd;
  int read_fd;
  int write_fd;
  uint64_t t0;
};

void *read_loop (void *arg) {
  unsigned char read_buf [READ_SIZE];
  IOState *state = static_cast<IOState *>(arg);
  int iter = 0;
  printf("begin read_loop\n");
  while (1) {
    if (!read_all(state->read_fd, read_buf, READ_SIZE))
      return NULL;
    // ### hack: discard first read block, which is corrupted due to
    // ### some sort of FPGA driver issues.
    if (iter != 0) {
      if (!write_all(state->client_fd, read_buf, READ_SIZE))
	return NULL;
    }
    if (io_trace)
      printf("%d %.03f: read %d\n", iter, ((double)(ms_time() - state->t0))/1000,
	     read_buf[0]);
    iter++;
  }
}

void *write_loop (void *arg) {
  unsigned char write_buf [WRITE_SIZE];
  IOState *state = static_cast<IOState *>(arg);
  int iter = 0;
  printf("begin write_loop\n");
  while (1) {
    if (!read_all(state->client_fd, write_buf, WRITE_SIZE))
      return NULL;
    if (!write_all(state->write_fd, write_buf, WRITE_SIZE))
      return NULL;
    if (io_trace)
      printf("%d %.03f: write %d\n", iter, ((double)(ms_time() - state->t0))/1000,
	     write_buf[0]);
    iter++;
  }
}

// We want the DAC output to the source and the ADC input to stay in lock-step
// synchronization, one DAC output block per ADC input block.
// 
// On the client end we use an alternate sequential write/read because it
// meters the output rate, but here both the read and write are metered by the
// hardware itself.  So we have separate threads for reading and writing,
// which keeps the hardware fed as well as possible and minimizes latency.
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
  IOState state;
  
  int read_fd = open(read_fifo_name, O_RDONLY);
  if (read_fd < 0) {
    perror("Failed to open for read");
    exit(1);
  }
  int write_fd = open(write_fifo_name, O_WRONLY);
  if (write_fd < 0) {
    perror("Failed to open for write");
    exit(1);
  } 
  state.client_fd = fd;
  state.read_fd = read_fd;
  state.write_fd = write_fd;
  state.t0 = ms_time();

  pthread_t w_thread, r_thread;
  pthread_create(&r_thread, NULL, read_loop, &state);
  pthread_create(&w_thread, NULL, write_loop, &state);
  pthread_join(r_thread, NULL);
  pthread_join(w_thread, NULL);
  close(read_fd);
  close(write_fd);
}


int main(int argc, char *argv[]) {

  // Don't terminate on write to closed pipe.
  struct sigaction action;
  action.sa_handler = SIG_IGN;
  action.sa_flags = SA_SIGINFO;
  sigaction(SIGPIPE, &action, NULL);
  
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
    printf("Listening\n");
    int client_fd = accept_connection();
    serve_client(client_fd);
    printf("serve_clent returned\n");
    close(client_fd);
  }
  return 0; 
}
