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
  % ### this conditional default doesn't work unless you get 'concentric'
  % into cal_options either in the local_cal_options or key_value args.
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

  % valid_threshold: if pose solution normalized residue is greater than this,
  % then the point is "invalid".  If this happens, then usually either the
  % calibration is poor or the pose solution did not converge.  With
  % 'optimize' solution method we will try different initial states to see if
  % they work better.
  options.valid_threshold = 1e-5;

  % Discard points with residual > valid_threshold.
  options.discard_invalid = false;

  % optimize_fixtures: what fixture transforms we optimize to try to reduce
  % error.  Cell vector of any of 'source', 'stage', 'sensor'.  Default {}.
  % 
  % Enabling this is useful if there has been a gross change in the setup from
  % when the calibration was done, but is questionable for absolute accuracy
  % measurement, since it uses the test data ground truth itself to minimize
  % the error.  This undermines the data hygiene principle of using different
  % data for calibration and test, since we have extended a calibration
  % minimization into the test.
  options.optimize_fixtures = {};

  % moment: moment used in optimization to trade angular vs. translation error
  % in fixture optimization (m).
  options.moment = 0.05;

  % What hemisphere the pose is constrained to: 1, 2, 3 for XYZ, negative
  % if the minus hemisphere.  eg. -2 is the -X hemisphere.  If 0 then set
  % automatically using the ground truth pose.
  % 
  % NOTE: auto-hemisphere doesn't work if the initial fixture tranforms are so
  % far off that "desired" is put in the wrong hemisphere.  This can happen if
  % there is a fixturing error during data collection, or just large motion.
  % With large fixture errors the true solution could be anywhere.  This is
  % really mainly a problem with the source fixture, since the sensor fixture
  % does not change the hemisphere, and in the stage setup the sensor is
  % pretty much forced into the +Y hemisphere of the source fixture.
  options.hemisphere = 0;
  
  % If true then the ground truth pose is used as the initial value in the pose
  % solution.  This avoids convergence problems, but is of course unrealistic
  % as for evaluation of the pose solution algoithm's robustness.
  options.true_initial = false;

  % Parameters for Savitzky-Golay filter used to differentiate the axis sweep
  % results: polynomial order and window width.
  options.sg_filt_N = 2;
  options.sg_filt_F = 21;

  % xyz_exaggerate: exaggeration to use in 3D error views.  See
  % perr_workspace_vol().
  % 
  % Vector [trans->trans rot->trans trans->rot rot->rot].  If scalar, then
  % show only the first plot.
  options.xyz_exaggerate = [10 300 1 30];

  % If true, transform error to stage coordinates.  Gives a prettier picture
  % when there is gross rotation of the source.
  options.stage_coords = true;

  % What reports and plots to generate:
  % overall: text report of RMS and max error
  % files: report of per-file drift and error
  % correlation: test report of error correlations, kind of useless
  % workspace: 3D plots of error vectors and rot/trans cross-coupling
  % sweep: axis sweep linearity tests: plots and excel.
  % scatter: scatter plot of error vs. coupling magnitude etc.
  %
  % See check_poses() for more details on the reports.
  options.reports = {'overall', 'workspace'};
  
  % If drift is greater than this, then report drift.  Angular error is scaled
  % using 'moment'.  (meters)
  options.drift_threshold = 20e-6;
  
  % If RMS moment error is greater than this for a particular input file, then
  % report that file.  (meters)
  options.error_threshold = 2e-3;

  % For sweep report, detailed cross coupling response from these axes.
  options.axis_response = [6];
  
  % If true, include on-axis response in perr_axis_plot()
  options.plot_on_axis = false;
  
  % X axis in error_scatter() plot. 'coupling', 'distance' or 'residual'.
  options.scatter_x_axis = 'residual';

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
