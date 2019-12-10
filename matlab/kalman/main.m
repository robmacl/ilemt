% % no rotation, distance of 200 mm
%  poseTrial = [0,0,0,0.2,0,0]; % provides xx matrix
% % poseTrial = [0,0,pi/2,0.2,0,0]; % provides xy matrix
% % poseTrial = [0,pi/2,0,0.2,0,0]; % provides xz matrix
% % poseTrial = [0,0,0,0.20,0.089,0]; % test values
% 
% % Slight inaccuracies as sensor moves closer to source.
% % Values become highly inaccurate when the source and sensor are less
% % than the 152 mark.
% 
% pose0 = [0.01,0.2,pi/4-0.02,0.9,0.9,1.05];
% pose0 = [1,1,1,1,1,1];
% Cdes = fk2(poseTrial);
% 
% % options = optimoptions(@lsqnonlin,'FunctionTolerance',1e-10);
% % poseNew = lsqnonlin(@(pose)CError(Cdes,pose),pose0,options);
% 
% lb = [-inf,-inf,-inf,0,-inf,-inf];
% ub = [inf,inf,inf,inf,inf,inf];
% poseNew = lsqnonlin(@(pose)CError(Cdes,pose),pose0,lb,ub)
% Cnew = fk2(poseNew);
% %Cnew_corr = Cnew'./250; % 250 is a correction factor to have MATLAB coupling matrix match labVIEW matrix

% mean(abs(diag(Cnew))) might be a missing factor

%%

dataNHM = dlmread('base noise value - no hand motion.txt'); % No hand motion
dataHMS = dlmread('base noise value - hand motion steady.txt'); % Hand motion steady
dataNHM = dlmread('test250416.txt'); % Hand motion moving


dt = 250;

dataNHMs = dataNHM(1:dt:end,:);
dataHMSs = dataHMS(1:dt:end,:);
% dataHMMs = dataHMM(1:dt:end,:);



xVec = zeros(size(dataNHMs,1),1);
yVec = zeros(size(dataNHMs,1),1);
zVec = zeros(size(dataNHMs,1),1);

xVec = [];
yVec = [];
zVec = [];
pose0 = [0.5,0.5,1,0.5,0.5,0.5];
pose0 = [0,0,0,0.3,0,0];

lb = [-inf,-inf,-inf,0,-inf,-inf];
ub = [inf,inf,inf,inf,inf,inf];

poses = [];

for i = 1:size(dataNHMs,1)
    i
    Cdes = reshape(dataNHMs(i,2:end),3,3);
    poseN = lsqnonlin(@(pose)CError(Cdes,pose),pose0,lb,ub);
    format long
    pose0 = poseN;
    poses = [poses; pose0];
    xVec(i) = poseN(4);
    yVec(i) = poseN(5);
    zVec(i) = poseN(6)*(-1);
end

curve = animatedline('LineWidth',2);
view(35,12)
hold on
for i = 1:length(dataNHMs)
    addpoints(curve,xVec(i),yVec(i),zVec(i));
    head = scatter3(xVec(i),yVec(i),zVec(i),'r','filled');
    drawnow
    pause(0.05);
    delete(head)
    xlabel('X','FontSize',18);
    ylabel('Y','FontSize',18);
    zlabel('Z','FontSize',18);
    axis equal
end

figure(2)
scatter3(xVec,yVec,zVec,'r','filled');
xlabel('X-position') %,'FontSize',20);
ylabel('Y-position') %,'FontSize',20);
zlabel('Z-position') %,'FontSize',20);
axis equal





%%
poseTrial = [0,0,0,0.2,0,0.2]
pose0 = [0.5,0.5,1,0.5,0.5,0.5];
pose0 = [0,0,0,0.3,0,0];

Cdes = fk3(poseTrial)

lb = [-pi,-pi,-pi,0,-inf,0];
ub = [pi,pi,pi,inf,inf,inf];

poseNew = lsqnonlin(@(pose)CError(Cdes,pose),pose0,lb,ub)

       

















