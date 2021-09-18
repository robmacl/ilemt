function [motions, couplings, file_map] = read_cal_data (options)
% Read ILEMT calibration data from stage_calibration.vi.  All the arguments
% are in the options struct.  For details on the fixture encoding in the
% file names, see:
%    ilemt/cal_data/input_patterns/test_plans.txt 
% 
% in_files: 
%     Cell vector of file names.  If the name encodes fixture rotations, then
%     these are incorporated into the 'motions' output.  Otherwise it is
%     assumed there are no extra fixture rotations.
%
% ishigh: If true, extract high rate couplings, otherwise low rate.
%
% Return values:
% motions(n, 18): 
%     Each row is:
%         [source_motion sensor_motion stage_motion]
%
%     These are source fixture motion, total sensor motion (including
%     sensor fixture motion), and stage motion only (less sensor fixture
%     motion).  The poses are in vector2tr format, units (mm, degree).
%
% couplings(3, 3, n): 
%     This is complex so that we can potentially remove hardware
%     measurement bias, use real_coupling() to get signed real coupling
%     values.
% 
% file_map(n):
%     Parallel to the result data, the index in options.in_files of the
%     file that the datapoint came from.

files = options.in_files;
if (~iscell(files))
  error('files is not a cell vector');
end

% Cell vectors of motions and couplings arrays that are going to get
% concatenated. 
motions_c = {};
couplings_c = {};

for (f_ix = 1:length(files))
  file1 = files{f_ix};
  % Parse fixtures out of the file name
  [tokens, ~] = regexp(file1, 'so(.*)_se(.*)_(.*)\.dat', 'tokens', 'match');
  fix_motions = zeros(1, 12);
  if (~isempty(tokens))
    fix_motions(4:6) = fix_lookup(tokens{1}{1}, false);
    fix_motions(10:12) = fix_lookup(tokens{1}{2}, true);
    %dat_size = tokens{1}{3};
  end
  
  % Read file data
  data1 = dlmread(file1);
  motions1 = repmat(fix_motions, size(data1, 1), 1);
  motions1(:, 7:12) = motions1(:, 7:12) + data1(:, 1:6);
  motions1(:, 13:18) = data1(:, 1:6);
  motions_c{end+1} = motions1;

  couplings1 = zeros(3, 3, size(data1, 1));
  if (options.ishigh)
    slice = 7:15;
  else
    slice = 16:24;
  end

  % Sign flips at each coupling position.
  so_sign = find_sign_pattern(file1, options.source_signs, 'source_signs');
  se_sign = find_sign_pattern(file1, options.sensor_signs, 'sensor_signs');
  signs = so_sign' * se_sign;

  for (ix = 1:size(data1, 1))
    couplings1(:, :, ix) = signs .* reshape(data1(ix, slice), 3, 3);
  end
  couplings_c{end+1} = couplings1;
  
  % Drift check.  Each file should have at least first and last points in the
  % null pose.  These measurements are ideally identical, and if they are too
  % different it suggests a problem, like something moved during the
  % collection.  A more precise check based on the pose change is made by
  % check_poses() 'drift' report.  But this check is useful because it can
  % be done when we don't yet have a calibration.
  if (all(data1(1, 1:6) == 0) && all(data1(end, 1:6) == 0))
    cdiff = couplings1(:,:,1) - couplings1(:,:,end);
    maxdiff = max(max(abs(cdiff), [], 2), [], 1);
    %fprintf(1, 'drift: %s %g\n', file1, maxdiff);
    if (maxdiff > 1e-4)
      fprintf(1, 'Warning: drift check failed: %s %g\n', file1, maxdiff);
    end
  else
    fprintf(1, 'First and last points are not home, skipping drift check.\n');
  end
end

motions = cat(1, motions_c{:});
couplings = cat(3, couplings_c{:});

% Compute file map
file_map = zeros(size(motions, 1), 1);
prev_ix = 1;
for (f_ix = 1:length(motions_c))
  new_ix = prev_ix + length(motions_c{f_ix}) - 1;
  file_map(prev_ix:new_ix) = f_ix;
  prev_ix = new_ix + 1;
end

end % read_cal_data

function [angles] = fix_lookup (wot, fixture_to_mover)
% This maps the fixture codes to the vector2tr Euler angles.  
% 
% wot: 
%    Fixture code.
% 
% fixture_to_mover: 
%    if true, we want the transform from the fixture to the mover, if false
%    the reverse.  The code is defined with respect to the fixture, but for
%    the source we want to go from mover to fixture, whereas for sensor it
%    is the other way around.
%
% I guess there are 24 legit fixture codes, but we only use these, so no point
% in letting people use the wrong ones.

  % With the convention this is more easily interpreted as starting in the
  % mover coordinates, then transposing to take the inverse.
  basis = eye(4);
  X = basis(:, 1);
  Y = basis(:, 2);
  Z = basis(:, 3);
  % [out up] are the mover unit vectors that map onto the fixture Y and
  % Z.
  table = {
      'YoutZup' [+Y +Z]
      'ZinYup'	[-Z +Y]
      'ZinXdown' [-Z -X]
      'XoutZup'	[+X +Z]
      'ZoutYup' [+Z +Y]
      'XinYup'	[-X +Y]
  };
  
  b1 = table(strcmp(wot, table(:,1)), 2);
  if (isempty(b1))
    error('Unknown fixture code: %s', wot);
  end
  % The YZ basis
  rot = zeros(3);
  rot(1:3, 2:3) = b1{1}(1:3, :);
  % Fill in X from right hand rule
  rot(1:3, 1) = cross(rot(:, 2), rot(:, 3));
  if (fixture_to_mover)
    % We want the inverse mapping, so transpose rotation
    rot = rot';
  end
  T = eye(4);
  T(1:3, 1:3) = rot;
  
  angles = tr2vector(T);
  angles = angles(4:6);
end % non-nested fix_lookup

function [res] = find_sign_pattern (file, patterns, what)
% Find the sign pattern in options.source_signs or options.sensor_signs
  for (ix = 1:size(patterns, 1))
    if (~isempty(regexp(file, patterns{ix, 1})))
      res = patterns{ix, 2};
      fprintf(1, '%s: %s [%d %d %d]\n', file, what, res(1), res(2), res(3));
      return
    end
  end
  res = [1 1 1];
end % non-nested find_sign_pattern


