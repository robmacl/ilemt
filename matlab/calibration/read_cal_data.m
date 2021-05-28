function [poses, couplings] = read_cal_data (options)
% Read ILEMT calibration data from stage_calibration.vi.  All the arguments
% are in the options struct.
% 
% files: 
%     Cell vector of either a single data file (with no extra fixture
%     rotations) or a cell vector of 3 files with Rz, Rx and Ry sensor
%     rotation fixturings.

% ishigh:
%     If true, extract high rate couplings, otherwise low rate.
%
% Return values:
%     poses: in vector2tr format, units (mm, degree)
%     couplings: complex, use real_coupling() or debias_residue()

files = options.in_files;

if (~iscell(files))
  error('files is not a cell vector');
elseif (length(files) == 3)
  data = XYZrot_data_combination(files{1}, files{2}, 90, files{3}, 90);
elseif (length(files) == 1)
  data = dlmread(files{1});
else 
  error('Files should be either 1 or 3 elements');
end

poses = data(:, 1:6);

couplings = zeros(3, 3, size(data, 1));

if (options.ishigh)
  slice = 7:15;
else
  slice = 16:24;
end

% Sign flips at each coupling position.
signs = options.source_signs' * options.sensor_signs;

for (ix = 1:size(data, 1))
  couplings(:, :, ix) = signs .* reshape(data(ix, slice), 3, 3) - options.bias;
end
