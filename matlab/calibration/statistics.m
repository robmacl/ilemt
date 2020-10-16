%Calculate statistical values on the difference between the optimized poses
%and the poses calculated with forward kinematics
function statistics(data, hr_cal, hr_so_fix, hr_se_fix)

stage_poses=data(:, 1:6);

state0 = calibration2state(hr_cal, hr_so_fix, hr_se_fix);
%optimized poses
[poses,resnorms] = pose_calculation(data, state0);

%forward kinematics poses
[fk_poses] = fk_pose_calculation (stage_poses, state0);

%pose error
pose_diff = fk_poses - poses;

%calculate canonical rotation vectors on the difference between optimized
%poses and forward kinematic poses
can_poses = canonical_rot_vec(pose_diff);

%extract traslation and rotation pose error 
tr_err = can_poses(:,1:3);
rot_err = can_poses(:,4:6);

n = size(poses,1);

%traslation root mean sqare
rms_tr = sqrt((sum(sum(tr_err.^2)))/n);
%maximum traslation error
max_tr = max(sqrt(sum(tr_err.^2, 2)));

%rotation root mean square
rms_rot = sqrt((sum(sum(rot_err.^2)))/n);
%maximum rotation error
max_rot = max(sqrt(sum(rot_err.^2, 2)));

%generate, display and save the statistical calculations in a table format 
Statistics = {'RMS'; 'Maximum'};
Translation = [rms_tr; max_tr];
Rotation = [rms_rot; max_rot];
T = table(Statistics, Translation, Rotation);
format short g
disp(T)

filename = 'Statistics.xls';
writetable(T,filename,'Sheet',1,'Range','A1')

%create plots of the error
error_plots
end
