% Apply calibration to some raw data, returning calibrated xyz
% data.  The result is a 3D array, with each row:
%  [X Y Z match_err]
%
% where match error is the distance beween the two rays at closest
% approach (i.e. the Z mismatch.)
%
% The third dimension is the light number.
%
% base and dir are the base and direction vector for the rays:
%   [X Y Z 1]
%   [X Y Z 0]
%
% The dir array is indexed (point, xyz, light, sensor).
% The base array is indexed (xyz, sensor), since it doesn't depend
% vary across points or lights.

function [res, base, dir] = apply_calibration(T, K, measured)
res = zeros(size(measured, 1), 4, size(measured, 3));
dir = zeros(size(measured, 1), 4, size(measured, 3), 2);

for light_ix = 1:size(measured, 3)
  for row = 1:size(measured, 1)
    [base1, dir1] = get_ray(T, K, 1, measured(row, 1:2, light_ix));
    [base2, dir2] = get_ray(T, K, 2, measured(row, 3:4, light_ix));
    dir(row, :, light_ix, 1) = dir1;
    dir(row, :, light_ix, 2) = dir2;
    res(row, :, light_ix) = ...
    	find_intersection(base1, dir1, base2, dir2);
  end
  base = [base1; base2];
end
