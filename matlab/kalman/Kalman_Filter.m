%getting Rw matrix
dataNHM = dlmread('base noise value - no hand motion.txt');
dataHM = dlmread('high-low test4.txt'); % moving  

dt = (dataHM(end,1) - dataHM(1,1))/size(dataHM,1);
dt = 100*dt;

timeVec = linspace(1,dataHM(end,1) - dataHM(1,1),115);
dataHMs = dataHM(1:100:end,:);
dataNHMs = dataNHM(1:100:end,:);

pose0 = [0.5,0.5,1,0.5,0.5,0.5];
pose0 = [0,0,0,0.2,0,0];

pose00 = [0.5,0.5,1,0.5,0.5,0.5]; 
pose00 = [0,0,0,0.2,0,0];

lb = [-inf,-inf,-inf,0,-inf,-inf];
ub = [inf,inf,inf,inf,inf,inf];

poses = [];
poses_all = [];
poses_ID = [];
corr_hf_poses = [];
hf_poses = [];
lhf_poses = [];

% use optimizer for no motion data
for i = 1:size(dataNHM,1)
    Cdes = reshape(dataNHM(i,2:end),3,3);
    poseM = lsqnonlin(@(pose)CError(Cdes,pose),pose0,lb,ub);
    format long
    pose0 = poseM;
    poses = [poses; pose0];
end

% use optimizer for hand motion data
for a = 1:size(dataHM,1)
    Cdes = reshape(dataHM(a,3:end),3,3);
    poseA = lsqnonlin(@(pose)CError(Cdes,pose),pose0,lb,ub);
    format long
    pose0 = poseA;
    poses_all = [poses_all; pose0];
end

% add 1 or 0 marker to all the poses from pose_all
for b = 1:size(dataHM,1)
    poses_new = [dataHM(b,2) poses_all(b,:)];
    poses_ID = [poses_ID; poses_new];
end
    
% determine high rate point that follows low rate point
for c = 1:length(poses_ID(:,1))
    if poses_ID(c,1) == 1
        corr_hf_poses = [corr_hf_poses; poses_ID(c+1,:)];
    end
end

% create separate lists for high and low/high info
for d = 1:size(dataHM,1)
    if dataHM(d,2) == 0 % for high rate data
        Cdes = reshape(dataHM(d,3:end),3,3);
        poseB = lsqnonlin(@(pose)CError(Cdes,pose),pose0,lb,ub);
        format long
        pose0 = poseB;
        hf_poses = [hf_poses; pose0];
        
    else % for high and low rate data
        Cdes = reshape(dataHM(d,3:end),3,3);
        poseC = lsqnonlin(@(pose)CError(Cdes,pose),pose00,lb,ub);
        format long
        pose00 = poseC;
        lhf_poses = [lhf_poses; pose00];
    end
end

hf_info = std(detrend(hf_poses));
hf_w = max(hf_info(4:6));
% ws = [w w w 5*10^(-3) 5*10^(-3) 5*10^(-3)];
hf_ws = [0.5 0.5 5 5*10^(-10) 5*10^(-5) 5*10^(-5)]; % 5*10^(-10) works best for angles
hf_Rw = diag(hf_ws);

lhf_info = std(detrend(lhf_poses));
lhf_w = max(lhf_info(4:6));
% ws = [w w w 5*10^(-3) 5*10^(-3) 5*10^(-3)];
lhf_ws = [0.5 0.5 5 5*10^(-10) 5*10^(-5) 5*10^(-5) 0.5 0.5 5 5*10^(-10) 5*10^(-5) 5*10^(-5)]; % 5*10^(-10) works best for angles
lhf_Rw = diag(lhf_ws);
    

% Kalman Filter Implementation
% given constant
I1 = eye(15);
I2 = eye(21);
M = 0.05;
d1 = [50 50 50 0.03 0.03 0.03 1*10^(-5) 1*10^(-5) 1*10^(-5) ones(1,6)];
d2 = [50 50 50 0.03 0.03 0.03 1*10^(-5) 1*10^(-5) 1*10^(-5) ones(1,12)];

hf_x_est_save = [];
hf_x_up_save = [];
hf_x_up(:,1) = [hf_poses(1,4:6) zeros(1,12)]'; % initialize location
hf_P_up = diag(d1); % initialize covariance
hf_P_up_save{1} = hf_P_up;
hf_phiVec = [];
hf_thetaVec = [];
hf_psiVec = [];

