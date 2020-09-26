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
  data = getreal(data_file);

  % vposes(point_ix, :, pose_ix) 
  % 
  % Each row is [x y z Rx Ry Rz] (units m/radian), see pose2trans(),
  % trans2pose(). 
  %
  % pose_ix=1 desired pose, from stage kinematics
  % pose_ix=2 measured pose
  vposes = pose_calculation(data);

  load('XZ_rotation_hr_cal');
  state0 = calibration2state(hr_cal, hr_so_fix, hr_se_fix);
  stage_poses = data(:, 1:6);
  vposes = cat(3, fk_pose_calculation(stage_poses, state0), vposes);

  % Leaving this here as placeholder for workspace enforcement.
  valid = true(size(data,1), 1);
  % Drop out bad points.
  ndrop = sum(~valid);
  vposes = vposes(valid, :, :);
  npoints = size(vposes, 1);
  if (ndrop)
    fprintf(1, 'Deleting %d invalid points, leaving %d.\n', ndrop, npoints);
  end

  % Initial source fixture transform based on pinv of translation.
  so_fix = trans2pose(source_fixture(pad_ones(vposes(:, 1:3, options.pose_ix)), ...
                                     pad_ones(vposes(:, 1:3, 1)));

  % State for minimization is: 
  %    [so_fixture_off(1:6) se_fixture_off(1:6)]
  % 
  % These are offsets from the nominal source and sensor fixture poses.  see
  % check_poses_objective.m.  This differs from the main calibration
  % optimization in that we operate in *pose* space, and that we are searching
  % for the source and sensor fixtures that minimize the *pose* error, not the
  % *coupling* error.  We need the pose error to evaluate performance.
  % 
  % ### seems we could also solve for the sensor fixture offset (in
  % rotation) using similar linear methods.  The only thing we don't get
  % from that is if there is some displacement of the sensor center of
  % rotation wrt the stage.  Probably could get even that by linear
  % equation.  
  % 
  % Also, I did not end up actually using the optimization with ASAP because
  % it did not help.

  % Intial value of x based on last run.  Initial initial value is all 1e-3,
  % giving what is (in our scaling) a small initial value.  This makes
  % optimization run much faster than all zeros, presumably because it
  % establishes the correct order of magnitude.
  persistent x;
  if (isempty(x))
    x = ones(1, 12) * 1e-3;
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
    x = zeros(1, 12);
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
