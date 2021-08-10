%% local test definitions, included by test_script.m


%% calibrate_main() runs

% {cal_mode base_calibration option*}
% 
% Concentric calibration is first so that we can use Kim18 method to
% initialize the solution for the non-concentric calibrations.

% The 'md' corresponding to this directory are in
% cal_5_25_premo_rotated_dipole, which has different (incorrect) data signs,
% so calibration is run there.

cal_runs = {};


%% check_poses() runs

% cp_runs{:, 1} is the cal_file
% cp_runs(:, 2:end} are additional options
cp_runs = {
%    {'../cal_5_25_premo_rotated_dipole/XYZ_concentric_hr_cal', 'pose_solution', 'kim18'}
    {'../cal_5_25_premo_rotated_dipole/XYZ_hr_cal'}
    };

% Variants are different options that we test on each run.
cp_variants = {
    'default' {}
    'nocorrect' {'linear_correction', false}
    };
