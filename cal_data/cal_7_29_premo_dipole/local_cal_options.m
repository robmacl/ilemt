options.cal_mode = 'XYZ';
%options.cal_mode = 'Z_only';
%options.cal_mode = 'default';
options.data_size = 'md';
%options.cal_mode = 'so_quadrupole';
%options.cal_mode = 'so_quadrupole_all';
options.sensor = 'premo';

%options.optimize = {options.optimize{:} 'so_fix'};

%options.optimize = {'d_so_pos' 'd_so_mo' 'st_fix' 'so_fix'};

%options.base_calibration = 'base_cal';
%options.out_file = 'so_fix_hr_cal';
%options.base_calibration = 'so_fix_hr_cal';
options.base_calibration = '../cal_7_21_premo_dipole/so_quadrupole_all_hr_cal.mat';

%options.correct_mode = 'none';

%{
options.data_size = 'source';
options.input_motion = {
    'soYoutZup_seYoutZup'
    'soXoutZup_seYoutZup'
    'soZoutYup_seYoutZup'
    'soXinYup_seYoutZup'
}';
%}
