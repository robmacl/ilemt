options.cal_mode = 'so_quadrupole';
options.data_size = 'md';
options.sensor = 'premo';

%options.optimize = {options.optimize{:} 'so_fix'};
options.optimize = {'q_so_mo' 'so_fix' 'd_so_pos' 'd_so_mo'};

%options.optimize = {'d_so_pos' 'd_so_mo' 'st_fix' 'so_fix'};
options.freeze = {options.freeze{:} 'z_se_fix'};

%options.base_calibration = 'base_cal';
%options.out_file = 'so_fix_hr_cal';
options.base_calibration = 'so_fix_hr_cal';
options.out_file = 'so_fix_quadrupole_hr_cal';
options.correct_mode = 'none';

options.input_motion = {
    'so+X+Y+Z_se+X+Y+Z'
    'so+Y+Z+X_se+X+Y+Z'
    'so+Z-Y+X_se+X+Y+Z'
    'so-Y+X+Z_se+X+Y+Z'
}';

