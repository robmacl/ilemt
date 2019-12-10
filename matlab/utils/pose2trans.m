function [ T ] = pose2trans( pose )
% Turn pose into a homogeneous tranform matrix

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

