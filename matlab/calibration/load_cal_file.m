function [calibration] = load_cal_file (fname, probe)
% Load a calibration file.  Permit it to be in the output/ subdirectory, which
% is where calibrate_main() by default leaves it.  If probe is true, then
% return [] if the file can't be found, rather than erroring.
if (nargin < 2)
  probe = false;
end
[~, ~, ext] = fileparts(fname);
if (isempty(ext))
  fname = [fname '.mat'];
end
if (~exist(fname, 'file'))
  f_sub = ['output' filesep fname];
  if (exist(f_sub, 'file'))
    fname = f_sub;
  elseif (probe)
    calibration = [];
    return;
  else
    error('Calibration file not found: %s', fname);
  end
end
calibration = load(fname);
