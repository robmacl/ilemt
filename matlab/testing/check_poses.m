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


options = check_poses_defaults();
options.xyz_exaggerate = 2;

%options.sg_filt_F = 9;
%options.axis_limits(6, :) = [-13, 13];
%options.do_optimize = 1;

%data_file = {'Z_rot_ld.dat', 'X_rot_ld.dat', 'Y_rot_ld.dat'};
data_file = {'Z_rot_sd.dat', 'X_rot_sd.dat', 'Y_rot_sd.dat'};
cal = load('Calibration_sayan dipole-only.mat');

perr = find_pose_errors(data_file, cal.hr_cal, cal.hr_so_fix, cal.hr_se_fix, options);

perr_report_overall(perr);

% Useful mainly for grid patterns, not axis sweeps.
perr_workspace_vol(perr, options);

if (false)
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
end
