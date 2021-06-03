% pose optimization solving non linear least-square problem
% Point is "invalid" if residual is bigger than valid_threshold.
function [poses, valid, resnorms, exitflags] = ...
      pose_calculation(couplings, calibration, options)

  % Starting pose.  We use the fixture poses to construct the sensor pose
  % at the stage null pose.
  pose0 = trans2pose(pose2trans(calibration.source_fixture) ... 
                     * pose2trans(calibration.sensor_fixture));

  % Pose state limits:
  % The pose is constrained to the +X hemisphere.
  bound_positive = [0; 0.4];
  
  % y and z translation bounds
  bounds_tr = repmat([-0.4;0.4], 1, 3); 
  
  bounds_tr(:, 1) = bound_positive;
  %bounds_tr(:, 2) = bound_positive;
  
  % rotation bounds.  We allow the rotation to go outside of the nominal
  % +/- pi range because the optimizer may want to converge to a
  % non-canonical angle.
  bounds_rot = repmat([-6*pi; 6*pi], 1, 3);

  bounds = [bounds_tr, bounds_rot];
  
  clear results;
  
  %set options for the pose optimization
  option = optimset('Display', 'off', 'TolFun', 1e-09, ...
                    'MaxIter', 1000, 'MaxFunEvals', 60000);
  parfor (ix = 1:size(couplings, 3))
    Cdes = real_coupling(couplings(:, :, ix));
    %1 and 2 row of bounds are respectively lower and upper bounds
    [pose_new, resnorm, ~, exitflag] = ...
        lsqnonlin(@(pose) coupling_error(calibration, pose, Cdes, options), ...
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
  valid = resnorms <= options.valid_threshold;
  if (sum(~valid) > 0)
    fprintf(1, '%d invalid points with residual > %g.\n', ...
            sum(~valid), options.valid_threshold);
    bad_points = find(~valid)
  end

  if (options.linear_correction && isfield(calibration, 'linear_correction'))
    transform = calibration.linear_correction;
    if (size(transform, 1) == 4)
      % Linear only, with skew terms.  This is a linear homogenous transform matrix,
      % although transform(:, 4) is effectively zero.  But nonzero
      % transform(4, 1:3) allow for trapezoid effects.
      corr = pad_ones(poses(:, 1:3)) * transform;
      poses(:, 1:3) = corr(:, 1:3);
    else
      poses = poses * transform;
    end
  end
end
