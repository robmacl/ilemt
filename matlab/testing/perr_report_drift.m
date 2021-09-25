function [drift] = perr_report_drift (perr, options)
% Check the magnitude of pose drift during collection.  For each file, if
% there are stage null poses, then compare the measurement of the first and
% last poses.  The pose change is converted into a scalar meters value
% using vector magnitude and the options.moment.  We sum the translation
% and moment drift, which doesn't consider that the two might cancel.

  stage_mo = perr.motion_poses(:, 13:18);
  ishome = all(stage_mo == 0, 2);
  drift = zeros(length(perr.in_files), 1);
  for (f_ix = 1:length(perr.in_files))
    file1 = perr.in_files{f_ix};
    home1 = (ishome & (perr.file_map == f_ix));
    h_poses = perr.measured(home1, :);
    if (size(h_poses, 1) >= 2)
      dp = pose_difference(h_poses(1, :), h_poses(end, :));
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
