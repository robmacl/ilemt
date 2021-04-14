function [poses] = fk_pose_calculation (stage_poses, so_fix, se_fix)
% Calculate poses as pose vectors, using stage forward kinematics and
% fixture transforms.

  % Convert from pose vectors to transform matrices
  source_fixture = pose2trans(so_fix);
  sensor_fixture = pose2trans(se_fix);

  poses = zeros(size(stage_poses));
  % Calculate FK pose for each stage pose
  for (ix = 1:size(stage_poses, 1))
    % Convert stage_poses(ix, :) to transform matrix st
    st = vector2tr(stage_poses(ix, :)); 
    % 'Pose' is transform matrix of sensor pose in source coordinates.
    Pose = source_fixture * st * sensor_fixture;
    % Convert transform matrix into a pose vector
    poses(ix, :) = trans2pose(Pose);
  end
end
