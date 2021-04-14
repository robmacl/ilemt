% pose optimization solving non linear least-square problem
function [poses, resnorms, residuals] = ...
      pose_calculation(couplings, calibration)
  pose0 = [0.22, 1e-3, 1e-3, 1e-3, 1e-3, 1e-3];

  % Pose state limits:
  % The pose is constrained to the +X hemisphere.
  bound_x_tr = [0; 0.4];
  
  % y and z translation bounds
  bounds_tr = repmat([-0.4;0.4], 1, 2); 
  
  % rotation bounds.  We allow the rotation to go outside of the nominal
  % +/- pi range because the optimizer may want to converge to a
  % non-canonical angle.
  bounds_rot = repmat([-3*pi; 3*pi], 1, 3);

  bounds = [bound_x_tr, bounds_tr, bounds_rot];
  
  counter = 0;
  opt_poses = [];
  resnorms = [];
  residuals = [];
  exitflags = [];
  
  %set options for the pose optimization
  option = optimset('Display', 'off', 'TolFun', 1e-09, ...
                    'MaxIter', 1000, 'MaxFunEvals', 60000);
  for (ix = 1:size(couplings, 3))
    Cdes = couplings(:, :, ix);
    %1 and 2 row of bounds are respectively lower and upper bounds
    [pose_new,resnorm,residual,exitflag] = ...
        lsqnonlin(@(pose) coupling_error(calibration, pose, Cdes), ...
                  pose0, bounds(1,:), bounds(2,:), option);
    % use last pose as initial value?  Doesn't work well with calibration
    % data points, which jump around.
    %pose0 = pose_new;
    opt_poses = [opt_poses; pose_new];
    resnorms = [resnorms; resnorm];
    residuals = [residuals; residual];

    if exitflag <= 0
      counter = counter + 1;
    end
  end

  % Convert to canonical rotation vectors, with magnitude ranging 0:pi.
  % This insures that the same orientation always has the same rotation
  % vector, and not a 2*pi multiple.
  poses = canonical_rot_vec(opt_poses);

  % Print the number of optimization failure
  if (counter > 0)
    fprintf(1, 'Optimization failed %d times.\n', counter);
  end
end
