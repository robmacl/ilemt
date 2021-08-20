function [ pose ] = trans2pose( T )
% Convert homogeneous transform matrix to a pose [X Y Z Rx Ry Rz]. XYZ in
% meters, RxRyRz is a rotation vector in radians, not Euler angles.

    pose(1:3) = T(1:3,4); 

    [theta,v] = tr2angvec(T);
    pose(4:6) = theta*v;

    %{    
    % This is an alternate way of doing this mentioned in the comment for
    % tr2angvec.  Maybe 40x slower, but seems to get the right result.
    % ### doesn't work in some cases, like fliplr(diag([-1 -1 -1]))
    pose(4:6) = vex(logm(T(1:3,1:3)));
    %}
end
