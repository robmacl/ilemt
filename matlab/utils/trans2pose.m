function [ pose ] = trans2pose( T )
% Convert homogeneous transform matrix to poses
    
    pose(1:3) = T(1:3,4); 
    %{
    [theta,v] = tr2angvec(T);
    pose(4:6) = theta*v;
    %}
    
    % This is an alternate way of doing this mentioned in the comment for
    % tr2angvec.  Maybe 40x slower, but seems to get the right result.
    pose(4:6) = vex(logm(T(1:3,1:3)));
end

