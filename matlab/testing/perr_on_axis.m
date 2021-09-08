function [res] = perr_on_axis (perr, options)
  % Struct array summarizing axis errors, indexed by axis.  Each axis may have a
  % different numbers of points.  Units are mm and degrees, mm/degree, etc.
  %
  %   res(ax).x(npoints): the x values for that axis.  npoints is less than the
  %     original npoints due to end effects in the S-G filter.
  %
  %   res(ax).errs(kind, npoints, deriv):
  %     "same kind" means trans->trans or rot->rot coupling, "different kind"
  %     means rot->trans or trans->rot.
  %     kind:
  %       1 on-axis error
  %       2 off-axis same-kind (exclusive of on-axis)
  %       3 different kind error magnitude
  %       4 to Rz axis
  %       5 same-kind error magnitude (both on and off axis)
  %     If deriv=1, then it is the base (INL) error, if deriv=2, then it is
  %     the DNL.  For other than on-axis, the values are the vector sums of
  %     the off-axis INL and DNL, so are non-negative.
  %
  %   res(ax).stats(kind, deriv, rms_mav):
  %     Summary of errs.  kind and deriv are as for errs. (rms_mav == 1) is RMS
  %     (rms_mav == 2) is max absolute value.
  %
  %   res(ax).on_ax_ix(orig_npoints):
  %     Indices in the perr input data for the points corresponding to this
  %     axis sweep.  This allows you to dig in the input data for this axis.
  %
  % Note that the axis sweeps are defined in the stage coordinates, so
  % options.stage_coords must be true in order to get the errors on stage
  % coordinates also.
  res = struct([]);

  stage_pos = perr.motion_poses(:, 13:18);
  % Mask for zero elements in the stage position, used to separate out the
  % different axis sweeps.
  zero_tol = 1e-4;
  zero_ax = abs(stage_pos) < zero_tol;

  if (~options.stage_coords)
    error('For sweep, options.stage_coords must be true (I think).');
  end
  
  % This is maybe kinda dubious?  Perhaps we should convert the pose vector into
  % the stage representation?  But the rotation vector (quaternion magnitude)
  % is really a better measure of angular displacement, and this should be
  % fine as long as the rotation errors are small.  Thing is, when rotation is
  % not small then the idea of "on axis" breaks down because we are not
  % actually using the same representation for the sweep position and the
  % error.
  pose_err = [perr.errors(:, 1:3)*1e3, perr.errors(:, 4:6)*(180/pi)];

  for (ax = 1:6)
    % Is there any sweep on this axis?
    if (all(zero_ax(:, ax)))
      continue;
    end
    
    zero_copy = zero_ax;
    zero_copy(:, ax) = 0;
    % on_ax_ix is the indices of poses (rows) where all of the off-axis
    % positions are zero.
    on_ax_ix = find(sum(zero_copy, 2) == 5);

    % We need to pick out the uniform step sweep part, dropping out leading
    % and trailing origin points.
    last_good = length(on_ax_ix);
    for (ix = length(on_ax_ix):-1:1)
      last_good = ix;
      if (~zero_ax(on_ax_ix(ix), ax))
	break;
      end
    end
    on_ax_ix(last_good+1:end) = [];
    first_good = 1;
    for (ix = 1:length(on_ax_ix))
      first_good = ix;
      if (~zero_ax(on_ax_ix(ix), ax))
	break;
      end
    end
    on_ax_ix(1:first_good-1) = [];
    if (~all(diff(on_ax_ix) == 1))
       error('Holes in sweep.');
    end
    %{
    lims = options.axis_limits(ax, :);
    clip = stage_pos(:, ax) < lims(1) | stage_pos(:, ax) > lims(2);
    clip = clip(on_ax_ix);
    on_ax_ix(clip) = [];
    %}

    % We treat same-kind axes (orientation or translation) differently from
    % off-axis different kind.  We line fit in the 3D same-kind subspace to
    % extract first order error.
    if (ax < 4)
       same_ax = 1:3;
       diff_ax = 4:6;
    else
      same_ax = 4:6;
      diff_ax = 1:3;
    end
    off_ax = same_ax(same_ax ~= ax);
    Rz_ax = [6];
    
    res(ax).on_ax_ix = on_ax_ix;
    x = stage_pos(on_ax_ix, ax);
    % Get on-axis error, and also the x values, which are in common across all of
    % the error kinds.
    [on_ax_err, res(ax).x] = perr_filt_onax(x, pose_err(on_ax_ix, ax), options);
    % All the error kinds
    res(ax).err = ...
      [shiftdim(on_ax_err, -1)
       shiftdim(perr_filt(x, pose_err(on_ax_ix, off_ax), options), -1)
       shiftdim(perr_filt(x, pose_err(on_ax_ix, diff_ax), options), -1)
       shiftdim(perr_filt(x, pose_err(on_ax_ix, Rz_ax), options), -1)
       shiftdim(perr_filt(x, pose_err(on_ax_ix, same_ax), options), -1)];
    for (kix = 1:5)
      for (dix = 1:2)
	res(ax).stats(kix, dix, 1) = sqrt(mean(squeeze(res(ax).err(kix, :, dix)).^2));
	res(ax).stats(kix, dix, 2) = max(abs(squeeze(res(ax).err(kix, :, dix))));
      end
    end
  end
end

function [res, x_out] = perr_filt_onax (x, y, options)
  [smooth, deriv, x_out] = ...
    sg_filt(x, y, options.sg_filt_N, options.sg_filt_F);
  res = [smooth deriv];
end

% The columns of Y are multiple axis signals.  The result is the vector sum.
% res(:, 1) is the smoothed signal, and res(:, 2) is the derivitive.
function [res, x_out] = perr_filt (x, y, options)
  [smooth, deriv, x_out] = ...
    sg_filt(x, y, options.sg_filt_N, options.sg_filt_F);
  res = [sqrt(sum(smooth.^2, 2)) sqrt(sum(deriv.^2, 2))];
end
