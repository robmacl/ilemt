function [pose_new, resnorm] = p_s_o_retry (coupling, calibration, hemi, con_cal, options)
% Do pose solution optimization, using differently permuted initial states if
% the first guess does not succeed.

pose0 = p_s_o_pose0(coupling, calibration, con_cal, hemi);
[pose_new, resnorm] = pose_solve_optimize1(coupling, calibration, hemi, pose0);

if (resnorm < options.valid_threshold)
  return;
end

% If our initial initial value didn't work, try flipping sign of each element
for (ax_ix = 1:6)
  alt_p0 = pose0;
  alt_p0(ax_ix) = -alt_p0(ax_ix);
%fprintf(1, 'p_s_o_retry: failed %g, trying alternate %d\n', resnorm, ax_ix);
  [pose_new, resnorm] = pose_solve_optimize1(coupling, calibration, hemi, alt_p0);
  if (resnorm < options.valid_threshold)
    return;
  end
end

% give up.
