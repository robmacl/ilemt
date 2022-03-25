function [poses, biases, resnorms] = pose_solve_dual_UKF (couplings_hi, couplings_lo, calibration_hi, calibration_lo, options)
% Pose solution using Unscented Kalman Filter.  The state representation is
% the pose vector, and the measurement is the (real) coupling matrix.

couplings_hi = real_coupling(couplings_hi);
couplings_lo = real_coupling(couplings_lo);

% Standard deviation or RMS value of the noise components, squared to get
% variance.  The time scale is per-sample (full rate).
% ### Need different parameters for low rate.
% 
% Coupling noise, arbitrary units determined by system gains.
% ### in point data this small value helps the solution to converge rapidly
% during the reinitialization on each point.
options.measurement_noise_lo = 1e-7;
options.measurement_noise_hi = options.measurement_noise_lo * 100;
% 
% Constant position model for motion (random walk).  Units are
% meters/radians.
base_process_noise = 2e-3;
options.process_noise_trans = base_process_noise;
options.process_noise_rot = base_process_noise * 2;
options.process_noise_bias = 1e-5;

% State variance estimate on initialization and reinintialization.  The
% state covariance is used to determine how widely to spread the sigma
% points.  If it is too large, then we consider too distant states during
% the first iteration.
initial_variance = 0.001^2;

% On initialization, the number of times to iterate the measurement step 
initialize_iterations = 20;

% State vector format
  state_info.x = 1;
  state_info.y = 2;
  state_info.z = 3;
  state_info.Rx = 4;
  state_info.Ry = 5;
  state_info.Rz = 6;

  state_info.bias_1 = 7;
  state_info.bias_2 = 8;
  state_info.bias_3 = 9;
  state_info.bias_4 = 10;
  state_info.bias_5 = 11;
  state_info.bias_6 = 12;
  state_info.bias_7 = 13;
  state_info.bias_8 = 14;
  state_info.bias_9 = 15;

 state_info.size = 15;

npoints = size(couplings_hi, 3);
poses = zeros(npoints, 6);
biases = zeros(npoints, 9);
resnorms = zeros(1, npoints);

measurement_cov = [repmat(options.measurement_noise_hi, 1, 9), ...
                   repmat(options.measurement_noise_lo, 1, 9)].^2;

process_cov = [repmat(options.process_noise_trans, 1, 3), ...
               repmat(options.process_noise_rot, 1, 3), ...
               repmat(options.process_noise_bias, 1, 9)].^2;

ukf = unscentedKalmanFilter(...
    @(x_k) x_k, ...
    @(x_k) dual_UKF_measurement(x_k, calibration_hi, calibration_lo, state_info), ...
    'MeasurementNoise', diag(measurement_cov), ...
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

  couplings_hi1 = reshape(couplings_hi(:, :, ix), [], 1);
  couplings_lo1 = reshape(couplings_lo(:, :, ix), [], 1);
  couplings1 = [couplings_hi1; couplings_lo1];
  y_n = reshape(couplings1, [], 1);

  if (ix == 1)
    opt = track_options();
    opt.cal_file_base = '../cal_9_1_premo_rotated_dipole/output/XYZ';
    opt.concentric_cal_file = [opt.cal_file_base '_concentric_lr_cal'];
    [pose0, ~, ~] = pose_solution(couplings_lo(:, :, ix), calibration_lo, opt, 3);
    x0 = zeros(1, state_info.size);
    x0(state_info.x:state_info.Rz) = pose0;
    ukf.State = x0; % include vel/acc
    ukf.StateCovariance = ones(state_info.size) * initial_variance;
  end

  resnorms(ix) = sum(residual(ukf, y_n).^2)/norm(couplings1);
  state_ix = correct(ukf, reshape(y_n, [], 1))';
  poses(ix, :) = state_ix(state_info.x:state_info.Rz);
  biases(ix, :) = state_ix(state_info.bias_1:state_info.bias_9);
  
  % If we had dynamics in our state transition (eg. constant velocity) then we
  % could reduce latency by using the predicted state as the output.  We
  % ignore the prediction for now, but the predict step is still a necessary
  % part of the filter, for example to incorporate the process noise
  predict(ukf);
  %keyboard
end
