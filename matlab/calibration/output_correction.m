function [calibration] = output_correction (calibration, cal_options)
% Apply additional correction to calibration based on the pose solution.
% Currently this is based on linear transforms.  'cal_options' is the
% calibration options.

  if (strcmp(cal_options.correct_mode, 'none'))
    return;
  end

  % Doing the fixture optimization here is useful because the calibration
  % optimization chooses fixtures which minimize the coupling error, while the
  % check_poses() fixture optimization directly minimizes the pose error.
  % Also, having fixture error is going to reduce the performance of the
  % linear correction itself.
  opt_fix = {};
  if (any(strcmp(cal_options.optimize, 'so_fix')))
    opt_fix{end+1} = 'source';
  end
  if (any(strcmp(cal_options.optimize, 'st_fix')))
    opt_fix{end+1} = 'stage';
  end
  if (any(strcmp(cal_options.optimize, 'se_fix')))
    opt_fix{end+1} = 'sensor';
  end
  
  % -- Don't do any correction on the pose, since that is what we are trying
  %    to compute.
  % -- Pose error must be in ordinary output coordinates (source)
  % -- Use whatever input files we used for calibration.
  opts = {
      'linear_correction', false, ...
      'stage_coords', false, ...
      'in_files', cal_options.in_files, ...
      'cal_file', cal_options.out_file, ...
      'optimize_fixtures', opt_fix
         };

  % This stuff works using the check_poses() features, so we need a
  % check_poses_options(), but we explicitly set some options to override
  % anything that might have come from eg. local_check_options.m, because the
  % check data is not always the same as the calibration data.  Otherwise we
  % could get weird results if we have been eg. checking an axis sweep.
  cp_options = check_poses_options(cal_options, opts);
  
  perr = find_pose_errors(calibration, cp_options);
  calibration = linear_correction(perr, cp_options, cal_options, calibration);
end
