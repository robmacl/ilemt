function [delta] = pose_difference (measured, desired)
% Return the pose vector representing the difference between two other pose
% vectors.  The result is much the same as subtraction, but handles angle
% wapping correctly.  The arguments may have multiple rows (data points).

delta = zeros(size(measured));
for (ix = 1:size(measured, 1))
  so_measured1 = pose2trans(measured(ix, :));
  so_desired1 = pose2trans(desired(ix, :));
  delta(ix, :) = trans2pose(inv(so_desired1) * so_measured1);
end
