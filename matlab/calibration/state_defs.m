%This file defines the locations of the values of the calibration
%optimization state vector.

%number of element in the state vector
num_state = 109;

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

% Stage rotation axis alignment wrt. the stage translation axes, a rotation
% vector.  See motion_transforms().  The component about the rotation axis
% itself is redundant with the sensor fixture, so freeze it (eg. y_ax_fix for
% the Ry stage).
axis_fixture_slice = 83:85;

% Octupole (finite coil size) parameter s for each source and sensor coil
% (X Y Z), in mm^2.  See forward_kinematics().
oct_source_slice = 86:88;
oct_sensor_slice = 89:91;

% Stage translation scale errors for stage X Y Z, per mille.  See
% motion_transforms().
stage_scale_slice = 92:94;

% Octupole transverse anisotropy t for each source and sensor coil, in mm^2:
% the difference of the winding variances along the two transverse axes.
% See forward_kinematics().
aniso_source_slice = 95:97;
aniso_sensor_slice = 98:100;

% Geometric (current sheet) source winding dimensions, mm: [a b L] for
% each source coil, used when options.source_geometric.  See
% fk_coupling_geom().
geom_source_slice = 101:109;


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

    'ax_fix' [axis_fixture_slice]
    'x_ax_fix' [axis_fixture_slice(1)]
    'y_ax_fix' [axis_fixture_slice(2)]
    'z_ax_fix' [axis_fixture_slice(3)]

    'st_scale' [stage_scale_slice]
    'x_st_scale' [stage_scale_slice(1)]
    'y_st_scale' [stage_scale_slice(2)]
    'z_st_scale' [stage_scale_slice(3)]

% Octupole (finite coil size), one parameter per coil:
    'o_so' [oct_source_slice]
    'o_se' [oct_sensor_slice]
% Octupole transverse anisotropy, one parameter per coil:
    'a_so' [aniso_source_slice]
    'a_se' [aniso_sensor_slice]
% Geometric source winding dimensions (with options.source_geometric):
    'g_so' [geom_source_slice]


% Quadrupole:
    'q_so_pos' [qp_source_x_pos_slice qp_source_y_pos_slice qp_source_z_pos_slice]
    'q_so_mo', [qp_source_x_moment_slice qp_source_y_moment_slice qp_source_z_moment_slice]
    'q_se_pos' [qp_sensor_x_pos_slice qp_sensor_y_pos_slice qp_sensor_z_pos_slice]
    'q_se_mo' [qp_sensor_x_moment_slice qp_sensor_y_moment_slice qp_sensor_z_moment_slice]

    % Distance between quadrupole component dipoles
    'q_so_dist' [qp_so_dist]
    'q_se_dist' [qp_se_dist]

}; % end state_parts
