function [poses] = fk_pose_calculation (stage_poses, state)
state_defs;
poses = [];
npoints = size(stage_poses, 1);


        source_fixture = pose2trans([state(source_fixture_pos_slice), state(source_fixture_orientation_slice)]);
        sensor_fixture = pose2trans([state(sensor_fixture_pos_slice), state(sensor_fixture_orientation_slice)]);
        
        for i = 1:npoints
        st=vector2tr(stage_poses(i,:)); 
        Pose = source_fixture * st * sensor_fixture;
        pose = trans2pose(Pose);
        poses = [poses; pose];
        end
        
end