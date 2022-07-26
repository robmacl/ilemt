function [poses, resnorms] = pose_solve_dual_UKF_high (couplings, calibration, options)
% Pose solution using Unscented Kalman Filter.  The state representation is
% the pose vector, and the measurement is the (real) coupling matrix.

couplings = real_coupling(couplings);

% Standard deviation or RMS value of the noise components, squared to get
% variance.  The time scale is per-sample (full rate).
% ### Need different parameters for low rate.
% 
% Coupling noise, arbitrary units determined by system gains.
% ### in point data this small value helps the solution to converge rapidly
% during the reinitialization on each point.
options.measurement_noise = 1e-7; % from couplings
% 
% Constant position model for motion (random walk).  Units are
% meters/radians.
base_process_noise = 1e-5;
options.process_noise_trans = base_process_noise;
options.process_noise_rot = base_process_noise;
options.process_noise_vel = base_process_noise * 10;
options.process_noise_acc = base_process_noise * 100;
options.process_noise_w = base_process_noise * 10;

% State variance estimate on initialization and reinintialization.  The
% state covariance is used to determine how widely to spread the sigma
% points.  If it is too large, then we consider too distant states during
% the first iteration.
initial_variance = 0.001^2;

% On initialization, the number of times to iterate the measurement step 
initialize_iterations = 20;

% State vector format
  state_info.x_hi = 1;
  state_info.y_hi = 2;
  state_info.z_hi = 3;
  state_info.vel_x = 4;
  state_info.vel_y = 5;
  state_info.vel_z = 6;
  state_info.acc_x = 7;
  state_info.acc_y = 8;
  state_info.acc_z = 9;
  state_info.Rx_hi = 10;
  state_info.Ry_hi = 11;
  state_info.Rz_hi = 12;
  state_info.w_x = 13;
  state_info.w_y = 14;
  state_info.w_z = 15;
 
%   % bias terms
%   state_info.x_low = 16;
%   state_info.y_low = 17;
%   state_info.z_low = 18;
%   state_info.Rx_low = 19;
%   state_info.Ry_low = 20;
%   state_info.Rz_low = 21;

 state_info.size = 15;

npoints = size(couplings, 3);
poses = zeros(npoints, 6);
state_vec = zeros(npoints, state_info.size);
resnorms = zeros(1, npoints);

process_cov = [repmat(options.process_noise_trans, 1, 3), ...
               repmat(options.process_noise_vel, 1, 3), ...
               repmat(options.process_noise_acc, 1, 3), ...
               repmat(options.process_noise_rot, 1, 3), ...
               repmat(options.process_noise_w, 1, 3)].^2;

ukf = unscentedKalmanFilter(...
    @(x_k) UKF_state_transition(x_k, state_info), ...
    @(x_k) UKF_measurement(x_k([state_info.x_hi:state_info.z_hi state_info.Rx_hi:state_info.Rz_hi]), calibration), ...
    'MeasurementNoise', options.measurement_noise.^2, ...
    'ProcessNoise', diag(process_cov) ...
);


% We use the estimate from kim18 as the initial state.  For discontinuous
% data, such as from the calibration stage, we reinitialize for each point.
% While not a particularly good test of the filter, we repeatedly run the
% measurement step with the same data (the "correct(ukf)" command).  This
% gives the nonlinear estimation a chance to converge.  We are in effect
% using the UKF as an optimizer.

for (ix = 1:npoints)
  ix

  couplings1 = couplings(:, :, ix);
  y_n = reshape(couplings1, [], 1);

  if (ix == 1)
    opt = track_options();
    opt.cal_file_base = '../cal_9_1_premo_rotated_dipole/output/XYZ';
    opt.concentric_cal_file = [opt.cal_file_base '_concentric_hr_cal'];
    [pose0, ~, ~] = pose_solution(couplings(:, :, ix), calibration, opt, 3);
    x0 = zeros(1, state_info.size);
    x0([state_info.x_hi:state_info.z_hi state_info.Rx_hi:state_info.Rz_hi]) = pose0;
    ukf.State = x0; % include vel/acc
    ukf.StateCovariance = ones(state_info.size) * initial_variance;
  end

  resnorms(ix) = sum(residual(ukf, y_n).^2)/norm(couplings1);
  state_ix = correct(ukf, reshape(y_n, [], 1))';
  poses(ix, :) = state_ix([state_info.x_hi:state_info.z_hi state_info.Rx_hi:state_info.Rz_hi]);
  state_vec(ix, :) = state_ix;
  
  % If we had dynamics in our state transition (eg. constant velocity) then we
  % could reduce latency by using the predicted state as the output.  We
  % ignore the prediction for now, but the predict step is still a necessary
  % part of the filter, for example to incorporate the process noise
  predict(ukf);
  %keyboard
end

assignin('base','state_vec',state_vec);
