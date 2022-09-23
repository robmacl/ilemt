function [x_k1] = UKF_state_transition (x_k, state_info)
% The state transition function used in the UKF.

dt = 1/1500;

% State transition matrix
F = eye(state_info.size);
lin_rates_upd_1 = [eye(3)*dt eye(3)*dt^2/2];
lin_rates_upd_2 = eye(3)*dt;
F(state_info.x_hi:state_info.z_hi, state_info.vel_x:state_info.acc_z) = lin_rates_upd_1;
F(state_info.vel_x:state_info.vel_z, state_info.acc_x:state_info.acc_z) = lin_rates_upd_2;

rot_rates_upd = eye(3)*dt;
F(state_info.Rx_hi:state_info.Rz_hi, state_info.w_x:state_info.w_z) = rot_rates_upd;

% Matrix multiplication to predict next state
x_k1 = F*x_k;
