function [bounds] = state_bounds (state0, freeze)
% freeze: cell vector char vectors, names of state components which 
% we are not going to allow to move from the initial value.
%
% 'bounds' specifies the lower and upper bounds on each state element. This
% is a 2xN vector, where the first row is the lower bounds, and the second
% row is the upper bounds.  For almost all elements the bounds are 
% [-Inf; Inf], specifying no limit;  State0 is the initial state.

state_defs;
bounds = repmat([-Inf; Inf], 1, num_state);

freeze_ixs = [];

%DIPOLE
if (any(strcmp('d_so_pos', freeze)))
  % freeze source position
  freeze_ixs = [freeze_ixs source_x_pos_slice source_y_pos_slice];
end

if (any(strcmp('d_so_mo', freeze)))
  % freeze source moments
  freeze_ixs = [freeze_ixs source_x_moment_slice source_y_moment_slice];
end

if (any(strcmp('d_se_pos', freeze)))
  % freeze sensor position
  freeze_ixs = [freeze_ixs sensor_x_pos_slice sensor_y_pos_slice];
end

if (any(strcmp('d_se_mo', freeze)))
  % freeze sensor moments
  freeze_ixs = [freeze_ixs sensor_x_moment_slice sensor_y_moment_slice sensor_z_gain];
end

if (any(strcmp('so_fix', freeze)))
  % freeze source fixture
  freeze_ixs = [freeze_ixs source_fixture_pos_slice source_fixture_orientation_slice];
end

if (any(strcmp('x_so_fix', freeze)))
  % freeze x component of source fixture
  freeze_ixs = [freeze_ixs source_fixture_pos_slice(1)];
end

if (any(strcmp('y_so_fix', freeze)))
  % freeze y component of source fixture
  freeze_ixs = [freeze_ixs source_fixture_pos_slice(2)];
end

if (any(strcmp('z_so_fix', freeze)))
  % freeze z component of source fixture
  freeze_ixs = [freeze_ixs source_fixture_pos_slice(3)];
end

if (any(strcmp('se_fix', freeze)))
  % freeze sensor fixture
  freeze_ixs = [freeze_ixs sensor_fixture_pos_slice sensor_fixture_orientation_slice];
end

if (any(strcmp('x_se_fix', freeze)))
  % freeze x component of  sensor fixture
  freeze_ixs = [freeze_ixs sensor_fixture_pos_slice(1)];
end

if (any(strcmp('y_se_fix', freeze)))
  % freeze y component of sensor fixture
  freeze_ixs = [freeze_ixs sensor_fixture_pos_slice(2)];
end

if (any(strcmp('z_se_fix', freeze)))
  % freeze z component of sensor fixture
  freeze_ixs = [freeze_ixs sensor_fixture_pos_slice(3)];
end

if (any(strcmp('d_so_y_co', freeze)))
  % freeze source y component of x coil
  freeze_ixs = [freeze_ixs source_x_moment_slice(2)];
end

if (any(strcmp('d_se_y_co', freeze)))
  % freeze sensor y component of x coil
  freeze_ixs = [freeze_ixs sensor_x_moment_slice(2)];
end



%QUADRUPOLE
if (any(strcmp('q_so_pos', freeze)))
  % freeze source position
  freeze_ixs = [freeze_ixs qp_source_x_pos_slice qp_source_y_pos_slice qp_source_z_pos_slice];
end

if (any(strcmp('q_so_mo', freeze)))
  % freeze source moments
  freeze_ixs = [freeze_ixs qp_source_x_moment_slice qp_source_y_moment_slice qp_source_z_moment_slice];
end

if (any(strcmp('q_se_pos', freeze)))
  % freeze sensor position
  freeze_ixs = [freeze_ixs qp_sensor_x_pos_slice qp_sensor_y_pos_slice qp_sensor_z_pos_slice];
end

if (any(strcmp('q_se_mo', freeze)))
  % freeze sensor moments
  freeze_ixs = [freeze_ixs qp_sensor_x_moment_slice qp_sensor_y_moment_slice qp_sensor_z_moment_slice];
end

if (any(strcmp('q_so_dist', freeze)))
  % freeze quadrupole source distance
  freeze_ixs = [freeze_ixs qp_so_dist];
end

if (any(strcmp('q_se_dist', freeze)))
  % freeze quadrupole sensor distance
  freeze_ixs = [freeze_ixs qp_se_dist];
end

 
  for ix = freeze_ixs
    bounds(:, ix) = state0(ix);
  end

         
end
