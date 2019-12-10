% Check accuracy of poses (computed in labview) in an ASAP calibration data
% file (from asap_calibration.vi).  Points where ASAP data was invalid are
% ignored.
%
% Arguments: 
% data_file: Holds the test data file.  If this has no name
%   part, read_data will default to "calibration_ref.dat"
%
% options: struct, with fields:
% data_format: only works with format >= 3 (default)
%
% pose_ix: index of pose to check.  2 is handle pose, 3 is output.
%
% end_tf_offset(6): A pose vector of the "End transform offset" used in
%   asap_stage_calibration.vi. With grid data, this is used to rotate the
%   points by 45 degrees to make them fit in the workspace better, while the
%   pose isn't correspondingly rotated.
%
% Results: 
% res struct, with fields:
% pose_err(npoints, 6): The overall pose error as a 6-vector with the
%   units microns and radians, where the rotation part is a rotation vector,
%   not Euler angles. Although the difference will be small for small angles,
%   direction vectors are a sound basis for mean and other statistics, while
%   Euler angles (or even a 1DOF angle) aren't due to problems with wrapping.
%   Though the dimensions are the same, this vector can't be used with
%   pvec2tr.
%
% desired_pvec(npoints, 6):
% measured_pvec(npoints, 6):
% pose_err_pvec(npoints, 6):
%   The desired poses, measured poses and pose errors as pose vectors (mm,
%   degrees).
%
% F(4, 4): the fixture transform matrix, which maps stage points to ASAP
%   coordinates.
%
% data: result of read_data.  Note: this still has all the invalid points in it.
%
function [res] = find_pose_errors(data_file, options)
  data = read_data(data_file, options.data_format);
  valid = data.valid;
  vposes = data.poses;
  
  % Drop out bad points.
  ndrop = sum(~valid);
  vposes(~valid, :, :) = [];
  npoints = size(vposes, 1);
  if (ndrop)
    fprintf(1, 'Deleting %d invalid points, leaving %d.\n', ndrop, npoints);
  end

  % Initial fixture transform based on pinv of translation
  F_init = fixture_transform(pad_ones(vposes(:, 1:3, options.pose_ix) * 1e3), ...
			     pad_ones(vposes(:, 1:3, 1) * 1e3), 1);

  % State for minimization is: [C(1:3) pose(1:6)], mm X3, mm X3, degrees X3
  % see check_poses_objective.m
  %
  % Intial value of x based on last run.  Initial initial value is all ones,
  % giving what is (in our scaling) a small initial value.  This makes
  % optimization run much faster than all zeros, presumably because it
  % establishes the correct order of magnitude.
  persistent x;
  if (isempty(x))
    x = ones(1, 9);
  end

  ofun = @(vec) ...
    find_pose_errors_objective(vec, vposes, F_init, options); 

  if (options.do_optimize)
    opt_options = optimset('MaxFunEvals', 2000);
    %opt_options = optimset(options, 'PlotFcns', @optimplotresnorm);
    x_max = [20 20 20 1e-1 1e-1 1e-1 5 5 5];
    %x_max = [20 20 20 1e1 1e1 1e1 90 90 90];

    [x,resnorm,residual,exitflag,output] = ...
	lsqnonlin(ofun, x, -x_max, x_max, opt_options);
  
    x
  else
    fprintf(1, 'Not doing optimization.\n');
    x = zeros(1, 9);
  end

  [X_err, pose_err_pvec, desired_pvec, measured_pvec, F_opt] = ofun(x);

  pose_err = zeros(npoints, 6);
  pose_err(:, 1:3) = pose_err_pvec(:, 1:3) * 1e3;
  rot_emax = 5*pi/180;
  for (ix = 1:npoints)
    [theta, v] = tr2angvec(pvec2tr([0 0 0 pose_err_pvec(ix, 4:6)]));
    if (abs(theta) > rot_emax)
        fprintf(1, 'Large angular error: %f degrees at index %d\n', ...
                theta*180/pi, ix);
       theta = sign(theta)*rot_emax;
    end
    pose_err(ix, 4:6) = v * theta;
  end

  res = struct('pose_err', pose_err, 'pose_err_pvec', pose_err_pvec, ...
	       'desired_pvec', desired_pvec, ...
	       'measured_pvec', measured_pvec, ...
	       'F', F_opt, 'data', data);
end
