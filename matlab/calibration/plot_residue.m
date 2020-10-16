%generate plots to compare residue obtained with two state vectors using
%calibrate_objective function.
%the residue is obtained with the mismatch between the predicted poses calculated with pose solution and actual poses calculated with the
%forwaard kinematics 
data = getreal('calibrate_out.dat');
stage_poses=data(:, 1:6);
%extract couplings matrix from ythe data file
for i = 1:size(data,1)
  cd=reshape(data(i,7:15),3,3);
  c_des(:,:,i)=cd;
end

n=size(stage_poses,1);
%state 0 residue
[residue] = calibrate_objective (state0, stage_poses, c_des);
for i=1:n
  r(1,i)=sqrt(sum(sum(residue(:,:,i).^2)));
end

figure
plot(r,1:84,'-o',...
    'LineWidth',0.5,...
    'MarkerSize',3)
title('Residue for state0')
xlabel('residue')
ylabel('n. of pose')

%new state residue
[new_residue] = calibrate_objective (state_new, stage_poses, c_des);
for i=1:n
 r_new(1,i)=sqrt(sum(sum(new_residue(:,:,i).^2)));
end

figure
plot(r_new,1:84,'-o',...
    'LineWidth',0.5,...
    'MarkerSize',3)
title('Residue for state_new')
xlabel('residue')
ylabel('n. of pose')