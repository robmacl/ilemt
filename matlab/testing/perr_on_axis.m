function [res] = perr_on_axis (perr, options)
  % Struct array summarizing axis errors, indexed by axis.  Each axis may have
  % a different numbers of points, hence the outer cell array.  Units are mm
  % and degrees, mm/degree, etc.
  %
  %   res(ax).x(npoints): the x values for that axis.  npoints is less than the
  %     original npoints due to end effects in the S-G filter.
  %
  %   res(ax).errs(kind, npoints, deriv):
  %     kind is 1 for on-axis error, 2 for off-axis same-kind, 3 for different
  %     kind (trans<->rot cross coupling), 4 for coupling to Rz.  If deriv=1,
  %     then it is the base (INL) error, if deriv=2, then it is the DNL .  For
  %     other than on-axis, the values are the vector sums of the off-axis INL
  %     and DNL, so are non-negative.
  %
  %   res(ax).stats(kind, deriv, rms_mav):
  %     Summary of errs.  kind and deriv are as for errs, rms_mav = 1, RMS,
  %     rms_mav = 2,  max absolute value.
  %
  %   res(ax).on_ax_ix(orig_npoints):
  %     Indices in the perr input data for the points corresponding to this
  %     axis sweep.  This allows you to dig in the input data for this axis.
  %
  % Note that the axis sweeps are defined in the stage coordinates, so we
  % map the errors back into those coordinates.
  res = struct([]);

  % Mask for zero elements in the stage position, used to separate out the
  % different axis sweeps.
  zero_tol = 1e-4;
  zero_ax = abs(perr.stage_pos) < zero_tol;

  % ### FIXME: this was broken by the addition of the source motion.
  pose_err = perr.stage_pos_errors;

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

    lims = options.axis_limits(ax, :);
    clip = perr.stage_pos(:, ax) < lims(1) | perr.stage_pos(:, ax) > lims(2);
    clip = clip(on_ax_ix);
    on_ax_ix(clip) = [];

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
    same_ax(same_ax == ax) = [];
    Rz_ax = [6];
    
    res(ax).on_ax_ix = on_ax_ix;
    x = perr.stage_pos(on_ax_ix, ax);
    [on_ax_err, res(ax).x] = perr_filt_onax(x, pose_err(on_ax_ix, ax), options);
    res(ax).err = ...
      [shiftdim(on_ax_err, -1)
       shiftdim(perr_filt(x, pose_err(on_ax_ix, same_ax), options), -1)
       shiftdim(perr_filt(x, pose_err(on_ax_ix, diff_ax), options), -1)
       shiftdim(perr_filt(x, pose_err(on_ax_ix, Rz_ax), options), -1)];
    for (kix = 1:4)
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