lhf_x_est_save = [];
lhf_x_up_save = [];
lhf_x_up(:,1) = [hf_poses(1,4:6) zeros(1,12) lhf_poses(1,4:6) zeros(1,3)]'; % initialize location
lhf_P_up = diag(d2); % initialize covariance
lhf_P_up_save{1} = lhf_P_up;
lhf_phiVec = [];
lhf_thetaVec = [];
lhf_psiVec = [];
 

 for i = 1: length(dataHM) 
     i
    % High Frequency Kalman Filter
    if dataHM(i,2) == 0;
        for k = 1:size(hf_poses);
            k
            hf_theta = norm(hf_poses(k,4:6));
            if hf_theta == 0
                R1 = eye(3);
            else
                R1 = vrrotvec2mat([hf_poses(k,4:6)./hf_theta, hf_theta]);
            end
            eul = R2E(R1);
            hf_phi = eul(1);
            hf_phiVec = [hf_phiVec, hf_phi];
            hf_theta = eul(2);
            hf_thetaVec = [hf_thetaVec,hf_theta];
            hf_psi = eul(3);
            hf_psiVec = [hf_psiVec, hf_psi];
            

            A1 = [1 0 0 dt 0  0  dt^2/2    0      0   zeros(1,6);
                  0 1 0 0  dt 0     0   dt^2/2    0   zeros(1,6);
                  0 0 1 0  0  dt    0      0   dt^2/2 zeros(1,6);
                  0 0 0 1  0  0     dt     0      0   zeros(1,6);
                  0 0 0 0  1  0     0      dt     0   zeros(1,6);
                  0 0 0 0  0  1     0      0      dt  zeros(1,6);
                  0 0 0 0  0  0     1      0      0   zeros(1,6);
                  0 0 0 0  0  0     0      1      0   zeros(1,6);
                  0 0 0 0  0  0     0      0      1   zeros(1,6);
                  zeros(1,9)                          1 0 0 1 tan(hf_theta)*sin(hf_phi) tan(hf_theta)*cos(hf_phi);
                  zeros(1,9)                          0 1 0 0       cos(hf_phi)                -sin(hf_phi); 
                  zeros(1,9)                          0 0 1 0 sin(hf_phi)*sec(hf_theta) cos(hf_phi)/sin(hf_theta);
                  zeros(1,9)                          0 0 0 1            0                          0;
                  zeros(1,9)                          0 0 0 0            1                          0;
                  zeros(1,9)                          0 0 0 0            0                          1];

            C1 = [1 0 0 0 0 0 0 0 0 0 0 0 zeros(1,3);
                  0 1 0 0 0 0 0 0 0 0 0 0 zeros(1,3);
                  0 0 1 0 0 0 0 0 0 0 0 0 zeros(1,3);
                  0 0 0 0 0 0 0 0 0 1 0 0 zeros(1,3);
                  0 0 0 0 0 0 0 0 0 0 1 0 zeros(1,3);
                  0 0 0 0 0 0 0 0 0 0 0 1 zeros(1,3)];
            
            % predicting
            hf_x_est(:,k) = A1*hf_x_up(:,k); % predict step
            hf_x_est_save = [hf_x_est_save, hf_x_est(:,k)];
            hf_P = A1*hf_P_up*A1'; % predict covariance
            hf_P_save{k} = hf_P;

            % updating
            y = [hf_poses(k,4:6), hf_phi, hf_theta, hf_psi]' - C1*hf_x_est(:,k); % innovation
            S = C1*hf_P*C1' + hf_Rw; % innovation covariance
            K = hf_P*C1'*S^(-1); % Kalmnan gain
            hf_x_up(:,k+1) = hf_x_est(:,k) + K*y; % update state
            hf_x_up_save = [hf_x_up_save, hf_x_up(:,k+1)];
            hf_P_up = (I1 - K*C1)*hf_P; % update covariance
            hf_P_up_save{k+1} = hf_P_up;
        end
    
    else
        % Low and High Frequency Kalman Filter
        for j = 1:size(lhf_poses);
            j
            % high rate angles
            hf_theta = norm(corr_hf_poses(j,4:6));
            if hf_theta == 0
                R1 = eye(3);
            else
                R1 = vrrotvec2mat([corr_hf_poses(j,4:6)./hf_theta, hf_theta]);
            end
            eul = R2E(R1);
            hf_phi = eul(1);
            hf_phiVec = [hf_phiVec, hf_phi];
            hf_theta = eul(2);
            hf_thetaVec = [hf_thetaVec,hf_theta];
            hf_psi = eul(3);
            hf_psiVec = [hf_psiVec, hf_psi];
            
            % low rate angles
            lhf_theta = norm(lhf_poses(j,4:6));
            if lhf_theta == 0
                R2 = eye(3);
            else
                R2 = vrrotvec2mat([lhf_poses(j,4:6)./lhf_theta, lhf_theta]);
            end
            eul = R2E(R2);
            lhf_phi = eul(1);
            lhf_phiVec = [lhf_phiVec, lhf_phi];
            lhf_theta = eul(2);
            lhf_thetaVec = [lhf_thetaVec, lhf_theta];
            lhf_psi = eul(3);
            lhf_psiVec = [lhf_psiVec, lhf_psi];

            A2 = [1 0 0 dt 0  0  dt^2/2    0      0   zeros(1,12);
                  0 1 0 0  dt 0     0   dt^2/2    0   zeros(1,12);
                  0 0 1 0  0  dt    0      0   dt^2/2 zeros(1,12);
                  0 0 0 1  0  0     dt     0      0   zeros(1,12);
                  0 0 0 0  1  0     0      dt     0   zeros(1,12);
                  0 0 0 0  0  1     0      0      dt  zeros(1,12);
                  0 0 0 0  0  0     1      0      0   zeros(1,12);
                  0 0 0 0  0  0     0      1      0   zeros(1,12);
                  0 0 0 0  0  0     0      0      1   zeros(1,12);
                  zeros(1,9)                          1 0 0 1 tan(hf_theta)*sin(hf_phi) tan(hf_theta)*cos(hf_phi) zeros(1,6);
                  zeros(1,9)                          0 1 0 0        cos(hf_phi)            -sin(hf_phi)          zeros(1,6);
                  zeros(1,9)                          0 0 1 0 sin(hf_phi)*sec(hf_theta) cos(hf_phi)/sin(hf_theta) zeros(1,6);
                  zeros(1,9)                          0 0 0 1            0                       0                zeros(1,6);
                  zeros(1,9)                          0 0 0 0            1                       0                zeros(1,6); 
                  zeros(1,9)                          0 0 0 0            0                       1                zeros(1,6);
                  zeros(1,15)                                                                                     1 0 0 0 0 0;
                  zeros(1,15)                                                                                     0 1 0 0 0 0;
                  zeros(1,15)                                                                                     0 0 1 0 0 0;
                  zeros(1,15)                                                                                     0 0 0 1 0 0;
                  zeros(1,15)                                                                                     0 0 0 0 1 0;
                  zeros(1,15)                                                                                     0 0 0 0 0 1];
  
            C2 = [1 0 0 0 0 0 0 0 0 0 0 0 zeros(1,9);
                  0 1 0 0 0 0 0 0 0 0 0 0 zeros(1,9);
                  0 0 1 0 0 0 0 0 0 0 0 0 zeros(1,9);
                  0 0 0 0 0 0 0 0 0 1 0 0 zeros(1,9);
                  0 0 0 0 0 0 0 0 0 0 1 0 zeros(1,9);
                  0 0 0 0 0 0 0 0 0 0 0 1 zeros(1,9);
                  zeros(1,15)             1 0 0 0 0 0;
                  zeros(1,15)             0 1 0 0 0 0;
                  zeros(1,15)             0 0 1 0 0 0;
                  zeros(1,15)             0 0 0 1 0 0;
                  zeros(1,15)             0 0 0 0 1 0;
                  zeros(1,15)             0 0 0 0 0 1];
            
            % predicting
            lhf_x_est(:,j) = A2*lhf_x_up(:,j); % predict step
            lhf_x_est_save = [lhf_x_est_save, lhf_x_est(:,j)];
            lhf_P = A2*lhf_P_up*A2'; % predict covariance
            lhf_P_save{j} = lhf_P;

            % updating
            y = [corr_hf_poses(j,5:7), hf_phi, hf_theta, hf_psi, lhf_poses(j,4:6), lhf_phi, lhf_theta, lhf_psi]' - C2*lhf_x_est(:,j); % innovation
            S = C2*lhf_P*C2' + lhf_Rw; % innovation covariance
            K = lhf_P*C2'*S^(-1); % Kalmnan gain
            lhf_x_up(:,j+1) = lhf_x_est(:,j) + K*y; % update state
            lhf_x_up_save = [lhf_x_up_save, lhf_x_up(:,j+1)];
            lhf_P_up = (I2 - K*C2)*lhf_P; % update covariance
            lhf_P_up_save{j+1} = lhf_P_up;
        end
        
    end
 end

 
