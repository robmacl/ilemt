function [poses, resnorms] = pose_calculation(data)
% pose optimization solving non linear leat-square problem

    %high rate state
    %load('subset_hr_cal')
    load('onlydipole_XYZrot_hr_cal');
    state0 = calibration2state(hr_cal, hr_so_fix, hr_se_fix);
    
    %low rate state
    %load('q_pole_lr_cal');
    %state0 = calibration2state(lr_cal, lr_so_fix, lr_se_fix);
    
    pose0 = [0.22,0,0,0,0,0];
    %pose0 = [0.18, 0.07, -0.07, 0.7, -1.7, -1.8];
    bounds_tr = repmat([-0.4;0.4], 1, 3);
    bounds_rot = repmat([-3*pi;3*pi], 1, 3);
    bounds = [bounds_tr, bounds_rot];
    %bounds = repmat([-Inf; Inf], 1, 6);
    
    
    counter = 0;
    poses = [];
    resnorms = [];
    residuals = [];
    exitflags = [];
   
    
    option = optimset('Display','off', 'TolFun',1e-06, 'MaxIter', 1000, 'MaxFunEvals', 60000);
    
    n=size(data,1);
     
    for i = 1:n
        Cdes = reshape(data(i,7:15),3,3); %high rate couplings
        %Cdes = reshape(data(i,16:24),3,3); %low rate couplings
        [pose_new,resnorm,residual,exitflag] = lsqnonlin(@(pose)coupling_error(state0, pose, Cdes),pose0,bounds(1,:),bounds(2,:),option);  %1 and 2 row of bounds are respectively lower anad upper bounds
        format long
        %pose0 = pose_new;
        poses = [poses; pose_new];
        %norm_res = resnorm/norm(Cdes);
        resnorms = [resnorms; resnorm];
        residuals = [residuals; residual];
        exitflags = [exitflags; exitflag];
        
        
        if exitflag <= 0
            counter = counter + 1;
        end
    end
   
    if (counter > 0)
        fprintf(1, 'Optimization failed %d times.\n', counter);
    end
    plot(resnorms);
    title('Optimization norm of residual');
    
end