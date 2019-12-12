%Calculate statistical values on the difference between the optimized poses
%and the poses calculated with forward kinematics method

[opt_poses,resnorms] = pose_calculation(data);
[poses] = canonical_rot_vec(opt_poses);

stage_poses=data(:, 1:6);

%load('subset_hr_cal')
load('new_XYZrot_hr_cal');
state0 = calibration2state(hr_cal, hr_so_fix, hr_se_fix);

%load('q_pole_lr_cal');
%state0 = calibration2state(lr_cal, lr_so_fix, lr_se_fix);

[fk_poses] = fk_pose_calculation (stage_poses, state0);

fk_poses_tr = fk_poses(:,1:3);
poses_tr = poses(:,1:3);

n = size(poses_tr,1);

fk_poses_rot = fk_poses(:,4:6);
poses_rot = poses(:,4:6);

tr_err = fk_poses_tr - poses_tr;
rot_err = fk_poses_rot - poses_rot;


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


filename = 'New Quadrupole HR statistics.xls';
writetable(T,filename,'Sheet',1,'Range','A1')

%{
rms_tr = [];
rms_rot = [];
for i = 1:n
  tr = sqrt(sum(tr_err(i,:).^2));
  [rms_tr] = [rms_tr; tr];
  rot = sqrt(sum(rot_err(i,:).^2));
  [rms_rot] = [rms_rot; rot];
end


max_tr = [max(abs(tr_err(:,1))) max(abs(tr_err(:,2))) max(abs(tr_err(:,3)))];
max_rot = [max(abs(rot_err(:,1))) max(abs(rot_err(:,2))) max(abs(rot_err(:,3)))];

%max_rms_tr = sqrt(sum((max_tr).^2));
%max_rms_rot = sqrt(sum((max_rot).^2));

max_rms_tr = max(rms_tr(:));
max_rms_rot = max(rms_rot(:));


min_tr = [min(tr_err(:,1)) min(tr_err(:,2)) min(tr_err(:,3))];
min_rot = [min(rot_err(:,1)) min(rot_err(:,2)) min(rot_err(:,3))];

mean_tr = [mean(tr_err(:,1)) mean(tr_err(:,2)) mean(tr_err(:,3))];
mean_rot = [mean(rot_err(:,1)) mean(rot_err(:,2)) mean(rot_err(:,3))];

mean_rms_tr = sqrt(sum((mean_tr).^2));
mean_rms_rot = sqrt(sum((mean_rot).^2));

std_tr = [std(tr_err(:,1)) std(tr_err(:,2)) std(tr_err(:,3))];
std_rot = [std(rot_err(:,1)) std(rot_err(:,2)) std(rot_err(:,3))];

std_rms_tr = sqrt(sum((std_tr).^2));
std_rms_rot = sqrt(sum((std_rot).^2));

Statistics = {'Mean'; 'Standard deviation'; 'Maximum'};
XYZ = [mean_tr; std_tr; max_tr];
XYZ_RMS = [mean_rms_tr; std_rms_tr; max_rms_tr];
RxRyRz = [mean_rot; std_rot; max_rot];
RxRyRz_RMS = [mean_rms_rot; std_rms_rot; max_rms_rot];

T = table(Statistics, XYZ, XYZ_RMS, RxRyRz, RxRyRz_RMS);
%}

