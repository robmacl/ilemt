% Solves for high and low rate pose separately using UKFs. No MI correction

% poses = load('free_slide_poses.mat');
% calibrationukf = load_cal_file(['../cal_9_1_premo_rotated_dipole/output/XYZ_hr_cal']);
% [path,name,ext] = fileparts('free_slide.trace');
% data = read_track_file([path name ext]);
% couplings = data.coupling_high;
% [posesukf, resnorms] = pose_solve_UKF(couplings, calibrationukf);

poses = load('free_slide_poses.mat');
calibrationukf_low = load_cal_file(['../cal_9_1_premo_rotated_dipole/output/XYZ_lr_cal']);
[path,name,ext] = fileparts('free_slide.trace');
data = read_track_file([path name ext]);
couplings_low = data.coupling_low;
[posesukf_low, resnorms] = pose_solve_UKF_low(couplings_low, calibrationukf_low);