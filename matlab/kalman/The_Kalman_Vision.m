close all 
clc

global calibration;

load('gain_calibration');
load('poses_ID');

%{
%dataNHM = dlmread('base noise value - no hand motion.txt');
dataHM = dlmread('high-low test3.txt'); % moving

dt = (dataHM(end,1) - dataHM(1,1))/size(dataHM,1);

pose0 = [0.5,0.5,1,0.5,0.5,0.5];
pose0 = [0,0,0,0.2,0,0];

pose00 = [0.5,0.5,1,0.5,0.5,0.5];
pose00 = [0,0,0,0.2,0,0];

lb = [-inf,-inf,-inf,0,-inf,-inf];
ub = [inf,inf,inf,inf,inf,inf];

%poses_NHM = coupling2pose(dataNHM,pose0,lb,ub);

poses_HM = coupling2pose(dataHM,pose0,lb,ub);

poses_ID = [];

for b = 1:size(dataHM,1)
    poses_new = [dataHM(b,2) poses_HM(b,:)];
    poses_ID = [poses_ID; poses_new];
end 

hf_poses = [];
lhf_poses = [];

for c = 1:length(poses_ID)
    if dataHM(c,2) == 0; % for high rate data
        pose1 = poses_ID(c,:);
        hf_poses = [hf_poses; pose1];
        
    else % for high and low rate data
        pose11 = poses_ID(c,:);
        lhf_poses = [lhf_poses; pose11];
    end
end

timeVec_hi = linspace(1,dataHM(end,1) - dataHM(1,1),length(hf_poses));
timeVec_low = linspace(1,dataHM(end,1) - dataHM(1,1),length(lhf_poses));

x_pos_hf = hf_poses(:,5);
y_pos_hf = hf_poses(:,6);
z_pos_hf = hf_poses(:,7);
Rx_hf = hf_poses(:,2);
Ry_hf = hf_poses(:,3);
Rz_hf = hf_poses(:,4);

x_pos_lf = lhf_poses(:,5);
y_pos_lf = lhf_poses(:,6);
z_pos_lf = lhf_poses(:,7);
Rx_lf = lhf_poses(:,2);
Ry_lf = lhf_poses(:,3);
Rz_lf = lhf_poses(:,4);
%}

dt = (poses_ID(end,1) - poses_ID(1,1))/size(poses_ID,1);

collection = zeros(size(poses_ID,1),20);

ix = 1;
collection_ix = 1;

% Separate low and high information
while ix < length(poses_ID)

    ix;
    
    timestamp = poses_ID(ix,1);
    
    if poses_ID(ix+1,2) == 1
        combined_update = true;
        p = [poses_ID(ix,3:end), poses_ID(ix+1,3:end), poses_ID(ix+2,3:end)];
        ix = ix + 3; % point to next high rate input with a 0 ID marker
         
    else 
        combined_update = false;
        p = [poses_ID(ix,3:end), zeros(1,12)];
        ix = ix + 1;
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
process_trans_hi = 1e-5;
process_trans_corr = 0;
process_rot_hi = 1e-5;
process_rot_corr = 0;
process_vel = 1e-4;
process_acc = 1e-3;
process_w = 1e-4;

process_trans_low = 1e-5; % for bias
process_rot_low = 1e-5; % for bias


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
init_pose = poses_ID(1,3:8); 
ip_rot = init_pose(4:end);
ip_trans = init_pose(1:3);
x_est(state_x_hi:state_z_hi) = ip_trans;
x_est(state_x_low:state_z_low) = ip_trans;
x_est(state_Rx_hi:state_Rz_hi) = ip_rot;
x_est(state_Rx_low:state_Rz_low) = ip_rot;

x_est = [poses_ID(1,3:8) zeros(1,15)]'; % initialize location
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
