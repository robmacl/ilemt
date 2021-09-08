function [calibration] = load_cal_file (fname)
% Load a calibration file.  Permit it to be in the output/ subdirectory, which
% is where calibrate_main() by default leaves it.
[~, ~, ext] = fileparts(fname);
if (isempty(ext))
  fname = [fname '.mat'];
end
if (~exist(fname, 'file'))
  f_sub = ['output' filesep fname];
  if (exist(f_sub, 'file'))
    fname = f_sub;
  else
    error('Calibration file not found: %s', fname);
  end
end
calibration = load(fname);
