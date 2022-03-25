function [y_k] = dual_UKF_measurement (x_k, calibration_hi, calibration_lo, state_info)
% The measurement function used in the UKF.  y_k is the predicted measurement,
% and x_k is the current state.

% pose converted into a transform matrix
pose = x_k(state_info.x:state_info.Rz);
P = pose2trans(pose');

% coupling bias
coupling_bias = reshape(x_k(state_info.bias_1:state_info.bias_9), [], 1);

% predicted coupling matrix obtained when the sensor is in a
% specified pose with respect to the source.
coupling_hi_at_lo = reshape(forward_kinematics(P, calibration_hi), [], 1) + coupling_bias;
coupling_lo = reshape(forward_kinematics(P, calibration_lo), [], 1);
y_k = [coupling_hi_at_lo; coupling_lo];