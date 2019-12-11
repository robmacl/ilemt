function [ T ] = pose2trans( pose )
% Convert a pose [X Y Z Rx Ry Rz] into a homogeneous transform matrix. XYZ in
% meters, RxRyRz a rotation vector in radians, not Euler angles.

    tX = pose(1);
    tY = pose(2);
    tZ = pose(3);
    rX = pose(4);
    rY = pose(5);
    rZ = pose(6);
    
    mag = norm([rX,rY,rZ]);
    if mag < 10^-9
        R = eye(3);
    else
        R = angvec2r(mag, [rX,rY,rZ]./mag);
    end
    
    T = [R,[tX;tY;tZ];0,0,0,1];
    
    
    
end

