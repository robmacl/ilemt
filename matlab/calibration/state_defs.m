%This file defines the locations of the values of the calibration
%optimization state vector.

%number of element in the state vector
num_state = 82;

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

% stage fixture is out of order in the state, see below

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

% stage fixture
stage_fixture_pos_slice = 76:78;
stage_fixture_orientation_slice = 79:81;

% source Z moment is gain * [0 0 1]'
source_z_gain = 82;


% Cell array state_parts{n, 2}, a dictionary of state parts.  Each row is:
%    {<string name> <state index vector>}
%
state_parts = {
% Dipole:
    'd_so_pos' [source_x_pos_slice source_y_pos_slice]
    'd_so_mo' [source_x_moment_slice source_y_moment_slice source_z_gain]
    'd_se_pos' [sensor_x_pos_slice sensor_y_pos_slice]
    'd_se_mo' [sensor_x_moment_slice sensor_y_moment_slice sensor_z_gain]
    
    % One or the other of source and sensor Z gain must be fixed.
    'd_so_z_gain' [source_z_gain]
    'd_se_z_gain' [sensor_z_gain]
    
    % Y component of source or sense X moment, used to fix Rz rotation
    'd_so_y_co' [source_x_moment_slice(2)]
    'd_se_y_co' [sensor_x_moment_slice(2)]


% Fixture transforms, entire, and also X,Y,Z translation parts.  May need
% to fix parts of the translation if they are not observable from the
% calibration data, eg. when there is only Rz rotation (single fixturing).
    'so_fix' [source_fixture_pos_slice source_fixture_orientation_slice]
    'x_so_fix' [source_fixture_pos_slice(1)]
    'y_so_fix' [source_fixture_pos_slice(2)]
    'z_so_fix' [source_fixture_pos_slice(3)]

    'st_fix' [stage_fixture_pos_slice stage_fixture_orientation_slice]
    'x_st_fix' [stage_fixture_pos_slice(1)]
    'y_st_fix' [stage_fixture_pos_slice(2)]
    'z_st_fix' [stage_fixture_pos_slice(3)]

    'se_fix' [sensor_fixture_pos_slice sensor_fixture_orientation_slice]
    'x_se_fix' [sensor_fixture_pos_slice(1)]
    'y_se_fix' [sensor_fixture_pos_slice(2)]
    'z_se_fix' [sensor_fixture_pos_slice(3)]


% Quadrupole:
    'q_so_pos' [qp_source_x_pos_slice qp_source_y_pos_slice qp_source_z_pos_slice]
    'q_so_mo', [qp_source_x_moment_slice qp_source_y_moment_slice qp_source_z_moment_slice]
    'q_se_pos' [qp_sensor_x_pos_slice qp_sensor_y_pos_slice qp_sensor_z_pos_slice]
    'q_se_mo' [qp_sensor_x_moment_slice qp_sensor_y_moment_slice qp_sensor_z_moment_slice]

    % Distance between quadrupole component dipoles
    'q_so_dist' [qp_so_dist]
    'q_se_dist' [qp_se_dist]

}; % end state_parts
