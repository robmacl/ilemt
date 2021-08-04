%{
options.source = 'dipole';
options.sensor = 'premo';
%}

%{
options.cal_mode = 'so_fixture';
options.base_calibration = 'Z_only_hr_cal.mat';
options.correct_mode = 'none';
%}

%{
options.cal_mode = 'XYZ';
options.base_calibration = 'xyz_nq_hr_cal.mat';
%}


%{
options.cal_mode = 'so_quadrupole';
options.base_calibration = 'XYZ_hr_cal_DLT_corrected';
%}

%{
options.cal_mode = 'so_quadrupole_all';
options.source_fixtures = options.source_fixtures(1)
%options.data_patterns = {'md', 'source'};
%}

% For check_poses
%options.data_patterns = {'ld'};

