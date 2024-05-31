function [options] = interfere_options (varargin)
% Return options struct for interference testing (metal, EMI)

% Where to find calibration files
options.cal_directory = '../../ilemt_cal_data/cal_9_15_premo_cmu/output/';

% Prefix of the calibration file, less _lr_cal, _hr_cal, etc.
options.cal_file_base = 'XYZ';

% This controls whether we use the concetric calibration and kim18 solution.
options.concentric = false;

% These options are passed to pose_solution(), see check_poses_options()
% for description.
options.valid_threshold = 1e-5;
options.hemisphere = 1;
options.linear_correction = true;

options.compensate_stage = false;
options.source_signs = {};
options.sensor_signs = {};
options.ishigh = true;

optfile = './local_interfere_options.m';
if (exist(optfile, 'file'))
  run(optfile);
end

for (key_ix = 1:2:(length(varargin) - 1))
  key = varargin{key_ix};
  if (isfield(options, key))
    options.(key) = varargin{key_ix + 1};
  else
    error('Unknown option: %s', key);
  end
end
