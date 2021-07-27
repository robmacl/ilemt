function [] = update_calibration (cal_file)
% Update format of a calibration file to the current format
calibration = load(cal_file);

if (~isfield(calibration, 'pin_quadrupole'))
  calibration.pin_quadrupole = true;
end

if (~isfield(calibration, 'linear_correction'))
  calibration.linear_correction = eye(4);
end

if (~isfield(calibration, 'bias'))
  calibration.bias = zeros(3);
end

if (~isfield(calibration, 'stage_fixture'))
  % Existing source fixture becomes the stage fixture
  calibration.stage_fixture = calibration.source_fixture;
  calibration.source_fixture = zeros(1, 6);
end

save(cal_file, '-struct', 'calibration');
