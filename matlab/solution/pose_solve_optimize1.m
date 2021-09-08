function [pose_new, resnorm, exitflag] = ... 
    pose_solve_optimize1 (coupling, calibration, hemi, pose0)
% subfunction of pose_solve_optimize for one point, establish bounds and
% run optimization.

% Pose state limits:
max_trans = 0.4;

%set options for the pose optimization
option = optimset('Display', 'off', 'TolFun', 1e-09, ...
                  'MaxIter', 1000, 'MaxFunEvals', 60000);

% Default translation bounds
bounds_tr = repmat([-max_trans; max_trans], 1, 3); 

% 1, 2, 3 for XYZ, negative if the minus hemisphere
bound1 = [0; max_trans];
if (hemi < 0)
  bound1 = -flipud(bound1);
  hemi = -hemi;
end
bounds_tr(:, hemi) = bound1;
% rotation bounds.  We allow the rotation to go outside of the nominal
% +/- pi range because the optimizer may want to converge to a
% non-canonical angle.
bounds_rot = repmat([-6*pi; 6*pi], 1, 3);

% If initial pose is not in the selected hemisphere, flip it.
if (~(pose0(hemi) >= bounds_tr(1, hemi) && pose0(hemi) <= bounds_tr(2, hemi)))
  pose0(1:3) = -pose0(1:3);
end

bounds = [bounds_tr, bounds_rot];
Cdes = real_coupling(coupling);

%1 and 2 row of bounds are respectively lower and upper bounds
[pose_new, resnorm, ~, exitflag] = ...
    lsqnonlin(@(pose) coupling_error(calibration, pose, Cdes), ...
              pose0, bounds(1,:), bounds(2,:), option);
