%This file defines the locations of the values of the calibration
%optimization state vector.

%number of element in the state vector
num_state = 75;

%dipole source position
source_x_pos_slice = 1:3;
source_y_pos_slice = 4:6;

%dipole source moment
source_x_moment_slice = 7:9;
source_y_moment_slice = 10:12;

%dipole sensor position
sensor_x_pos_slice = 13:15;
sensor_y_pos_slice = 16:18;

%dipole sensor moment
sensor_x_moment_slice = 19:21;
sensor_y_moment_slice = 22:24;

% sensor z is a single element, a scale factor applied to [0 0 1]
sensor_z_gain = 25;

%source fixture
source_fixture_pos_slice = 26:28;
source_fixture_orientation_slice = 29:31;

%sensor fixture
sensor_fixture_pos_slice = 32:34;
sensor_fixture_orientation_slice = 35:37;


%quadrupole source position
qp_source_x_pos_slice = 38:40;
qp_source_y_pos_slice = 41:43;
qp_source_z_pos_slice = 44:46;

%quadrupole source moment
qp_source_x_moment_slice = 47:49;
qp_source_y_moment_slice = 50:52;
qp_source_z_moment_slice = 53:55;

%quadrupole sensor position
qp_sensor_x_pos_slice = 56:58;
qp_sensor_y_pos_slice = 59:61;
qp_sensor_z_pos_slice = 62:64;

%quadrupole sensor moment
qp_sensor_x_moment_slice = 65:67;
qp_sensor_y_moment_slice = 68:70;
qp_sensor_z_moment_slice = 71:73;

%quadrupole source distance
qp_so_dist = 74;

%quadrupole sensor distance 
qp_se_dist = 75;


