function [res] = check_poses (varargin)
% Check accuracy of pose measurements.  Driven by check_poses_options()
% struct.  Our main effect is printing and plots, but we return a result
% struct of various interesting things.

cal_options = calibrate_options('check_poses', varargin);
options = check_poses_options(cal_options, varargin);
check_options({cal_options, options}, varargin);

disp(pwd())
disp(options);

calibration = load(options.cal_file);
perr = find_pose_errors(calibration, options);

perr_report_overall(perr);
%perr_report_correlation(perr);

% Useful mainly for grid patterns, not axis sweeps.
perr_workspace_vol(perr, options);

if (options.issweep)
  onax = perr_on_axis(perr, options);
  perr_axis_plot(perr, onax, options);

  % Write summary Excel file in data directory.  This uses the
  % check_poses.xslx template.
  % figure() 3, 4
  perr_axis_stats(perr, onax, options);

  % Response of every axis to an individual axis.  Not done on all axes by
  % default because it's too much clutter.
  %figure(5)
  %perr_axis_response(perr,onax,6);
else
  onax = [];
end

res.cal_options = cal_options;
res.options = options;
res.perr = perr;
res.onax = onax;
res.calibration = calibration;

%figure(11)
%error_scatter(perr);