figure(1)
hold on
p1 = plot(timeVec,hf_poses(:,4))
p2 = plot(timeVec,hf_x_up_save(1,:))
xlabel('Time (ms)','FontSize',20,'FontWeight','bold')
ylabel('Position (mm)','FontSize',20,'FontWeight','bold')
title('X-Position Over Time','FontSize',20,'FontWeight','bold')
set(gca,'FontSize',20)
set(p1,'LineWidth',2)
set(p2,'LineWidth',2)
%legend('Raw Position Data','Kalman Filtered Position Data')
hold off

figure(2)
hold on
p3 = plot(timeVec,hf_poses(:,5))
p4 = plot(timeVec,hf_x_up_save(2,:))
xlabel('Time (ms)','FontSize',20,'FontWeight','bold')
ylabel('Position (mm)','FontSize',20,'FontWeight','bold')
title('Y-Position Over Time','FontSize',20,'FontWeight','bold')
set(gca,'FontSize',20)
set(p3,'LineWidth',2)
set(p4,'LineWidth',2)
%legend('Raw Position Data','Kalman Filtered Position Data')
hold off

figure(3)
hold on
p5 = plot(timeVec,hf_poses(:,6))
p6 = plot(timeVec,hf_x_up_save(3,:))
xlabel('Time (ms)','FontSize',20,'FontWeight','bold')
ylabel('Position (mm)','FontSize',20,'FontWeight','bold')
title('Z-Position Over Time','FontSize',20,'FontWeight','bold')
set(gca,'FontSize',20)
set(p5,'LineWidth',2)
set(p6,'LineWidth',2)
%legend('Raw Position Data','Kalman Filtered Position Data')
hold off

