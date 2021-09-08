function [res] = check_poses (varargin)
% Check accuracy of pose measurements.  Driven by check_poses_options()
% struct.  Our main effect is printing and plots, but we return a result
% struct of various interesting things.

%%% Options processing:

fprintf(1, '\nChecking from: %s\n', pwd());

cal_options = calibrate_options('check_poses', varargin);
options = check_poses_options(cal_options, varargin);
check_options({cal_options, options}, varargin);

% Options display.  Don't show all the options.
showopts = {'cal_file', 'variant', 'in_files', 'linear_correction', ...
            'pose_solution', 'optimize_fixtures'};

for (ix = 1:length(showopts))
  wot = options.(showopts{ix});
  if (~isempty(wot))
    show.(showopts{ix}) = wot;
  end
end

disp(show);

calibration = load_cal_file(options.cal_file);


%%% Main body:

% Load data, optimize fixtures and find errors at each point.
perr = find_pose_errors(calibration, options);

if (any(strcmp(options.reports, 'overall')))
  res.overall = perr_report_overall(perr);
end

if (any(strcmp(options.reports, 'correlation')))
  perr_report_correlation(perr);
end

if (any(strcmp(options.reports, 'workspace')))
  % Plot of 
  % Useful mainly for grid patterns, not axis sweeps.
  perr_workspace_vol(perr, options);
end

if (any(strcmp(options.reports, 'drift')))
  perr_report_drift(perr, options);
end

if (any(strcmp(options.reports, 'sweep')))
  onax = perr_on_axis(perr, options);
  perr_axis_plot(perr, onax, options);

  % Write summary Excel file in data directory.  This uses the
  % check_poses.xslx template.
  perr_axis_stats(perr, onax, options);

  % Response of every axis to an individual axis.  Not done on all axes by
  % default because it's too much clutter.
  for (ax = options.axis_response)
    perr_axis_response(perr, onax, ax, options);
  end
else
  onax = [];
end

if (any(strcmp(options.reports, 'scatter')))
  error_scatter(perr, options);
end

res.cal_options = cal_options;
res.options = options;
res.perr = perr;
res.onax = onax;
res.calibration = calibration;
