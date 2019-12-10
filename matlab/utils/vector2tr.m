%this function tranform a pose vector in a transform matrix. 
%Same as pvec2tr, all distances represented in m (transform mm in m).


function r = vector2tr(v)
angles = v(4:6)/180*pi;
r = rotz(angles(3)) * roty(angles(2)) * rotx(angles(1));
r(1:3, 4) = v(1:3)./1E3;
r(4,:) = [0, 0, 0, 1];
end