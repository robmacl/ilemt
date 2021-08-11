%% local test definitions, included by test_script.m

% {cal_mode base_calibration option*}
% 
% Concentric calibration is first so that we can use Kim18 method to
% initialize the solution for the non-concentric calibrations.
cal_runs = {
    {'XYZ' 'base_calibration', 'concentric', true}
    {'XYZ_all', 'XYZ_concentric_hr_cal', 'concentric', true}
    {'XYZ', 'base_calibration'}
    {'XYZ_all', 'XYZ_hr_cal'}
    {'so_quadrupole', 'XYZ_hr_cal'}
% {'so_quadrupole_reopt', 'so_quadrupole_hr_cal'}
    {'so_quadrupole_all', 'so_quadrupole_hr_cal'}
    };

% cp_runs{:, 1} is the cal_file
% cp_runs(:, 2:end} are additional options
%{'so_quadrupole_reopt_hr_cal'}
cp_runs = {
    {'XYZ_hr_cal'}
    {'XYZ_all_hr_cal'}
    {'so_quadrupole_all_hr_cal'}
    {'XYZ_concentric_hr_cal', 'pose_solution', 'kim18'}
    {'XYZ_all_concentric_hr_cal', 'pose_solution', 'kim18'}
    };

% Variants are different options that we test on each run.
cp_variants = {
    'default' {}
    'nocorrect' {'linear_correction', false}
%   'source fix' {'source_fixtures', {'soYoutZup' 'soXoutZup' 'soZoutYup' 'soXinYup'}}
    };
