function [res] = check_poses (varargin)
% Check accuracy of pose measurements.  Driven by check_poses_options()
% struct.  Our main effect is printing and plots, but we return a result
% struct of various interesting things.

%%% Options processing:

fprintf(1, '\nChecking from: %s\n', pwd());

cal_options = calibrate_options('check_poses', varargin);
options = check_poses_options(cal_options, varargin);
check_options({cal_options, options}, varargin);

%{
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
%}
disp(options);

calibration = load_cal_file(options.cal_file);


%%% Main body:

% Load data, optimize fixtures and find errors at each point.
perr = find_pose_errors(calibration, options);

res.cal_options = cal_options;
res.options = options;
res.perr = perr;
res.onax = [];
res.calibration = calibration;

overall = perr_residue_stats(perr, options);

if (isempty(perr.errors))
  fprintf(1, 'check_poses: no data to check, skipping...\n');
  return;
end

% RMS/max summary statistics
res.overall = perr_report_overall(perr, options, overall);

% These are per-file drift and moment error info
res.drift = perr_report_drift(perr, options);
res.moment_error = perr_sanity_check(perr, options);

if (any(strcmp(options.reports, 'files')))
  perr_report_files(perr, options, res);
end

if (any(strcmp(options.reports, 'correlation')))
  perr_report_correlation(perr);
end

if (any(strcmp(options.reports, 'workspace')))
  perr_workspace_vol(perr, options);
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
  res.onax = onax;
end

if (any(strcmp(options.reports, 'scatter')))
  error_scatter(perr, options);
end
