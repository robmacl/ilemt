function r = vector2tr(v)
% Convert a pose vector (as used by the motion stage) into a transform matrix.
% This is almost the same as the old ASAP pvec2tr(), but in ILEMT we represent
% the pose translation as m, not mm.  So convert mm to m.
%
% The rotation is rotz(Rz) * roty(Ry) * rotx(Rx), angles in degrees.
%
% v may also be an N x 6 array of pose vectors, in which case r is 4x4xN.
  n = size(v, 1);
  a = v(:, 4:6) / 180 * pi;
  cx = reshape(cos(a(:, 1)), 1, 1, n);
  sx = reshape(sin(a(:, 1)), 1, 1, n);
  cy = reshape(cos(a(:, 2)), 1, 1, n);
  sy = reshape(sin(a(:, 2)), 1, 1, n);
  cz = reshape(cos(a(:, 3)), 1, 1, n);
  sz = reshape(sin(a(:, 3)), 1, 1, n);
  r = zeros(4, 4, n);
  r(1, 1, :) = cz .* cy;
  r(1, 2, :) = cz .* sy .* sx - sz .* cx;
  r(1, 3, :) = cz .* sy .* cx + sz .* sx;
  r(2, 1, :) = sz .* cy;
  r(2, 2, :) = sz .* sy .* sx + cz .* cx;
  r(2, 3, :) = sz .* sy .* cx - cz .* sx;
  r(3, 1, :) = -sy;
  r(3, 2, :) = cy .* sx;
  r(3, 3, :) = cy .* cx;
  r(1:3, 4, :) = reshape(v(:, 1:3)' ./ 1E3, 3, 1, n);
  r(4, 4, :) = 1;
end
