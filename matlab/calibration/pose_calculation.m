% pose optimization solving non linear leat-square problem
function [poses, resnorms] = pose_calculation(data, state0)
    pose0 = [0.22,0,0,0,0,0];
    %set of pose bounds
    bound_x_tr = repmat([0;0.4], 1, 1); %x traslation bound
    %y and z traslation bounds
    bounds_tr = repmat([-0.4;0.4], 1, 2); 
    %rotation bounds
    bounds_rot = repmat([-3*pi;3*pi], 1, 3); 
    bounds = [bound_x_tr, bounds_tr, bounds_rot];
    
    
    counter = 0;
    opt_poses = [];
    resnorms = [];
    residuals = [];
    exitflags = [];
   
    %set options for the pose optimization
    option = optimset('Display','off', 'TolFun',1e-09, 'MaxIter', 1000, 'MaxFunEvals', 60000);
    
    n=size(data,1);
     
    for i = 1:n
        Cdes = reshape(data(i,7:15),3,3); %high rate couplings
        %Cdes = reshape(data(i,16:24),3,3); %low rate couplings
        [pose_new,resnorm,residual,exitflag] = lsqnonlin(@(pose)coupling_error(state0, pose, Cdes),pose0,bounds(1,:),bounds(2,:),option);  %1 and 2 row of bounds are respectively lower anad upper bounds
        format long
        %pose0 = pose_new;
        opt_poses = [opt_poses; pose_new];
        resnorms = [resnorms; resnorm];
        residuals = [residuals; residual];
        exitflags = [exitflags; exitflag];
        
        
        if exitflag <= 0
            counter = counter + 1;
        end
    end
    %caconical rotation vectors
    [poses] = canonical_rot_vec(opt_poses);
   
    %print th enumber of optimization failure
    if (counter > 0)
        fprintf(1, 'Optimization failed %d times.\n', counter);
    end
    plot(resnorms);
    title('Optimization norm of residual');
    
end