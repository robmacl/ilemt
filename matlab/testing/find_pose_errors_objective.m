function [X_err, pose_err_pvec, desired_pvec, measured_pvec, F_opt] = ...
      find_pose_errors_objective(x, vposes, F, options)
% State for minimization is: [C(1:3) pose(1:6)], where C is the position (in
% mm) of the light in the fixture (test pattern) coordinates and "pose" is a
% pose vector adjustment to F (fixture transform, pose of ASAP in fixture
% coordinates.)
%
% X_err(9): The residual for optimization, scaled to mm. In X_err, we weight the
%   rotation according to a moment, given angle in degrees and translation in
%   mm. By default we use an unrealistically short moment, because rotation
%   error dominates tip error, and rotation error can hardly be budged by this
%   optimization.  With a realistic moment (50mm) what it does is make
%   translation error a lot worse to bring it in line with the rotation error,
%   buying only a tiny reduction in rotation error.
%
% pose_err_pvec(npoints, 6): the pose error, as a pose vector (stage end
%   coordinates)
%
% desired_pvec(npoints, 6): the desired pose, as a pose vector (stage end
%   coordinates). This only differs from stage pose when X is nonzero, which
%   isn't the case if we don't do optimization, and are just using this
%   function to find the residuals. The measured pose is desired * pose_err.
%
% measured_pvec(npoints, 6): the measured pose, as a pose vector.

  npoints = size(vposes, 1);
  C = x(1:3)*1e3;
  F_opt = F * pvec2tr(x(4:9));

  pose_err_pvec = zeros(npoints, 6);
  if (nargout > 1)
    desired_pvec = zeros(npoints, 6);
    measured_pvec = zeros(npoints, 6);
  end

  for ix = 1:npoints
    stage = pvec2tr(vposes(ix, :, 1));
    output = pvec2tr(vposes(ix, :, options.pose_ix));

    measured = F_opt * output;
    err_trans = tr2pvec(pvec2tr(options.end_tf_offset) * inv(stage) * measured);
    meas_xyz = measured * [0 0 0 1]' * 1e-3;
    desired_xyz = stage * [C 1]' * 1e-3;

    pose_err_pvec(ix, 1:3) = meas_xyz(1:3) - desired_xyz(1:3);
    pose_err_pvec(ix, 4:6) = err_trans(4:6);

    if (nargout > 1)
      desired_pvec(ix, 1:3) = desired_xyz(1:3);
      desired_pvec(ix, 4:6) = vposes(ix, 4:6, 1);
      measured_pvec(ix, :) = tr2pvec(measured);
    end
  end

  rot_weight = pi/180 * options.moment;
  X_err = [pose_err_pvec(:, 1:3) pose_err_pvec(:, 4:6) * rot_weight];
end
