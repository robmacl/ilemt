function [options] = track_options (varargin)
% Return options struct for track_pose_solution(). 

% Prefix of the calibration file, less _lr_cal, _hr_cal, etc.
options.cal_file_base = 'XYZ';

% These options are passed to pose_solution(), see check_poses_options()
% for description.
options.pose_solution = 'optimize';
options.valid_threshold = 1e-5;
options.hemisphere = 1;
options.linear_correction = false;

optfile = './local_track_options.m';
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
