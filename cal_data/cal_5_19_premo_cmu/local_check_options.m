%options.cal_file = 'XYZ_concentric_hr_cal_DLT_corrected';
options.cal_file = 'XYZ_hr_cal_DLT_corrected';
options.linear_correction = true;
%options.do_optimize = 'both';
options.in_files = {'Z_rot_ld.dat'  'X_rot_ld.dat'  'Y_rot_ld.dat'};
options.stage_coords = false;
options.pose_solution = 'kim18';
%options.xyz_exaggerate = 2;
%options.rot_xyz_exaggerate = 100;