figure(4)
hold on
p7 = plot(timeVec,hf_phiVec)
p8 = plot(timeVec,hf_x_up_save(10,:))
xlabel('Time (ms)','FontSize',20,'FontWeight','bold')
ylabel('Position (rad)','FontSize',20,'FontWeight','bold')
title('\Phi-Position Over Time','FontSize',20,'FontWeight','bold')
set(gca,'FontSize',20)
set(p7,'LineWidth',2)
set(p8,'LineWidth',2)
%legend('Raw Position Data','Kalman Filtered Position Data')
hold off

figure(5)
hold on
p9 = plot(timeVec,hf_thetaVec)
p10 = plot(timeVec,hf_x_up_save(11,:))
xlabel('Time (ms)','FontSize',20,'FontWeight','bold')
ylabel('Position (rad)','FontSize',20,'FontWeight','bold')
title('\Theta-Position Over Time','FontSize',20,'FontWeight','bold')
set(gca,'FontSize',20)
set(p9,'LineWidth',2)
set(p10,'LineWidth',2)
%legend('Raw Position Data','Kalman Filtered Position Data')
hold off

figure(6)
hold on
p11 = plot(timeVec,hf_psiVec)
p12 = plot(timeVec,hf_x_up_save(12,:))
xlabel('Time (ms)','FontSize',20,'FontWeight','bold')
ylabel('Position (rad)','FontSize',20,'FontWeight','bold')
title('\Psi-Position Over Time','FontSize',20,'FontWeight','bold')
set(gca,'FontSize',20)
set(p11,'LineWidth',2)
set(p12,'LineWidth',2)
%legend('Raw Position Data','Kalman Filtered Position Data')
hold off

%{
figure(7)
plot3(poses1(:,4),poses1(:,5),poses1(:,6))
hold on
% plot3(x_up(1,:),x_up(2,:),x_up(3,:))
xlabel('X-position')
ylabel('Y-position')
zlabel('Z-position')
%title('Raw Measured Position and Filtered Positions')
%legend('Raw Position Data','Kalman Filtered Position Data')
hold off
 %}
 