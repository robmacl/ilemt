function [res] = check_poses (varargin)
% Check accuracy of pose measurements.  Driven by check_poses_options()
% struct.  Our main effect is printing and plots, but we return a result
% struct of various interesting things.

fprintf(1, '\nChecking from: %s\n', pwd());

cal_options = calibrate_options('check_poses', varargin);
options = check_poses_options(cal_options, varargin);
check_options({cal_options, options}, varargin);

% Options display.  Don't show all the options.
showopts = {'cal_file', 'variant', 'in_files', 'linear_correction', ...
            'pose_solution'};

for (ix = 1:length(showopts))
  show.(showopts{ix}) = options.(showopts{ix});
end

disp(show);


calibration = load(options.cal_file);
perr = find_pose_errors(calibration, options);

if (any(strcmp(options.reports, 'overall')))
  res.overall = perr_report_overall(perr);
end

if (any(strcmp(options.reports, 'correlation')))
  perr_report_correlation(perr);
end

if (any(strcmp(options.reports, 'workspace')))
  % Useful mainly for grid patterns, not axis sweeps.
  % figure_base + 3
  perr_workspace_vol(perr, options);
end

if (any(strcmp(options.reports, 'sweep')))
  onax = perr_on_axis(perr, options);
  perr_axis_plot(perr, onax, options);

  % Write summary Excel file in data directory.  This uses the
  % check_poses.xslx template.
  % figure_base + [4, 5]
  perr_axis_stats(perr, onax, options);

  % Response of every axis to an individual axis.  Not done on all axes by
  % default because it's too much clutter.
  for (ax = options.axis_response)
    % figure_base + 10 + ax
    perr_axis_response(perr, onax, ax, options);
  end
else
  onax = [];
end

% figure_base + 6
if (any(strcmp(options.reports, 'scatter')))
  error_scatter(perr, options);
end

res.cal_options = cal_options;
res.options = options;
res.perr = perr;
res.onax = onax;
res.calibration = calibration;

