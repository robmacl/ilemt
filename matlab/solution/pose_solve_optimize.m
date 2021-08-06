function [poses, resnorms] = pose_solve_optimize (couplings, calibration, hemisphere)
% Pose solution by nonlinear optimization.

% Pose state limits:
max_trans = 0.4;

% parfor output struct array, results of each point solution
clear results;

%set options for the pose optimization
option = optimset('Display', 'off', 'TolFun', 1e-09, ...
                  'MaxIter', 1000, 'MaxFunEvals', 60000);
%parfor
parfor (ix = 1:size(couplings, 3))
  % Default translation bounds
  bounds_tr = repmat([-max_trans; max_trans], 1, 3); 

  % 1, 2, 3 for XYZ, negative if the minus hemisphere
  bound1 = [0; max_trans];
  hemi = hemisphere(ix);
  if (hemi < 0)
    bound1 = -flipud(bound1);
    hemi = -hemi;
  end
  bounds_tr(:, hemi) = bound1;

  % Starting pose.  We use the fixture poses to construct the sensor pose
  % at the stage null pose.
  % ### don't have source motion
  pose0 = trans2pose(pose2trans(calibration.source_fixture) ... 
                     * pose2trans(calibration.stage_fixture) ...
                     * pose2trans(calibration.sensor_fixture));

  if (~(pose0(hemi) >= bounds_tr(1, hemi) && pose0(hemi) <= bounds_tr(2, hemi)))
    % If initial pose is not in the selected hemisphere, flip it.
    pose0(1:3) = -pose0(1:3);
  end

  % rotation bounds.  We allow the rotation to go outside of the nominal
  % +/- pi range because the optimizer may want to converge to a
  % non-canonical angle.
  bounds_rot = repmat([-6*pi; 6*pi], 1, 3);

  bounds = [bounds_tr, bounds_rot];
  Cdes = real_coupling(couplings(:, :, ix));
  %1 and 2 row of bounds are respectively lower and upper bounds
  [pose_new, resnorm, ~, exitflag] = ...
      lsqnonlin(@(pose) coupling_error(calibration, pose, Cdes), ...
                pose0, bounds(1,:), bounds(2,:), option);
  % use last pose as initial value?  Doesn't work well with calibration
  % data points, which jump around.
  %pose0 = pose_new;
  results(ix) = ...
      struct('pose', pose_new, 'resnorm', resnorm, 'exitflag', exitflag);
end

% Convert to canonical rotation vectors, with magnitude ranging 0:pi.
% This insures that the same orientation always has the same rotation
% vector, and not a 2*pi multiple.
poses = canonical_rot_vec(cat(1, results.pose));

resnorms = [results.resnorm];
