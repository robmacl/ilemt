function [poses, valid, resnorms] = pose_solution ...
  (couplings, calibration, options, hemisphere, initial)
% Compute poses from coupling matrices:
% couplings(3, 3, n):
%    input coupling matrices
% 
% calibration: 
%    calibration struct to use. 
% 
% options:
%    check_poses() options struct (or the necessary subset of that).
%    options.pose_solution Selects the solution method.  Other options.* may
%    also have effect.  The default is calibration.options.
% 
% hemisphere(n):
%   Optional, vector parallel to couplings.  What hemisphere the pose is
%   constrained to: 1, 2, 3 for XYZ, negative if the minus hemisphere.  eg. -2
%   is the -X hemisphere.  Default is to use options.hemisphere.
% 
% initial(n, 6):
%   If supplied, initial value for solution optimization, parallel to couplings.
%
% Results:
% poses(n, 6):
%    Result poses in rotation vector format.
% 
% valid(n):
%    True if the result pose seems to be valid (based on residual error).
% 
% resnorms(n):
%    The norm of the residual wrt. the coupling (sum squared of the coupling
%    mismatch).  This is normalized by norm(coupling) to make the measure a
%    relative fit measure, regardless of the coupling strength.

  if (nargin < 3 || isempty(options))
    options = calibration.options;
  end
  if (nargin < 4 || isempty(hemisphere))
    hemisphere = repmat(options.hemisphere, size(couplings, 3), 1);
  end
  if (nargin < 5)
    initial = [];
  end

  if (strcmp(options.pose_solution, 'optimize'))
    [poses, resnorms] = ...
        pose_solve_optimize(couplings, calibration, options, hemisphere, initial);
  elseif (strcmp(options.pose_solution, 'kim18'))
    [poses, resnorms] = ...
        pose_solve_kim18(couplings, calibration, hemisphere);
  elseif (strcmp(options.pose_solution, 'UKF'))
    [poses, resnorms] = ...
        pose_solve_UKF(couplings, calibration, options);
  else
    error('Unknown pose_solution method: %s', options.pose_solution);
  end
  
  valid = resnorms < options.valid_threshold;

  if (options.linear_correction && isfield(calibration, 'linear_correction'))
    % Transpose because we have row vectors.  linear_correction is in the more
    % conventional column vector format.
    transform = calibration.linear_correction';

    if (size(transform, 1) == 4)
      % Transform translation only, applied to [x y z 1] vectors.  See
      % testing/linear_correction.m
      corr = pad_ones(poses(:, 1:3)) * transform;
      
      % Normalize by corr(:, 4) to implement the general projection
      for (ix = 1:size(corr, 1))
        poses(ix, 1:3) = corr(ix, 1:3) / corr(ix, 4);
      end
    else
      % Transform the full pose vector.  This mode does not work well, because of
      % angle wrapping.
      poses = poses * transform;
    end
  end
end
