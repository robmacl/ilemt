function [poses, couplings] = read_cal_data (files, ishigh)
% Read ILEMT calibration data from stage_calibration.vi
% 
% files: 
%     Either a single data file or a cell vector of 3 files with X and Y
%     sensor rotation fixturings.
% 
% ishigh:
%     If true, extract high rate couplings, otherwise low rate.

if (iscell(files))
  assert(length(files) == 3);
  data = XYZrot_data_combination(files{1}, files{2}, 90, files{3}, 90);
else
  assert(ischar(files));
  data = getreal(files);
end

poses = data(:, 1:6);

couplings = zeros(3, 3, size(data, 1));

if (ishigh)
  slice = 7:15;
else
  slice = 16:24;
end
  
for (ix = 1:size(data, 1))
  couplings(:, :, ix) = reshape(data(ix, slice), 3, 3);
end

