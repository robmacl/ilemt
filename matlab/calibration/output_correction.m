function [] = output_correction (cal_options)
% Apply additional correction to calibration based on the pose solution.
% Currently this is based on linear transforms.  'cal_options' is the
% calibration options.

  if (strcmp(cal_options.correct_mode, 'none'))
    return;
  end

  % This stuff works using the check_poses() features, so we need a
  % check_poses_options(), but we explicitly set some options to override
  % anything that might have come from eg. local_check_options.m, because the
  % check data is not always the same as the calibration data.  Otherwise we
  % could get weird results if we have been eg. checking an axis sweep.
  cp_options = check_poses_options(cal_options);
  
  % Don't do any correction on the pose, since that is what we are trying
  % to compute.
  cp_options.linear_correction = false;

  % Use whatever input files to whatever we used for calibration.
  cp_options.in_files = cal_options.in_files;

  % Correction input is the current output
  cp_options.cal_file = cal_options.out_file;
  
  % We don't need fixture optimization, since the calibration was done on
  % this exact data.
  cp_options.do_optimize = false;
  
  perr = find_pose_errors(cp_options);
  linear_correction(perr, cp_options, cal_options);
end
