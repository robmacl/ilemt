function [state] = calibration2state ...
    (calibration, source_fix_pose_vec, sensor_fixture_pose_vec)
% Create a calibration state vector from a calibration struct and fixture
% poses.  The poses are represented as a 6 element "pose vector", as used
% in the magnetic pose solution.  However the Z translation of the
% sensor fixture is ignored.

    state_defs;
    % indices of the state vector came from the state_defs script
    
    %dipole source position
    state(source_x_pos_slice) = calibration.d_source_pos(:, 1)';
    state(source_y_pos_slice) = calibration.d_source_pos(:, 2)';
    
    %dipole source moment
    state(source_x_moment_slice) = calibration.d_source_moment(:, 1)';
    state(source_y_moment_slice) = calibration.d_source_moment(:, 2)';
    
    %dipole sensor position
    state(sensor_x_pos_slice) = calibration.d_sensor_pos(:, 1)';
    state(sensor_y_pos_slice) = calibration.d_sensor_pos(:, 2)';
    
    %dipole sensor moment
    state(sensor_x_moment_slice) = calibration.d_sensor_moment(:, 1)';
    state(sensor_y_moment_slice) = calibration.d_sensor_moment(:, 2)';
    state(sensor_z_gain) = calibration.d_sensor_moment(3, 3);
    
    % source fixture
    state(source_fixture_pos_slice) = source_fix_pose_vec(1,1:3);
    state(source_fixture_orientation_slice) = source_fix_pose_vec(1,4:6);
    
    %sensor fixture
    state(sensor_fixture_pos_slice) = sensor_fixture_pose_vec(1,1:3);
    state(sensor_fixture_orientation_slice) = sensor_fixture_pose_vec(1,4:6); 
    
    %quadupole source position
    state(qp_source_x_pos_slice) = calibration.q_source_pos(:, 1)';
    state(qp_source_y_pos_slice) = calibration.q_source_pos(:, 2)';
    state(qp_source_z_pos_slice) = calibration.q_source_pos(:, 3)';
    
    %quadrupole source moment
    state(qp_source_x_moment_slice) = calibration.q_source_moment(:, 1)';
    state(qp_source_y_moment_slice) = calibration.q_source_moment(:, 2)';
    state(qp_source_z_moment_slice) = calibration.q_source_moment(:, 3)';
    
    %quadrupole sensor positione
    state(qp_sensor_x_pos_slice) = calibration.q_sensor_pos(:, 1)';
    state(qp_sensor_y_pos_slice) = calibration.q_sensor_pos(:, 2)';
    state(qp_sensor_z_pos_slice) = calibration.q_sensor_pos(:, 3)';
    
    %quadrupole sensor moment
    state(qp_sensor_x_moment_slice) = calibration.q_sensor_moment(:, 1)';
    state(qp_sensor_y_moment_slice) = calibration.q_sensor_moment(:, 2)';
    state(qp_sensor_z_moment_slice) = calibration.q_sensor_moment(:, 3)';
    
    %quadrupole source distance
    state(qp_so_dist) = calibration.q_source_distance;
    %quadrupole sensor distance
    state(qp_se_dist) = calibration.q_sensor_distance;
end

