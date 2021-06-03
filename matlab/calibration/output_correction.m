function [] = output_correction (cal_options)
% Apply additional correction to calibration based on the pose solution.
% Currently this is based on linear transforms.  'cal_options' is the
% calibration options.

  % This stuff works using the check_poses() features, so we need a
  % check_poses_options(), but there may local_check_options.m, which may
  % give weird results if we have been eg. checking an axis sweep.
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
