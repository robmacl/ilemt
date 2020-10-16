%Calculate poses usign forward kinematics method
function [poses] = fk_pose_calculation (stage_poses, state)
  state_defs;
  poses = [];
  npoints = size(stage_poses, 1);
  
  %Extract source_fixture and sensor_fixture from state vector and
  %convert to transform matrices
  source_fixture = pose2trans([state(source_fixture_pos_slice), state(source_fixture_orientation_slice)]);
  sensor_fixture = pose2trans([state(sensor_fixture_pos_slice), state(sensor_fixture_orientation_slice)]);

    %Calculate pose for each stage pose
    for i = 1:npoints
      %Convert stage_poses(i, :) to transform matrix st
      st=vector2tr(stage_poses(i,:)); 
      %transform matrix, sensor with respect to the source, of i pose
      %forward kinematics
      Pose = source_fixture * st * sensor_fixture;
      %covert transform matrix into a pose vector
      pose = trans2pose(Pose);
      poses = [poses; pose];
    end
        
end