function [res] = make_mesh (x, y, z, spacing)
% Make an XYZ mesh with regular point spacing, XYZ are the number of planes in
% that direction.  Total size is then (XYZ - 1) * spacing.  The volume is
% centered on the origin.  Result has one row for each point, where each
% row is [x, y, z]  If the point [0, 0, 0] is not in the result, then it is
% added.
res = zeros(0, 3);
res_ix = 1;
for (zx = 1:z)
  for (yx = 1:y)
    for (xx = 1:x)
      res(res_ix, :) = [xx yx zx];
      res_ix = res_ix + 1;
    end
  end
end

res = res .* spacing;
res = res - repmat(mean(res), res_ix-1, 1);
if (~any(all(res == 0, 2)))
  res = [res; zeros(1, 3)];
end