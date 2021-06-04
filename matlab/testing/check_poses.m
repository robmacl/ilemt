% Check accuracy of pose measurements.  Driven by check_poses_options()
% struct.

cal_options = calibrate_options();
options = check_poses_options(cal_options);

disp(options);

perr = find_pose_errors(options);

perr_report_overall(perr);
%perr_report_correlation(perr);

% Useful mainly for grid patterns, not axis sweeps.
perr_workspace_vol(perr, options);

if (options.issweep)
  onax=perr_on_axis(perr, options);
  perr_axis_plot(perr, onax, options);

  % Write summary Excel file in data directory.  This uses the
  % check_poses.xslx template.
  % figure() 3, 4
  perr_axis_stats(perr, onax, options);

  % Response of every axis to an individual axis.  Not done on all axes by
  % default because it's too much clutter.
  %figure(5)
  %perr_axis_response(perr,onax,6);
end

%figure(11)
%error_scatter(perr);
