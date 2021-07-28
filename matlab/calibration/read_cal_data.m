function [motions, couplings] = read_cal_data (options)
% Read ILEMT calibration data from stage_calibration.vi.  All the arguments
% are in the options struct.
% 
% files: 
%     Cell vector of file names.  If the name encodes fixture rotations, then
%     these are incorporated into the 'motions' output.  Otherwise it is
%     assumed there are no extra fixture rotations.
%
% ishigh:
%     If true, extract high rate couplings, otherwise low rate.
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

for (ix = 1:length(files))
  % Parse fixtures out of the file name
  [tokens, ~] = regexp(files{ix}, 'so(.*)_se(.*)_(.*)\.dat', 'tokens', 'match');
  fix_motions = zeros(1, 12);
  if (~isempty(tokens))
    fix_motions(4:6) = fix_lookup(tokens{1}{1});
    fix_motions(10:12) = fix_lookup(tokens{1}{2});
    %dat_size = tokens{1}{3};
  end
  
  % Read file data
  data1 = dlmread(files{ix});
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
end

motions = cat(1, motions_c{:});
couplings = cat(3, couplings_c{:});

end % read_cal_data

function [angles] = fix_lookup (wot)
% This maps the fixture codes to the vector2tr Euler angles.  I guess there
% are 24 legit (right hand) combinations, but we only use these.

  basis = eye(4);
  X = basis(:, 1);
  Y = basis(:, 2);
  Z = basis(:, 3);
  T = basis(:, 4);
  table = {
      '+X+Y+Z' [+X +Y +Z]
      '+X-Z+Y' [+X -Z +Y]
      '-Y-Z+X' [-Y -Z +X]
      '+Y+Z+X' [+Y +Z +X]
      '+Z-Y+X' [+Z -Y +X]
      '-Y+X+Z' [-Y +X +Z]
          };
  b1 = table(strcmp(wot, table(:,1)), 2);
  if (isempty(b1))
    error('Unknown fixture code: %s', wot);
  end
  b1 = b1{1};
  angles = tr2vector([b1 T]);
  angles = angles(4:6);
end % non-nested fix_lookup
