function [drift] = perr_report_drift (perr, options)
% Check the magnitude of pose drift during collection.  For each file, if
% there are stage null poses, then compare the measurement of the first and
% last poses.  The pose change is converted into a scalar meters value
% using vector magnitude and the options.moment.  We sum the translation
% and moment drift, which doesn't consider that the two might cancel.

  drift = zeros(length(perr.in_files), 1);
  for (f_ix = 1:length(perr.in_files))
    file1 = perr.in_files{f_ix};
    thisfile = find(perr.file_map == f_ix);
    thisfile = thisfile([1 end]);
    stage_mo = perr.motion_poses(thisfile, 13:18);
    % We check for the first and last poses being the same, rather than for being
    % a home pose, because axis positions can be nonzero when we do stage
    % error compensation.
    if (all(stage_mo(1, :) == stage_mo(2, :), 2))
      h_poses = perr.measured(thisfile, :);
      dp = pose_difference(h_poses(1, :), h_poses(2, :));
      d_mag = norm(dp(1:3)) + options.moment*norm(dp(4:6));
      drift(f_ix) = d_mag;
      if (d_mag >= options.drift_threshold)
        fprintf(1, 'Warning: drift %.3g in %s: ', d_mag, file1);
        disp(dp);
      end
    else
      fprintf(1, '%s: no home poses, skipping drift check.\n', file1);
    end
  end
end
