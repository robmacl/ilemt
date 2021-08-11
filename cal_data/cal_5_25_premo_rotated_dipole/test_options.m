%% local test definitions, included by test_script.m


%% calibrate_main() runs

% {cal_mode base_calibration option*}
% 
% Concentric calibration is first so that we can use Kim18 method to
% initialize the solution for the non-concentric calibrations.
cal_runs = {
    {'XYZ' 'base_calibration', 'concentric', true}
    {'XYZ', 'base_calibration'}
    };


%% check_poses() runs

% The 'ld' corresponding to this directory are in
% cal_5_28_premo_rotated_dipole, which has different (correct) data signs.
% So checks must be run in that directory.

cp_runs = {};
