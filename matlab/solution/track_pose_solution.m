function [res] = track_pose_solution (data, options)
% Solve for poses from track data.  data is from read_track_file(),
% options is from track_options().  Result is struct:
% 
% poses(n, 6):
%   Pose vectors in rotation vector format: [X Y Z Rx Ry Rz].
% 
% valid(n, 1):
%   Is the pose solution valid?  Meaning residue not too high.
% 
% timestamp(n, 1):
%   Timestamp of the measurement (seconds from start of file).
% 
% entry_type(n, 1):
%   Type of measurement: 0=high rate, 1=low rate, 2=high at low.

cal_low = load_cal_file([options.cal_file_base '_lr_cal']);
cal_high = load_cal_file([options.cal_file_base '_hr_cal']);

options_low = options;
options_low.concentric_cal_file = [options.cal_file_base '_concentric_lr_cal'];

options_high = options;
options_high.concentric_cal_file = [options.cal_file_base '_concentric_hr_cal'];

poses_c = {};
valid_c = {};

low_entries = find(data.entry_type == 1);
prev_low = -1;
for (low_ix = low_entries')
  % High rate block
  c_high = data.coupling_all(:, :, (prev_low + 2):(low_ix - 1));
  if (~isempty(c_high))
    [pose1, valid1] = pose_solution(c_high, cal_high, options_high);
    poses_c{end+1} = pose1;
    valid_c{end+1} = valid1(:);
  end

  % Low rate entry
  c_low = data.coupling_all(:, :, low_ix);
  [pose1, valid1] = pose_solution(c_low, cal_low, options_low);
  poses_c{end+1} = pose1;
  valid_c{end+1} = valid1(:);

  % High at low
  c_high = data.coupling_all(:, :, low_ix + 1);
  [pose1, valid1] = pose_solution(c_high, cal_high, options_high);
  poses_c{end+1} = pose1;
  valid_c{end+1} = valid1(:);

  prev_low = low_ix;
end

res.poses = cat(1, poses_c{:});
res.valid = cat(1, valid_c{:});

% There may be a chunk of high rate data at the end with no following low rate
% entry, which got dropped by the loop above, so discard those timestamps and
% entry_type.
npoints = size(res.poses, 1);
res.timestamp = data.timestamp_all(1:npoints);
res.entry_type = data.entry_type(1:npoints);
