%Calculate statistical values on the difference between the optimized poses
%and the poses calculated with forward kinematics method

stage_poses=data(:, 1:6);

%load('subset_hr_cal')
load('middata_XZrot_hr_cal');
state0 = calibration2state(hr_cal, hr_so_fix, hr_se_fix);

[poses,resnorms] = pose_calculation(data, state0);

[fk_poses] = fk_pose_calculation (stage_poses, state0);

pose_diff = fk_poses - poses;

can_poses = canonical_rot_vec(pose_diff);

tr_err = poses(:,1:3);
rot_err = poses(:,4:6);

n = size(poses,1);

rms_tr = sqrt((sum(sum(tr_err.^2)))/n);
max_tr = max(sqrt(sum(tr_err.^2, 2)));

rms_rot = sqrt((sum(sum(rot_err.^2)))/n);
max_rot = max(sqrt(sum(rot_err.^2, 2)));


Statistics = {'RMS'; 'Maximum'};
Translation = [rms_tr; max_tr];
Rotation = [rms_rot; max_rot];
T = table(Statistics, Translation, Rotation);
format short g
disp(T)


%filename = 'Z rot statistics.xls';
%writetable(T,['D:\ilemt\cal_data\dipole_UR44\1Fix Quadrupole\' filename],'Sheet',1,'Range','A1')

%error_map
