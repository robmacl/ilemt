function [motions, couplings] = read_cal_data (options)
% Read ILEMT calibration data from stage_calibration.vi.  All the arguments
% are in the options struct.  For details on the fixture encoding in the
% file names, see:
%    ilemt/cal_data/input_patterns/test_plans.txt 
% 
% files: 
%     Cell vector of file names.  If the name encodes fixture rotations, then
%     these are incorporated into the 'motions' output.  Otherwise it is
%     assumed there are no extra fixture rotations.
%
% ishigh: If true, extract high rate couplings, otherwise low rate.
%
% Return values:
% motions: 
%     source fixture motion and (sensor) stage motion. Each row is:
%         [source_motion sensor_motion]
%
%     with poses in vector2tr format, units (mm, degree).  We only need two
%     motion poses because the sensor fixture motions are added to the stage
%     motion.
%
% couplings: 
%     complex, use real_coupling() or debias_residue()

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
  motions_c{end+1} = motions1;

  couplings1 = zeros(3, 3, size(data1, 1));
  if (options.ishigh)
    slice = 7:15;
  else
    slice = 16:24;
  end

  % Sign flips at each coupling position.
  signs = options.source_signs' * options.sensor_signs;

  for (ix = 1:size(data1, 1))
    couplings1(:, :, ix) = signs .* reshape(data1(ix, slice), 3, 3) - options.bias;
  end
  couplings_c{end+1} = couplings1;
  
  % Drift check.  Each file should have at least first and last points in the
  % null pose.  These measurements are ideally identical, and if they are too
  % different it suggests a problem, like something moved during the
  % collection.
  if (all(data1(1, 1:6) == 0) && all(data1(end, 1:6) == 0))
    cdiff = couplings1(:,:,1) - couplings1(:,:,end);
    maxdiff = max(max(abs(cdiff), [], 2), [], 1);
fprintf(1, 'drift: %s %g\n', file1, maxdiff);
    if (maxdiff > 1e-4)
      fprintf(1, 'Warning: drift check failed: %s %g\n', file1, maxdiff);
    end
  else
    fprintf(1, 'First and last points are not home, skipping drift check.\n');
  end
end

motions = cat(1, motions_c{:});
couplings = cat(3, couplings_c{:});

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
