function [state] = calibration2state (calibration)
% Create a calibration state vector from a calibration struct.  See also
% state2calibration(). 

    % indices into the state vector come from the state_defs script
    state_defs;

    state = zeros(1, num_state);
    
    %dipole source position
    state(source_x_pos_slice) = calibration.d_source_pos(:, 1)';
    state(source_y_pos_slice) = calibration.d_source_pos(:, 2)';
    
    %dipole source moment
    state(source_x_moment_slice) = calibration.d_source_moment(:, 1)';
    state(source_y_moment_slice) = calibration.d_source_moment(:, 2)';
    state(source_z_gain) = calibration.d_source_moment(3, 3);
    
    %dipole sensor position
    state(sensor_x_pos_slice) = calibration.d_sensor_pos(:, 1)';
    state(sensor_y_pos_slice) = calibration.d_sensor_pos(:, 2)';
    
    %dipole sensor moment
    state(sensor_x_moment_slice) = calibration.d_sensor_moment(:, 1)';
    state(sensor_y_moment_slice) = calibration.d_sensor_moment(:, 2)';
    state(sensor_z_gain) = calibration.d_sensor_moment(3, 3);
    
    % source fixture
    state(source_fixture_pos_slice) = calibration.source_fixture(1:3);
    state(source_fixture_orientation_slice) = calibration.source_fixture(4:6);

    % stage fixture
    state(stage_fixture_pos_slice) = calibration.stage_fixture(1:3);
    state(stage_fixture_orientation_slice) = calibration.stage_fixture(4:6);
    
    % sensor fixture
    state(sensor_fixture_pos_slice) = calibration.sensor_fixture(1:3);
    state(sensor_fixture_orientation_slice) = calibration.sensor_fixture(4:6);

    % Newer parts of the state, zero for older calibrations:
    % stage rotation axis alignment
    if (isfield(calibration, 'axis_fixture'))
      state(axis_fixture_slice) = calibration.axis_fixture;
    end
    % octupole
    if (isfield(calibration, 'o_source'))
      state(oct_source_slice) = calibration.o_source;
      state(oct_sensor_slice) = calibration.o_sensor;
    end
    % octupole transverse anisotropy
    if (isfield(calibration, 'a_source'))
      state(aniso_source_slice) = calibration.a_source;
      state(aniso_sensor_slice) = calibration.a_sensor;
    end
    % geometric source winding dimensions
    if (isfield(calibration, 'g_source'))
      state(geom_source_slice) = calibration.g_source(:)';
    end
    % stage translation scale
    if (isfield(calibration, 'stage_scale'))
      state(stage_scale_slice) = calibration.stage_scale;
    end
    
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

