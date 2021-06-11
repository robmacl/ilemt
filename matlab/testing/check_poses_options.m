function [options] = check_poses_options (cal_options)
% Return options struct for the check_poses.  This sets defaults and then runs
% the local_check_options.m script.

  % ishigh: if true, check high rate, otherwise low rate.
  options.ishigh = cal_options.ishigh;

  % valid_threshold: if pose solution residue is greater than this, then discard
  % the point as "invalid".
  options.valid_threshold = 1e-5;

  % do_optimize: whether to do optimization of fixture transform to try to
  % reduce error.  Values: false, 'source', 'sensor', or 'both'.  Default
  % false.
  options.do_optimize = false;

  % moment: moment used in optimization to trade angular vs. translation error
  % (m).
  options.moment = 0.05;

  % Method for pose calculation.  Values: 'optimize', 'kim18'.  See
  % pose_calculation().
  options.pose_solution = 'optimize';

  % If true, apply linear correction to measured poses.
  options.linear_correction = false;
  
  % axis_limits(6, 2): for each axis, the [min, max] range of data to
  % analyze (mm, degrees).  Outside this range is discarded.  
  % ### This was an Euler angles style stage pose, now placeholder
  options.axis_limits = repmat([-inf, inf], 6, 1);

  % Parameters for Savitzky-Golay filter used to smooth and differentiate
  % the results: polynomial order and window width.
  options.sg_filt_N = 2;
  options.sg_filt_F = 17;

  % ### ASAP specific special case
  options.onax_ignore_Rz_coupling = false;

  % xyz_exaggerate: exaggeration to use in 3D trans->trans error views.
  % rot_xyz_exaggerate: for rot->trans error
  options.xyz_exaggerate = 10; % m/m
  options.rot_xyz_exaggerate = 300; % m/rad

  % If true, transform to stage coordinates in 3D views.  Gives a prettier
  % picture when there is gross rotation of the source.
  options.stage_coords = true;
  
  % If true, this is axis sweep data, otherwise more general data, such as
  % calibration pattern.
  options.issweep = false;

  % Calibration to use
  options.cal_file = 'XYZ_hr_cal.mat';

  % For read_cal_data()
  options.sensor_signs = cal_options.sensor_signs;
  options.source_signs = cal_options.source_signs;
  options.in_files = cal_options.in_files;

  run('./local_check_options.m');
end
