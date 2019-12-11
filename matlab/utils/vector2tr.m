function r = vector2tr(v)
% Convert a pose vector (as used by the motion stage) into a transform matrix.
% This is almost the same as the old ASAP pvec2tr(), but in ILEMT we represent
% the pose translation as m, not mm.  So convert mm to m.
  angles = v(4:6)/180*pi;
  r = rotz(angles(3)) * roty(angles(2)) * rotx(angles(1));
  r(1:3, 4) = v(1:3)./1E3;
  r(4,:) = [0, 0, 0, 1];
end
