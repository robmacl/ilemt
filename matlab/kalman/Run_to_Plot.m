lhf_poses = zeros(size(poses_ID(:,2),1),8);
hf_poses = lhf_poses;

hf_ix = 1;
lhf_ix = 1;

for c = 1:length(poses_ID)
    if poses_ID(c,2) == 0; % for high rate data
        pose1 = poses_ID(c,:);
        hf_poses(hf_ix, :) = pose1;
        hf_ix = hf_ix + 1;
        % hf_poses = [hf_poses; pose1];
        
    elseif poses_ID(c,2) == 1; % for low rate data
        pose11 = poses_ID(c,:);
        lhf_poses(lhf_ix, :) = pose11;
        lhf_ix = lhf_ix + 1;
        % lhf_poses = [lhf_poses; pose11];
    end
end

hf_poses = hf_poses(1:hf_ix-1, :);
lhf_poses = lhf_poses(1:lhf_ix-1, :);

timeVec_hi = hf_poses(:,1);
timeVec_low = lhf_poses(1:end-1,1);
timeVec = x_est_ID(:,1);

x_pos_hf = hf_poses(:,3);
y_pos_hf = hf_poses(:,4);
z_pos_hf = hf_poses(:,5);
Rx_hf = hf_poses(:,6);
Ry_hf = hf_poses(:,7);
Rz_hf = hf_poses(:,8);

x_pos_lf = lhf_poses(1:end-1,3);
y_pos_lf = lhf_poses(1:end-1,4);
z_pos_lf = lhf_poses(1:end-1,5);
Rx_lf = lhf_poses(1:end-1,6);
Ry_lf = lhf_poses(1:end-1,7);
Rz_lf = lhf_poses(1:end-1,8);

x_est_hi = x_est_ID(:,3);
x_est_low = x_est_ID(:,18);
y_est_hi = x_est_ID(:,4);
y_est_low = x_est_ID(:,19);
z_est_hi = x_est_ID(:,5);
z_est_low = x_est_ID(:,20);
Rx_est_hi = x_est_ID(:,12);
Rx_est_low = x_est_ID(:,21);
Ry_est_hi = x_est_ID(:,13);
Ry_est_low = x_est_ID(:,22);
Rz_est_hi = x_est_ID(:,14);
Rz_est_low = x_est_ID(:,23);

x_vel_est = x_est_ID(:,6);
y_vel_est = x_est_ID(:,7);
z_vel_est = x_est_ID(:,8);
x_acc_est = x_est_ID(:,9);
y_acc_est = x_est_ID(:,10);
z_acc_est = x_est_ID(:,11);

x_est_unbias = unbias(:,1);
y_est_unbias = unbias(:,2);
z_est_unbias = unbias(:,3);
Rx_est_unbias = unbias(:,4);
Ry_est_unbias = unbias(:,5);
Rz_est_unbias = unbias(:,6);

figure(2)
hold on
h = [];
subplot(4,1,1)
plot(timeVec_hi, x_pos_hf, timeVec_low, x_pos_lf, timeVec, x_est_hi,timeVec, x_est_unbias);
h(1) = gca;
xlabel('Time (s)')
ylabel('Position (m)')
title('X-Position Over Time')
legend('High Rate','Low Rate','Kalman Filter-High','Unbiased')
subplot(4,1,2)
plot(timeVec, x_vel_est);
h(2) = gca;
subplot(4,1,3)
plot(timeVec, x_acc_est);
h(3) = gca;
subplot(4,1,4)
plot(timeVec, x_est_low);
h(4) = gca;
linkaxes(h,'x');
hold off

figure(3)
hold on
h = [];
subplot(4,1,1)
plot(timeVec_hi, y_pos_hf, timeVec_low, y_pos_lf, timeVec, y_est_hi, timeVec, y_est_unbias)
h(1) = gca;
xlabel('Time (s)')
ylabel('Position (m)')
title('Y-Position Over Time')
legend('High Rate','Low Rate','Kalman Filter-High','Unbiased')
subplot(4,1,2)
plot(timeVec, y_vel_est);
h(2) = gca;
subplot(4,1,3)
plot(timeVec, y_acc_est);
h(3) = gca;
subplot(4,1,4)
plot(timeVec, y_est_low);
h(4) = gca;
linkaxes(h,'x');
hold off

