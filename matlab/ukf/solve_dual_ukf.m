% Solves for the metal interference rejecting dual rate pose solution from
% the trace file specified below
trace_file = 'aluminum_sheet';

poses = load(strcat(trace_file, '_poses.mat'));
calibrationukf_hi = load_cal_file(['../cal_9_1_premo_rotated_dipole/output/XYZ_hr_cal']);
calibrationukf_lo = load_cal_file(['../cal_9_1_premo_rotated_dipole/output/XYZ_lr_cal']);
[path,name,ext] = fileparts(strcat(trace_file, '.trace'));
data = read_track_file([path name ext]);
couplings_hi_at_lo = data.coupling_high_at_low;
couplings_lo = data.coupling_low;
[posesukf_low, biasesukf, ~] = pose_solve_dual_UKF_low(couplings_hi_at_lo, couplings_lo, calibrationukf_hi, calibrationukf_lo);

biasesukf = reshape(biasesukf', [3, 3, size(biasesukf, 1)])
couplings_hi = data.coupling_high - repelem(biasesukf, 1, 1, 128);
[posesukf, resnorms] = pose_solve_UKF(couplings_hi, calibrationukf_hi);