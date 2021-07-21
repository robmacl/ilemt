function [poses, valid, resnorms] = pose_solution ...
  (couplings, calibration, options)
% Compute poses from coupling matrices:
% couplings(3, 3, n):
%    input coupling matrices
% 
% calibration: 
%    calibration struct to use
% 
% options:
%    may affect the solution
% 
% Results:
% poses(n, 6):
%    Result poses in rotation vector format.
% 
% valid(n):
%    True if the result pose seems to be valid (based on residual error).

  if (strcmp(options.pose_solution, 'optimize'))
    [poses, resnorms] = ...
        pose_solve_optimize(couplings, calibration, options);
  elseif (strcmp(options.pose_solution, 'kim18'))
    [poses, resnorms] = ...
        pose_solve_kim18(couplings, calibration, options);
  else
    error('Unknown pose_solution method: %s', options.pose_solution);
  end

  valid = resnorms <= options.valid_threshold;
  if (sum(~valid) > 0)
    fprintf(1, '%d invalid points with residual > %g.\n', ...
            sum(~valid), options.valid_threshold);
    bad_points = find(~valid)
  end

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
