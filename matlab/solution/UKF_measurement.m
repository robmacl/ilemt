function [y_k] = UKF_measurement (x_k, calibration)
% The measurement function used in the UKF.  y_k is the predicted measurement,
% and x_k is the current state.

% pose converted into a transform matrix
P = pose2trans(x_k');

% predicted coupling matrix obtained when the sensor is in a
% specified pose with respect to the source.
y_k = reshape(forward_kinematics(P, calibration), [], 1);
