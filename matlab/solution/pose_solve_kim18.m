function [poses, resnorms] = pose_solve_kim18 (couplings, calibration, hemisphere)
% Pose solution by kim18 closed form method.

npoints = size(couplings, 3);
poses = zeros(npoints, 6);
resnorms = zeros(npoints, 1);

for (ix = 1:npoints)
  couplings1 = real_coupling(couplings(:, :, ix));
  P = kim18(couplings1, calibration, hemisphere(ix));
  poses(ix, :) = trans2pose(P);
  fk = fk_kim18(P, calibration);
  resnorms(ix) = sum(sum((fk - couplings1).^2)) / norm(couplings1);
end
