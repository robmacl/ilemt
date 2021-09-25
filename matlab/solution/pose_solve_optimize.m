function [poses, resnorms] = pose_solve_optimize (couplings, calibration, options, hemisphere, initial)
% Pose solution by nonlinear optimization.

if (~isempty(options.concentric_cal_file))
  con_cal = load_cal_file(options.concentric_cal_file);
else
  con_cal = [];
end


% parfor output struct array, results of each point solution
clear results;

global bad_ix

%parfor
parfor (ix = 1:size(couplings, 3))
  coupling = couplings(:, :, ix);
  hemi = hemisphere(ix);

  if (isempty(initial))
    initial1 = [];
  else
    initial1 = initial(ix, :);
  end
  [pose_new, resnorm] = ...
      p_s_o_retry(coupling, calibration, options, hemi, initial1, con_cal);

  % use last pose as initial value?  Doesn't work well with calibration
  % data points, which jump around.  And doesn't work with parfor.
  %pose0 = pose_new;
  results(ix) = ...
      struct('pose', pose_new, 'resnorm', resnorm);
end

% Convert to canonical rotation vectors, with magnitude ranging 0:pi.
% This insures that the same orientation always has the same rotation
% vector, and not a 2*pi multiple.
poses = canonical_rot_vec(cat(1, results.pose));

resnorms = [results.resnorm];