figure(4)
hold on
h = [];
subplot(4,1,1)
plot(timeVec_hi, z_pos_hf, timeVec_low, z_pos_lf, timeVec, z_est_hi, timeVec, z_est_unbias)
h(1) = gca;
xlabel('Time (s)')
ylabel('Position (m)')
title('Z-Position Over Time')
legend('High Rate','Low Rate','Kalman Filter-High','Unbiased')
subplot(4,1,2)
plot(timeVec, z_vel_est);
h(2) = gca;
subplot(4,1,3)
plot(timeVec, z_acc_est);
h(3) = gca;
subplot(4,1,4)
plot(timeVec, z_est_low);
h(4) = gca;
linkaxes(h,'x');
hold off

figure(5)
hold on
h = [];
subplot(2,1,1)
plot(timeVec_hi, Rx_hf, timeVec_low, Rx_lf, timeVec, Rx_est_hi, timeVec, Rx_est_unbias)
h(1) = gca;
xlabel('Time (s)')
ylabel('Position (rad)')
title('Rx Over Time')
legend('High Rate','Low Rate','Kalman Filter-High','Unbiased')
subplot(2,1,2)
plot(timeVec, Rx_est_low);
h(2) = gca;
linkaxes(h,'x');
hold off

figure(6)
hold on
h = [];
subplot(2,1,1)
plot(timeVec_hi, Ry_hf, timeVec_low, Ry_lf, timeVec, Ry_est_hi, timeVec, Ry_est_unbias)
h(1) = gca;
xlabel('Time (s)')
ylabel('Position (rad)')
title('Ry Over Time')
legend('High Rate','Low Rate','Kalman Filter-High','Unbiased')
subplot(2,1,2)
plot(timeVec, Ry_est_low);
h(2) = gca;
linkaxes(h,'x');
hold off

figure(7)
hold on
h = [];
subplot(2,1,1)
plot(timeVec_hi, Rz_hf, timeVec_low, Rz_lf, timeVec, Rz_est_hi, timeVec, Rz_est_unbias)
h(1) = gca;
xlabel('Time (s)')
ylabel('Position (rad)')
title('Rz Over Time')
legend('High Rate','Low Rate','Kalman Filter-High','Unbiased')
subplot(2,1,2)
plot(timeVec, Rz_est_low);
h(2) = gca;
linkaxes(h,'x');
hold off

%{
figure(7)
plot3(poses_ID(:,3),poses_ID(:,4),poses_ID(:,5))
hold on
% plot3(x_up(1,:),x_up(2,:),x_up(3,:))
xlabel('X-position')
ylabel('Y-position')
zlabel('Z-position')
%title('Raw Measured Position and Filtered Positions')
%legend('Raw Position Data','Kalman Filtered Position Data')
hold off
%}

figure (8)
hold on
h = [];
subplot(2,1,1)
plot(timeVec_hi, x_pos_hf, timeVec_hi, y_pos_hf, timeVec_hi, z_pos_hf)
h(1) = gca;
xlabel('Time (s)')
ylabel('Position (m)')
title('Position')
legend('X','Y','Z')
subplot(2,1,2)
plot(timeVec_hi, Rx_hf, timeVec_hi, Ry_hf, timeVec_hi, Rz_hf)
h(2) = gca;
xlabel('Time (s)')
ylabel('Position (rad)')
title('Rotation')
legend('X','Y','Z')
linkaxes(h,'x');
hold off

figure (9)
hold on
h = [];
plot(timeVec_hi, (x_pos_hf - 0.2))
h(1) = gca;
xlabel('Time (s)')
ylabel('Position (m)')
title('X Position')
hold off

figure(10)
hold on
h = [];
plot(timeVec_hi, (z_pos_hf+9.182107611178899e-004+8.563064598154724e-004), timeVec_low, (z_pos_lf+9.182107611178899e-004), timeVec, (z_est_unbias+9.182107611178899e-004))
xlabel('Time (s)')
ylabel('Position (m)')
title('Z-Position Over Time with Interference')
legend('High Rate','Low Rate','Combined')
hold off
%{
figure(11)
hold on
h = [];
plot(timeVec_hi, (y_pos_hf+2.289597005902834e-004), timeVec_low, (y_pos_lf+2.289597005902834e-004), timeVec, (y_est_unbias+2.289597005902834e-004))
xlabel('Time (s)')
ylabel('Position (m)')
title('Y-Position Over Time with Interference')
legend('High Rate','Low Rate','Combined')
hold off

figure(12)
hold on
h = [];
plot(timeVec_hi, (x_pos_hf-0.199217555916492), timeVec_low, (x_pos_lf-0.199217555916492), timeVec, (x_est_unbias-0.199217555916492))
xlabel('Time (s)')
ylabel('Position (m)')
title('X-Position Over Time with Interference')
legend('High Rate','Low Rate','Combined')
hold off
%}