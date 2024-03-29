% Poses: struct containing:
% - poses: N x 6 array of poses
% - valid: N x 1 array of booleans
% - timestamp: N x 1 array of timestamps
% - entry_type: N x 1 array of integers. 0 = high freq, 1 = low freq, 2 =
% high at low freq
%poses = load('track_poses');

% Time increment (high rate)
dt = mean(diff(poses.timestamp(poses.entry_type == 0)));

% ### fix below here to use 'poses', need to figure out how the 'collection'
% works below.  I guess it is figuing out of this is a combined high/low
% update, or high only.

collection = zeros(size(poses.poses,1),20);

ix = 1;
collection_ix = 1;

% Step input
step = false;
step_size = 0.001; % m
step_time = 1; % s
start_time = poses.timestamp(1);

% Separate low and high information
while ix < length(poses.poses)

    ix;
    
    timestamp = poses.timestamp(ix);
    
    if poses.entry_type(ix+1) == 1
        combined_update = true;
        p = [poses.poses(ix, :), poses.poses(ix+1, :), poses.poses(ix+2, :)];
        ix = ix + 3; % point to next high rate input with a 0 ID marker
        
        if step && timestamp - start_time >= step_time
            % Add step input to Zs
            p(3) = p(3) + step_size;
            p(9) = p(9) + step_size;
            p(15) = p(15) + step_size;
        end
    else 
        combined_update = false;
        p = [poses.poses(ix,:), zeros(1,12)];
        ix = ix + 1;
        if step && timestamp - start_time >= step_time
            % Add step input to Zs
            p(3) = p(3) + step_size;
        end
    end
    
    collection(collection_ix, :) = [timestamp, combined_update, p];
    collection_ix = collection_ix + 1;
end

collection = collection(1:collection_ix-1,:);

% State vector format
  state_x_hi = 1;
  state_y_hi = 2;
  state_z_hi = 3;
  state_vel_x = 4;
  state_vel_y = 5;
  state_vel_z = 6;
  state_acc_x = 7;
  state_acc_y = 8;
  state_acc_z = 9;
  state_Rx_hi = 10;
  state_Ry_hi = 11;
  state_Rz_hi = 12;
  state_w_x = 13;
  state_w_y = 14;
  state_w_z = 15;
 
  % bias terms
  state_x_low = 16;
  state_y_low = 17;
  state_z_low = 18;
  state_Rx_low = 19;
  state_Ry_low = 20;
  state_Rz_low = 21;

 state_size = 21;
 
% Kalman Filter Implementation

I = eye(state_size);
M = 0.05;

% Measurement noise
% Using high rate noise for bias because this dominates the noise in the
% bias.
R = blkdiag(eye(3)*calibration.high_rate.w_trans, eye(3)*calibration.high_rate.w_rot, ...
     eye(3)*calibration.low_rate.w_trans, eye(3)*calibration.low_rate.w_rot).^2;

% Process noise parameters.
base_process_noise = 1e-5;
process_trans_hi = base_process_noise;
process_trans_corr = 0;
process_rot_hi = base_process_noise;
process_rot_corr = 0;
process_vel = base_process_noise * 10;
process_acc = base_process_noise * 100;
process_w = base_process_noise * 10;

process_trans_low = base_process_noise; % for bias
process_rot_low = base_process_noise; % for bias


% Start with diagonal process noise.
Q = blkdiag(eye(3)*process_trans_hi, eye(3)*process_vel, eye(3)*process_acc, ...
            eye(3)*process_rot_hi, eye(3)*process_w, ...
            eye(3)*process_trans_low, eye(3)*process_rot_low);

% Introduce correlated process noise between high and low position/rotation
% estimates.
Q_tc = eye(3)*process_trans_corr;
Q(state_x_hi:state_z_hi, state_x_low:state_z_low) = Q_tc;
Q(state_x_low:state_z_low, state_x_hi:state_z_hi) = Q_tc;

Q_rc = eye(3)*process_rot_corr;
Q(state_Rx_hi:state_Rz_hi, state_Rx_low:state_Rz_low) = Q_rc;
Q(state_Rx_low:state_Rz_low, state_Rx_hi:state_Rz_hi) = Q_rc;

Q = Q.^2 * dt;

x_est = zeros(state_size, 1);
init_pose = poses.poses(1,:); 
ip_rot = init_pose(4:end);
ip_trans = init_pose(1:3);
x_est(state_x_hi:state_z_hi) = ip_trans;
x_est(state_x_low:state_z_low) = ip_trans;
x_est(state_Rx_hi:state_Rz_hi) = ip_rot;
x_est(state_Rx_low:state_Rz_low) = ip_rot;

x_est = [poses.poses(1,:) zeros(1,15)]'; % initialize location
% x_est_save = [];

P = eye(state_size)*1000; % initialize state covariance
P_save = {};
P_save{1} = P;

unbias = zeros(size(collection,1),6); 

F = eye(state_size);
lin_rates_upd_1 = [eye(3)*dt eye(3)*dt^2/2];
lin_rates_upd_2 = eye(3)*dt;
F(state_x_hi:state_z_hi, state_vel_x:state_acc_z) = lin_rates_upd_1;
F(state_vel_x:state_vel_z, state_acc_x:state_acc_z) = lin_rates_upd_2;

rot_rates_upd = eye(3)*dt;
F(state_Rx_hi:state_Rz_hi, state_w_x:state_w_z) = rot_rates_upd;

H_lhf = eye(state_size);
measured_states = [state_x_hi:state_z_hi state_Rx_hi:state_Rz_hi  ...
                   state_x_low:state_z_low state_Rx_low:state_Rz_low];
H_lhf = H_lhf(measured_states, :);

H_hf = H_lhf;
H_hf(7:12,:) = 0; % zeroing out low rate inputs


result_pointer = 1;

for ix = 1:length(collection)

    ix
    
    timestamp = collection(ix,1);
    
    % low and high frequency Kalman Filter
    if collection(ix,2) == 1
        combined_update = true;
        H = H_lhf;
        
        delay = pose2trans(collection(ix, 15:20));       
        low_trans = pose2trans(collection(ix,9:14)); 
        bias = (inv(delay)*low_trans);
        new_pose = trans2pose(bias);
        
        % for updating
        input4y = [collection(ix,3:8) new_pose]';
 
    else
        combined_update = false;    
        H = H_hf;   
        
        % for updating
        input4y = collection(ix,3:end-6)'; % does not matter what low rate values are, dropped out by input transform
    end
    
    % predicting
    x_est = F*x_est; % predict step
    % x_est_save = [x_est_save, x_est];
    P = F*P*F' + Q; % predict covariance
    
    % updating
    y = input4y - H*x_est; % innovation
    S = H*P*H' + R; % innovation covariance
    K = P*H'*S^(-1); % Kalman gain
    x_est = x_est + K*y; % update state
    % x_est_save = [x_est_save, x_est];
    P = (I - K*H)*P; % update covariance
    P_save{end+1} = P;
    
    x_est_ID(result_pointer,:) = [timestamp; combined_update; x_est];
    
    % unbiasing
    x_est_hi_trans = pose2trans(x_est([state_x_hi:state_z_hi, state_Rx_hi:state_Rz_hi]));
    x_est_bias_trans = pose2trans(x_est([state_x_low:state_z_low, state_Rx_low:state_Rz_low]));
    
    unbias(result_pointer,:) = trans2pose(x_est_hi_trans*x_est_bias_trans); % actual output we hope is cool
    result_pointer = result_pointer + 1;
end

x_est_ID = x_est_ID(1:result_pointer-1,:);
unbias = unbias(1:result_pointer-1,:);
