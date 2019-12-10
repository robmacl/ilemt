function [end_poses] = pose_adapt(poses)

n=size(poses); %read how much row we have

end_poses=[]; %create the final poses matrix

tras_pose=[];

for i=1:n
    for j=1:3
        end_poses_new=(0.2/1.25).*poses(i,j); %adapt the tX, tY and tZ value
        tras_pose(i,j)=end_poses_new;
    end
end

end_poses=[tras_pose(:,1), tras_pose(:,2), tras_pose(:,3), poses(:,4), poses(:,5), poses(:,6)];