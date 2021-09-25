function [calibration] = linear_correction(perr, cp_options, cal_options, calibration)
% Find a linear transform that minimizes the pose error.  
% 
% This is actually used back in ../calibration/output_correction.m, but kind
% of makes sense being here due to knowledge about the perr struct.

% Check how many valid points we have.  If there are any significant number of
% bad points then either something is wrong, or we are pressing on with a
% terrible calibration.  So the arbitrary 75% threshold shouldn't be a
% problem.  This is mainly to keep us from crashing or generating a completely
% silly result.  It is possible that there are no valid points at all.
npoints = size(perr.measured_source, 1);
all_points = length(perr.all_solution_residuals);
if (npoints / all_points < 0.75)
  fprintf(1, 'linear_correction: too few valid points, skipping: %d/%d\n', ...
          npoints, all_points);
  return;
end

% Must be in source coordinates
assert(~cp_options.stage_coords);

% If we have options.reoptimize_fixtures set then these will be different.
calibration.source_fixture = perr.so_fix;
calibration.stage_fixture = perr.st_fix;
calibration.sensor_fixture = perr.se_fix;

% The linear correction is a matrix which is multiplied by the (column vector)
% XYZ pose to improve the accuracy.  It is applied to [x y z 1]', and then
% normalized by the transformed pad element.  There is no effect on rotation,
% or rotation<->translation coupling.  See calibration/pose_calculation.m

% Pad with ones.
meas_pad = pad_ones(perr.measured(:, 1:3))';
des_pad = pad_ones(perr.desired(:, 1:3))';

function [err_rms, errors] = transform_error (tf)
  corr = tf * meas_pad;
  % Normalize by corr(4, ix) to implement the general linear projection
  for (ix = 1:size(corr, 2))
    corr(1:3, ix) = corr(1:3, ix) / corr(4, ix);
  end
  errors = corr(1:3, :) - des_pad(1:3, :);
  err_rms = sqrt(sum(sum(errors.^2)) / size(corr, 2));
end

function [errors] = objective (state)
  [~, errors] = transform_error(reshape(state, 4, 4));
end


% 'pinv' method: using pinv(), the skew terms transform(4, 1:3) are
% effectively zero.  The translation terms transform(1:3, 4) are nonzero, but
% don't have any meaninful effect on the relative accuracy (since we assume an
% arbitrary source fixture).  Even so, allowing the mean position error to go
% into the translations seems to result in a better 3x3 rotation/scaling.
% Note that the 3x3 is non-orthogonal, which is a big part of its effect.

% 'DLT' method: General linear projection using Direct Linear Transformation
% method.  This has nonzero transform(4, 1:3), which gives skew/trapezoid
% effects.  This method is known to have numeric issues, and can blow up
% pretty badly when the errors are large.  See utils/dlt.m

transforms = {
    'none', eye(4)
    'pinv', (pinv(meas_pad') * des_pad')'
    'DLT', dlt(meas_pad, des_pad)
    };

errors = cellfun(@transform_error, transforms(:, 2));

[min_err, min_ix] = min(errors);
best_tf = transforms{min_ix, 2};

mode = cal_options.correct_mode;

fprintf(1, 'linear_correction: best direct method %s, %.3e m RMS.\n', ...
        transforms{min_ix, 1}, min_err);

if (strcmp(mode, 'auto'))
  transform = best_tf;
  corrected_err = min_err;
elseif (strcmp(mode, 'optimize'))
  option = optimset('Display', 'off');
  opt_tf = lsqnonlin(@objective, reshape(best_tf, 1, []), ...
                     ones(1, 16)*-10, ones(1, 16)*10, option);
  opt_tf = reshape(opt_tf, 4, 4);
  opt_err = transform_error(opt_tf);
  if (opt_err >= min_err)
    fprintf(1, 'linear_correction: optimization did not help.\n');
    transform = best_tf;
  else
    fprintf(1, 'linear_correction: %.3e optimized to %.3e m RMS\n', ...
            min_err, opt_err);
    transform = opt_tf;
  end
  corrected_err = opt_err;
else
  found = strcmp(mode, transforms(:, 1));
  if (any(found))
    transform = transforms{found, 2};
  else
    error('Unknown correct_mode: %s', mode);
  end
  corrected_err = errors(found);
end

calibration.linear_correction = transform;

calibration.stats.uncorrected = errors(1);
calibration.stats.corrected = corrected_err;
calibration.stats.num_invalid = sum(~perr.valid_pose);
end
