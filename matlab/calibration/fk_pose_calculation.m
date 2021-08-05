function [poses] = fk_pose_calculation (motion_poses, so_fix, st_fix, se_fix)
% Calculate poses as pose vectors, using motion forward kinematics and fixture
% transforms.  During calibration and testing this is the desired (or ground
% truth) pose.

  % Convert from pose vectors to transform matrices
  so_fixture = pose2trans(so_fix);
  st_fixture = pose2trans(st_fix);
  se_fixture = pose2trans(se_fix);

  poses = zeros(size(motion_poses, 1), 6);
  % Calculate FK pose for each stage pose
  for (ix = 1:size(motion_poses, 1))
    % Convert motion_poses(ix, :) to transform matrix st
    so_motion = vector2tr(motion_poses(ix, 1:6)); 
    se_motion = vector2tr(motion_poses(ix, 7:12)); 
    
    % 'P' is a transform matrix for the sensor pose in source coordinates, which
    % is the very definition of the tracker output.  See calibrate_objective()
    % for discussion of the calibration kinematic chain.
    P = so_fixture * so_motion * st_fixture * se_motion * se_fixture;

    % Convert transform matrix into a pose vector
    poses(ix, :) = trans2pose(P);
  end
end
