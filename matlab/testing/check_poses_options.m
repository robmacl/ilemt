function [options] = check_poses_options (cal_options, key_value)
% Return options struct for the check_poses.  This sets defaults and then runs
% the local_check_options.m script.

  % Calibration to use
  options.cal_file = [];

  % Text tag for this analysis variant, placed in figure header.
  options.variant = 'default';

  % Input test data
  options.in_files = cal_options.in_files;

  % If true, apply linear correction to measured poses.
  options.linear_correction = true;
  
  % Method for pose calculation.  Values: 'optimize', 'kim18'.  See
  % pose_calculation().
  if (cal_options.concentric)
    options.pose_solution = 'kim18';
  else
    options.pose_solution = 'optimize';
  end
  
  % If non-empty, this is a calibration file which can be used with Kim18
  % to initialize the 'optimize' pose solution.
  options.concentric_cal_file = [];

  % ishigh: if true, check high rate, otherwise low rate.
  options.ishigh = cal_options.ishigh;

  % valid_threshold: if pose solution residue is greater than this, then discard
  % the point as "invalid".
  options.valid_threshold = 1e-5;

  % optimize_fixtures: what fixture transforms we optimize to try to reduce
  % error.  Cell vector of any of 'source', 'stage', 'sensor'.  Default {}.
  options.optimize_fixtures = {};

  % moment: moment used in optimization to trade angular vs. translation error
  % (m).
  options.moment = 0.05;

  % What hemisphere the pose is constrained to: 1, 2, 3 for XYZ, negative
  % if the minus hemisphere.  eg. -2 is the -X hemisphere.  If 0 then set
  % automatically using the ground truth pose (which may not work if there
  % is a large change in the fixture poses).
  options.hemisphere = 0;
  
  % axis_limits(6, 2): for each axis, the [min, max] range of data to
  % analyze (mm, degrees).  Outside this range is discarded.  
  % ### This was an Euler angles style stage pose, now placeholder
  options.axis_limits = repmat([-inf, inf], 6, 1);

  % Parameters for Savitzky-Golay filter used to smooth and differentiate
  % the results: polynomial order and window width.
  options.sg_filt_N = 2;
  options.sg_filt_F = 11;

  % xyz_exaggerate: exaggeration to use in 3D trans->trans error views.
  % rot_xyz_exaggerate: for rot->trans error
  options.xyz_exaggerate = 10; % m/m
  options.rot_xyz_exaggerate = 300; % m/rad

  % If true, transform to stage coordinates in 3D views.  Gives a prettier
  % picture when there is gross rotation of the source.
  options.stage_coords = true;
  
  % What reports and plots to generate:
  % overall: text report of RMS and max error
  % correlation: test report of error correlations
  % workspace: 3D plot of error vectors.
  % sweep: axis sweep linearity tests, plots and excel.
  options.reports = {'overall', 'workspace'};

  % For sweep report, detailed cross coupling response from these axes.
  options.axis_response = [6];

  % For read_cal_data()
  options.sensor_signs = cal_options.sensor_signs;
  options.source_signs = cal_options.source_signs;

  optfile = './local_check_options.m';
  if (exist(optfile, 'file'))
    run(optfile);
  end

  for (key_ix = 1:2:(length(key_value) - 1))
    key = key_value{key_ix};
    if (isfield(options, key))
      options.(key) = key_value{key_ix + 1};
    end
  end

  global last_calibration;

  if (isempty(options.cal_file))
    if (isempty(last_calibration))
      error('No last_calibration, must specifiy options.cal_file');
    end
    fprintf(1, 'Checking last_calibration "%s".\n', last_calibration);
    options.cal_file = last_calibration;
  end

end % check_poses_options
