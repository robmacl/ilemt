
n = size(poses,1);

%exaggerated dispacement error plot
k = 3;
err = [];
opt_poses_tr = [];

%{
for i = 1:n
  e = (poses_tr(i,1:3) - fk_poses_tr(i,1:3)) / norm(poses_tr(i,1:3) - fk_poses_tr(i,1:3));
  err = [err; e];
  poses = (k * norm(poses_tr(i,1:3) - fk_poses_tr(i,1:3))' * e) + fk_poses_tr(i,1:3);
  opt_poses_tr = [opt_poses_tr; poses];
end 

figure(2)
for i = 1:n
  x = [fk_poses_tr(i,1), opt_poses_tr(i,1)];
  y = [fk_poses_tr(i,2), opt_poses_tr(i,2)];
  z = [fk_poses_tr(i,3), opt_poses_tr(i,3)];
  plot3(x,y,z, 'r')
  hold on
  scatter3(fk_poses_tr(i,1), fk_poses_tr(i,2), fk_poses_tr(i,3), 'b*')
end

xlabel('X')
ylabel('Y')
zlabel('Z')
title('3D map of displacement error')

legend('Error', 'FK pose')
%}


%dispacement error plot
figure(2)
for i = 1:n
  x = [fk_poses_tr(i,1), poses_tr(i,1)];
  y = [fk_poses_tr(i,2), poses_tr(i,2)];
  z = [fk_poses_tr(i,3), poses_tr(i,3)];
  plot3(x,y,z, 'r')
  hold on
  scatter3(fk_poses_tr(i,1), fk_poses_tr(i,2), fk_poses_tr(i,3), 'b*')
end

xlabel('X')
ylabel('Y')
zlabel('Z')
title('3D map of displacement error')

legend('Error', 'FK pose') 




figure(3)
error = [];
distance = [];

for i = 1:n
  err = sqrt(((tr_err(i,1))^2)+((tr_err(i,2))^2)+((tr_err(i,3))^2));
  error = [error err];
  
  dist = sqrt(((poses_tr(i,1))^2)+((poses_tr(i,2))^2)+((poses_tr(i,3))^2));
  distance = [distance dist];
end

scatter(distance, error)

xlabel('Source-sensor distance')
ylabel('Error magnitude')




figure(4)
histogram(sqrt(tr_err.^2))

title('Translation error')



figure(5)
histogram(sqrt(rot_err.^2))

title('Rotation error')



figure(6)
error = sqrt(sum(tr_err.^2, 2));
scatter(error, resnorms)

xlabel('Pose error')
ylabel('Pose calculation residuals')
