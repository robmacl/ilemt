function [R] = axisangle2rot(axis)
% converts axis angle notation into rotation matrix

theta = norm(axis);

if theta < 10e-10
    R = eye(3);
else
vector = axis(1:3)./theta;

R = [     (1-cos(theta))*vector(1)*vector(1)+cos(theta)      (1-cos(theta))*vector(1)*vector(2)-vector(3)*sin(theta) (1-cos(theta))*vector(1)*vector(3)+vector(2)*sin(theta);
     (1-cos(theta))*vector(1)*vector(3)+vector(2)*sin(theta)       (1-cos(theta))*vector(2)*vector(2)+cos(theta)     (1-cos(theta))*vector(2)*vector(3)-vector(1)*sin(theta);
     (1-cos(theta))*vector(1)*vector(3)-vector(2)*sin(theta) (1-cos(theta))*vector(2)*vector(3)+vector(1)*sin(theta)      (1-cos(theta))*vector(2)*vector(2)+cos(theta)];
end


end
