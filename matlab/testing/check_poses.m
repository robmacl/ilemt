% Check accuracy of pose measurements.
% 
% Arguments:
% data_file: The measured pose data, from asap_calibration.vi
%
% options: a struct, see check_poses_defaults.m
%
%{
function [perr, onax] = check_poses(data_file, options)

  if (nargin < 2 || isempty(options))
     options = check_poses_defaults();
  end
%}

data_file='../cal_data\SN1\new_probe\axis_sweep_test_out_new_floc.dat'
options = check_poses_defaults();
%options.sg_filt_F = 9;
%options.axis_limits(6, :) = [-13, 13];

calibration = ###
so_fix = ###
se_fix = ###
  perr = find_pose_errors(data_file, calibration, so_fix, se_fix, options);

  perr_report_overall(perr);

  % Useful mainly for grid patterns, not axis sweeps.
  %perr_workspace_vol(perr, options);

  onax=perr_on_axis(perr, options);
  perr_axis_plot(perr, onax, options);

  % Write summary Excel file in data directory.  You can copy template from
  % check_poses.xslx.
  % figure() 3, 4
  perr_axis_stats(data_file, perr, onax, options);

  % Single axis response to an individual axis.  Not done on all axes by
  % default because it's too much clutter.
  figure(5)
  perr_axis_response(perr,onax,6);


  perr_workspace_vol(perr, options)
