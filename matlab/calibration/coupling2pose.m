function [ poses ] = coupling2pose( data )
% generate poses from coupling matrices
global calibration;

    pose0 = [0.2,0,0,0,0,0];
    lb = [0,-inf,-inf,-inf,-inf,-inf];
    ub = [inf,inf,inf,inf,inf,inf];

    counter = 0;
    
    poses = [];
    resnorms = [];
    residuals = [];
    exitflags = [];
    
    option = optimset('Display','off');
    
     n=size(data,1);
    for i = 1:n
        if data(i,2) == 0 || data(i,2) == 2 % for data identifier 0 or 2
            cal = calibration.high_rate;
        else
            cal = calibration.low_rate;
        end
        
        Cdes = reshape(data(i,3:end),3,3);
        [pose_new,resnorm,residual,exitflag] = lsqnonlin(@(pose)CError(Cdes,pose,cal),pose0,lb,ub,option);
        format long
        pose0 = pose_new;
        poses = [poses; pose0];
        resnorms = [resnorms; resnorm];
        residuals = [residuals; residual];
        exitflags = [exitflags; exitflag];
        
        if exitflag <= 0
            counter = counter + 1;
        end
    end

    if (counter > 0)
        printf(1, 'Optimization failed %d times.\n', counter);
    end
    plot(resnorms);
    title('Optimization norm of residual');
end

