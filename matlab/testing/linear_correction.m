function [calibration] = linear_correction(perr, cp_options, cal_options, calibration)
% Find a linear transform that minimizes the pose error.  
% 
% This is actually used back in ../calibration/output_correction.m, but kind
% of makes sense being here due to knowledge about the perr struct.
mode = cal_options.correct_mode;

% Must be in source coordinates
assert(~cp_options.stage_coords);

% The linear correction is a matrix which is multiplied by the (column vector)
% pose to improve the accuracy.  If 6x6, then it is applied to the entire
% pose, with no normalization.  If 4x4, it is applied to [x y z 1]',
% and then normalized by the transformed pad element.  With 4x4 there is no
% effect on rotation, or rotation<->translation coupling.
% See calibration/pose_calculation.m

% We have several correction modes, but 'DLT' is currently the best.
if (strcmp(mode, 'none'))
  transform = eye(4);
elseif (strcmp(mode, 'skew'))
  % Despite the name, the skew terms transform(4, 1:3) are effectively zero.
  % The translation terms transform(1:3, 4) are nonzero, but don't have any
  % meaninful effect on the relative accuracy (since we assume an arbitrary
  % source fixture).  Even so, allowing the mean position error to go into the
  % translations seems to result in a better 3x3 rotation/scaling.  Note that
  % the 3x3 is non-orthogonal, which is a big part of its effect.
  pd1 = pinv(pad_ones(perr.measured(:, 1:3)));
  tf1 = pd1 * pad_ones(perr.desired(:, 1:3));
  transform = tf1';
elseif (strcmp(mode, 'DLT'))
  % General linear projection using Direct Linear Transformation method.
  % This has nonzero transform(4, 1:3), which gives skew/trapezoid
  % effects.  There can be numeric problems with this method, but I don't
  % think they apply for us because the calibration data is reasonably
  % centered, and the scale is almost exactly 1.
  % See utils/dlt.m
  transform = dlt(pad_ones(perr.measured(:, 1:3))', pad_ones(perr.desired(:, 1:3))');
elseif (strcmp(mode, 'pose'))
  pd = pinv(perr.measured);
  transform = (pd * perr.desired)';
else
  error('Unknown correct_mode: %s', mode);
end

calibration.linear_correction = transform;
