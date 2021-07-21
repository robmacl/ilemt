function [] = update_calibration (cal_file)
% Update format of calibration struct to the current format
calibration = load(cal_file);

if (~isfield(calibration, 'pin_quadrupole'))
  calibration.pin_quadrupole = true;
end

if (~isfield(calibration, 'linear_correction'))
  calibration.linear_correction = eye(6);
end

if (~isfield(calibration, 'bias'))
  calibration.bias = zeros(3);
end

save(cal_file, '-struct', 'calibration');
