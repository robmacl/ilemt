function [poses, resnorms] = pose_solve_UKF (couplings, calibration, options)
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
options.measurement_noise = 1e-7;
% 
% Constant position model for motion (random walk).  Units are
% meters/radians.
options.process_noise_trans = 1e-4;
options.process_noise_rot = 1e-4;

% True if this a continuous motion time series, false if point-to-point stage
% data.
options.continuous_motion = false;

% State variance estimate on initialization and reinintialization.  The
% state covariance is used to determine how widely to spread the sigma
% points.  If it is too large, then we consider too distant states during
% the first iteration.
initial_variance = 0.001^2;

% On initialization, the number of times to iterate the measurement step 
initialize_iterations = 20;

npoints = size(couplings, 3);
poses = zeros(npoints, 6);
resnorms = zeros(1, npoints);

process_cov = [repmat(options.process_noise_trans, 1, 3), ...
               repmat(options.process_noise_rot, 1, 3)].^2;

ukf = unscentedKalmanFilter(...
    @(x_k) x_k, ...
    @(x_k) UKF_measurement(x_k, calibration), ...
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
  y_n = reshape(couplings(:, :, ix), [], 1);

  if (ix == 1 || ~options.continuous_motion)
    x0 = trans2pose(kim18(couplings(:, :, ix), calibration))';
    ukf.State = x0;
    ukf.StateCovariance = ones(6) * initial_variance;
    x_init = zeros(initialize_iterations, 6);
    for (iter = 1:initialize_iterations)
      x_init(iter, :) = correct(ukf, y_n)';
      predict(ukf);
    end
  end

  resnorms(ix) = sum(residual(ukf, y_n).^2);
  poses(ix, :) = correct(ukf, reshape(y_n, [], 1))';
  
  % If we had dynamics in our state transition (eg. constant velocity) then we
  % could reduce latency by using the predicted state as the output.  We
  % ignore the prediction for now, but the predict step is still a necessary
  % part of the filter, for example to incorporate the process noise
  predict(ukf);
  %keyboard
end
