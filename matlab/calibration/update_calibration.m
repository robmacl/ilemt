function [] = update_calibration (cal_file)
% Update format of a calibration file to the current format

if (nargin < 1 || isempty(cal_file))
  dirlist = dir('*.mat');
  files = {dirlist.name};
else
  files = {cal_file};
end

for (f_ix = 1:length(files))
  file1 = files{f_ix};
  
  calibration = load(file1);

  if (~isfield(calibration, 'd_source_pos'))
    fprintf(1, 'Not a calibration, ignoring: %s\n', file1);
    continue;
  end
  
  if (~isfield(calibration, 'pin_quadrupole'))
    calibration.pin_quadrupole = true;
  end

  if (~isfield(calibration, 'linear_correction'))
    calibration.linear_correction = eye(4);
  end

  if (~isfield(calibration, 'bias'))
    calibration.bias = zeros(3);
  end

  if (~isfield(calibration, 'stage_fixture') ...
      || all(calibration.source_fixture == 0))
    % Existing source fixture becomes the stage fixture, 90 degree rotation
    % is left in the source fixture, so stage offset is rotated.
    so_f = calibration.source_fixture;
    calibration.stage_fixture = ...
        [-so_f(2) so_f(1) so_f(3) 0 0 0];
    calibration.source_fixture = [zeros(1, 5) so_f(6)];
  end

  save(file1, '-struct', 'calibration');
  fprintf(1, 'Updated %s\n', file1);
end
