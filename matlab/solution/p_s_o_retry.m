function [pose_new, resnorm] = p_s_o_retry ...
    (coupling, calibration, options, hemi, initial, con_cal)
% Do pose solution optimization, using differently permuted initial states if
% the first guess does not succeed.

pose0 = p_s_o_pose0(coupling, calibration, hemi, initial, con_cal);
[pose_new, resnorm] = pose_solve_optimize1(coupling, calibration, hemi, pose0);

if (resnorm < options.valid_threshold)
  return;
end

poses(1, :) = pose_new;
norms(1) = resnorm;

% If our initial initial value didn't work, try flipping sign of each element
for (ax_ix = 1:6)
  alt_p0 = pose0;
  alt_p0(ax_ix) = -alt_p0(ax_ix);
%fprintf(1, 'p_s_o_retry: failed %g, trying alternate %d\n', resnorm, ax_ix);
  [pose_new, resnorm] = pose_solve_optimize1(coupling, calibration, hemi, alt_p0);
  poses(end+1, :) = pose_new;
  norms(end+1) = resnorm;
  if (resnorm < options.valid_threshold)
    return;
  end
end

% give up, but take the best of the tries.  This may be useful if
% valid_threshold is too stringent under the prevailing conditions.

[resnorm, ix] = min(norms);
pose_new = poses(ix, :);
