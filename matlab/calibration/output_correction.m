function [calibration] = output_correction (calibration, cal_options)
% Apply additional correction to calibration based on the pose solution.
% Currently this is based on linear transforms.  'cal_options' is the
% calibration options.

  if (strcmp(cal_options.correct_mode, 'none'))
    return;
  end

  % Don't do any correction on the pose, since that is what we are trying
  % to compute.
  % Use whatever input files we used for calibration.
  % We don't need fixture optimization, since the calibration was done on
  % this exact data.
  opts = {
      'linear_correction', false, ...
      'in_files', cal_options.in_files, ...
      'cal_file', cal_options.out_file, ...
      'optimize_fixtures', {}
         };

  % This stuff works using the check_poses() features, so we need a
  % check_poses_options(), but we explicitly set some options to override
  % anything that might have come from eg. local_check_options.m, because the
  % check data is not always the same as the calibration data.  Otherwise we
  % could get weird results if we have been eg. checking an axis sweep.
  cp_options = check_poses_options(cal_options, opts);
  
  perr = find_pose_errors(calibration, cp_options);
  calibration = linear_correction(perr, cal_options, calibration);
end
