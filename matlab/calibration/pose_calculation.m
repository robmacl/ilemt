function [poses, resnorms] = pose_calculation(data, state0)
% pose optimization solving non linear leat-square problem
    pose0 = [0.22,0,0,0,0,0];
    bound_x_tr = repmat([0;0.4], 1, 1);
    bounds_tr = repmat([-0.4;0.4], 1, 2);
    bounds_rot = repmat([-3*pi;3*pi], 1, 3);
    bounds = [bound_x_tr, bounds_tr, bounds_rot];
    %bounds = repmat([-Inf; Inf], 1, 6);
    
    
    counter = 0;
    opt_poses = [];
    resnorms = [];
    residuals = [];
    exitflags = [];
   
    
    option = optimset('Display','off', 'TolFun',1e-09, 'MaxIter', 1000, 'MaxFunEvals', 60000);
    
    n=size(data,1);
     
    for i = 1:n
        Cdes = reshape(data(i,7:15),3,3); %high rate couplings
        %Cdes = reshape(data(i,16:24),3,3); %low rate couplings
        [pose_new,resnorm,residual,exitflag] = lsqnonlin(@(pose)coupling_error(state0, pose, Cdes),pose0,bounds(1,:),bounds(2,:),option);  %1 and 2 row of bounds are respectively lower anad upper bounds
        format long
        %pose0 = pose_new;
        opt_poses = [opt_poses; pose_new];
        %norm_res = resnorm/norm(Cdes);
        resnorms = [resnorms; resnorm];
        residuals = [residuals; residual];
        exitflags = [exitflags; exitflag];
        
        
        if exitflag <= 0
            counter = counter + 1;
        end
    end
    [poses] = canonical_rot_vec(opt_poses);
   
    if (counter > 0)
        fprintf(1, 'Optimization failed %d times.\n', counter);
    end
    plot(resnorms);
    title('Optimization norm of residual');
    
end