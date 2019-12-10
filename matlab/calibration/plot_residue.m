data = getreal('calibrate_out.dat');
stage_poses=data(:, 1:6);
for i = 1:size(data,1)
        cd=reshape(data(i,7:15),3,3);
        c_des(:,:,i)=cd;
end

n=size(stage_poses,1);
[residue] = calibrate_objective (state0, stage_poses, c_des);
for i=1:n
r(1,i)=sqrt(sum(sum(residue(:,:,i).^2)));
end

figure(2)
plot(r,1:84,'-o',...
    'LineWidth',0.5,...
    'MarkerSize',3)
title('Residue for state0')
xlabel('residue')
ylabel('n. of pose')

[new_residue] = calibrate_objective (state_new, stage_poses, c_des);
for i=1:n
r_new(1,i)=sqrt(sum(sum(new_residue(:,:,i).^2)));
end

figure(3)
plot(r_new,1:84,'-o',...
    'LineWidth',0.5,...
    'MarkerSize',3)
title('Residue for state_new')
xlabel('residue')
ylabel('n. of pose')