%options.in_files = {'axis_sweep_out.dat'};
options.issweep = false;
%options.cal_file = '../5_25_premo_rotated_dipole/XYZ_hr_cal.mat';
%options.cal_file = '../5_25_premo_rotated_dipole/XYZ_hr_cal_skew_corrected.mat';
options.cal_file = '../5_25_premo_rotated_dipole/XYZ_hr_cal_DLT_corrected.mat';
%options.cal_file = '../5_25_premo_rotated_dipole/XYZ_hr_cal_pose_corrected.mat';
%options.cal_file = '../5_25_premo_rotated_dipole/se_quadrupole_all_hr_cal_skew_corrected.mat';
%options.cal_file = '../5_25_premo_rotated_dipole/se_quadrupole_all_hr_cal.mat';
options.linear_correction = true;
options.do_optimize = 'both';
options.sg_filt_F = 11;