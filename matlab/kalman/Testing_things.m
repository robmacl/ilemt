global calibration;

load('gain_calibration');

info = dlmread('high-low test3.txt');

pose0 = [0.2,0,0,0,0,0];
pose1 = [0.2,0,0,0,0,0];

lb = [0,-inf,-inf,-inf,-inf,-inf];
ub = [inf,inf,inf,inf,inf,inf];

info_low = info(info(:,2) == 1, :); 
info_hi = info(info(:,2) == 0, :);

poses_low = coupling2pose(info_low,pose0,lb,ub);
poses_hi = coupling2pose(info_hi,pose0,lb,ub);

times_low = info_low(:,1);
times_hi = info_hi(:,1);

figure(1)
plot(times_low, poses_low(:,1), times_hi, poses_hi(:,1))
legend('Low','High')
title('\Phi','FontSize',40,'FontWeight','bold')

figure(2)
plot(times_low, poses_low(:,2), times_hi, poses_hi(:,2))
legend('Low','High')
title('\Theta','FontSize',40,'FontWeight','bold')

figure(3)
plot(times_low, poses_low(:,3), times_hi, poses_hi(:,3))
legend('Low','High')
title('\Psi','FontSize',40,'FontWeight','bold')

figure(4)
plot(times_low, poses_low(:,4), times_hi, poses_hi(:,4))
legend('Low','High')
title('X','FontSize',40,'FontWeight','bold')

figure(5)
plot(times_low, poses_low(:,5), times_hi, poses_hi(:,5))
legend('Low','High')
title('Y','FontSize',40,'FontWeight','bold')

figure(6)
plot(times_low, poses_low(:,6), times_hi, poses_hi(:,6))
legend('Low','High')
title('Z','FontSize',40,'FontWeight','bold')

figure(7)
plot3(poses_hi(:,4),poses_hi(:,5),poses_hi(:,6),poses_low(:,4),poses_low(:,5),poses_low(:,6))