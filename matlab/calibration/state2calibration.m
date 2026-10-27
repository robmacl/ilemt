function [calibration] = state2calibration (state, options)
% Given calibration optimizer state vector, return calibration struct.  See
% also calibration2state().
%
% Source and sensor parameters are represented as a 3x3 matrix, where
% columns are the coils (X, Y, Z), and rows are the vector/point XYZ
% coordinates in the source or sensor coordinate system.
% 
% d_source_pos, q_source_pos:
%     2D matrix of source coil positions (in source coordinates, in meters).
%
% d_source_moment, q_source_moment:
%     Source moment vectors matrix.  The direction of the vector is the
%     coil axis, and the magnitude is the coil gain.
%
% d_sensor_pos, q_sensor_pos:
% d_sensor_moment, q_sensor_moment:
%     Offset and moment of sensor coils, in sensor coordinates.
% 
  state_defs;
    
  % DIPOLE
  % position and moment of X Y Z source coils in source coordinates
  calibration.d_source_pos = [...
      state(source_x_pos_slice)' ...
      state(source_y_pos_slice)' ...  
      [0 0 0]'];
  
  calibration.d_source_moment = [...
      state(source_x_moment_slice)' ...
      state(source_y_moment_slice)' ...  
      [0 0 state(source_z_gain)]'];
  
  % position and orientation of X Y Z sensor coils in sensor coordinates
  calibration.d_sensor_pos = [...
      state(sensor_x_pos_slice)' ...
      state(sensor_y_pos_slice)' ...  
      [0 0 0]'];
  
  calibration.d_sensor_moment = [...
      state(sensor_x_moment_slice)' ...
      state(sensor_y_moment_slice)' ...  
      [0 0 state(sensor_z_gain)]'];


  % fixture transforms
  calibration.source_fixture = ...
      [state(source_fixture_pos_slice) state(source_fixture_orientation_slice)];

  calibration.stage_fixture = ...
      [state(stage_fixture_pos_slice) state(stage_fixture_orientation_slice)];
    
  calibration.sensor_fixture =...
      [state(sensor_fixture_pos_slice) state(sensor_fixture_orientation_slice)];

  % Stage rotation axis alignment, see motion_transforms().
  calibration.axis_fixture = state(axis_fixture_slice);

  % Octupole parameter s (mm^2) for each source and sensor coil, see
  % forward_kinematics().
  calibration.o_source = state(oct_source_slice);
  calibration.o_sensor = state(oct_sensor_slice);
  % Octupole transverse anisotropy t (mm^2) for each coil.
  calibration.a_source = state(aniso_source_slice);
  calibration.a_sensor = state(aniso_sensor_slice);
  % Geometric source winding dimensions [a; b; L] (mm), coils as columns.
  calibration.g_source = reshape(state(geom_source_slice), 3, 3);

  % Stage translation scale errors (per mille), see motion_transforms().
  calibration.stage_scale = state(stage_scale_slice);


  % QUADRUPOLE  
  calibration.q_source_pos = [...
      state(qp_source_x_pos_slice)' ...
      state(qp_source_y_pos_slice)' ...  
      state(qp_source_z_pos_slice)'];
  
  calibration.q_source_moment = [...
      state(qp_source_x_moment_slice)' ...
      state(qp_source_y_moment_slice)' ...  
      state(qp_source_z_moment_slice)'];
  
  % position and orientation of X Y Z sensor coils in sensor coordinates
  calibration.q_sensor_pos = [...
      state(qp_sensor_x_pos_slice)' ...
      state(qp_sensor_y_pos_slice)' ...  
      state(qp_sensor_z_pos_slice)'];
  
  calibration.q_sensor_moment = [...
      state(qp_sensor_x_moment_slice)' ...
      state(qp_sensor_y_moment_slice)' ...  
      state(qp_sensor_z_moment_slice)'];
  
  % quadrupole source distance
  calibration.q_source_distance = state(qp_so_dist); 
  
  % quadrupole sensor distance
  calibration.q_sensor_distance = state(qp_se_dist); 

  % This is not part of the state, but is used in forward kinematics and
  % pose solution, when we only have a calibration.
  calibration.pin_quadrupole = options.pin_quadrupole;
  calibration.source_geometric = isfield(options, 'source_geometric') ...
      && options.source_geometric;

  % We save the options in the calibration for documentation.  Anything
  % that actually affects the forward kinematics should be explicitly at
  % top level.
  calibration.options = options;
end
