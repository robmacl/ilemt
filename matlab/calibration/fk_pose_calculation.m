function [poses] = fk_pose_calculation (motion_poses, so_fix, st_fix, se_fix, ax_fix, st_scale)
% Calculate poses as pose vectors, using motion forward kinematics and fixture
% transforms.  During calibration and testing this is the desired (or ground
% truth) pose.  ax_fix and st_scale are the optional stage rotation axis
% alignment and stage translation scale (see motion_transforms()).

  if (nargin < 5)
    ax_fix = [];
  end
  if (nargin < 6)
    st_scale = [];
  end

  % Convert from pose vectors to transform matrices
  so_fixture = pose2trans(so_fix);
  st_fixture = pose2trans(st_fix);
  se_fixture = pose2trans(se_fix);

  [so_motion, st_motion] = motion_transforms(motion_poses, ax_fix, st_scale);

  % 'P' is a transform matrix for the sensor pose in source coordinates, which
  % is the very definition of the tracker output.  See calibrate_objective()
  % for discussion of the calibration kinematic chain.
  P = pagemtimes(pagemtimes(pagemtimes(pagemtimes( ...
      so_fixture, so_motion), st_fixture), st_motion), se_fixture);

  % Convert transform matrices into pose vectors
  poses = zeros(size(motion_poses, 1), 6);
  for (ix = 1:size(motion_poses, 1))
    poses(ix, :) = trans2pose(P(:, :, ix));
  end
end
