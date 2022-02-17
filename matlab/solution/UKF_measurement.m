function [y_k] = UKF_measurement (x_k, calibration, state_info)
% The measurement function used in the UKF.  y_k is the predicted measurement,
% and x_k is the current state.

% pose converted into a transform matrix
pose = x_k([state_info.x_hi:state_info.z_hi state_info.Rx_hi:state_info.Rz_hi]);
P = pose2trans(pose');

% predicted coupling matrix obtained when the sensor is in a
% specified pose with respect to the source.
y_k = reshape(forward_kinematics(P, calibration), [], 1);
