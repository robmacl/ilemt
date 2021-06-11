function [poses, resnorms] = pose_solve_kim18 (couplings, calibration, options)
% Pose solution by kim18 closed form method.

npoints = size(couplings, 3);
poses = zeros(npoints, 6);

for (ix = 1:npoints)
  poses(ix, :) = trans2pose(kim18(couplings(:, :, ix), calibration));
end

% ### compute from coupling and forward kinematics
resnorms = zeros(npoints, 1);
