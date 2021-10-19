function [res] = perr_on_axis (perr, options)
  % Struct array summarizing axis errors, indexed by axis.  Each axis may have a
  % different numbers of points.  Units are mm and degrees, mm/degree, etc.
  %
  %   res(ax).x(npoints): the x values for that axis.  npoints is less than the
  %     original npoints due to end effects in the S-G filter.
  %
  %   res(ax).errs(kind, npoints, deriv):
  %     "same kind" means trans->trans or rot->rot coupling, "different kind"
  %     means rot->trans or trans->rot.  See on_axis_kind.m definitions for kind.
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

  on_axis_kind; % definitions
  res = struct([]);

  % Errors are expressed in the coordinates of the stage input (so include the
  % source fixture transform, source fixture motion, and stage transform).
  if (~options.stage_coords)
    error('For sweep, options.stage_coords must be true (I think).');
  end
  
  % This is some funky stuff related to dealing with sensor fixtures.  The
  % problem is that we want to identify sweeps on the Rz axis as being sweeps
  % about the rotated sensor mover axis.  (Not the sensor axis per-se because
  % we don't want to introduce the sensor fixture transform misalignments.)
  % This is probably only pseudo-general, but works for the current stage
  % setup.
  %
  % stage_pos is the "stage position" that we look at to decide what axis we are
  % sweeping.  Can be understood as a pose vector.
  stage_pos = zeros(size(perr.desired, 1), 6);
  for (ix = 1:size(stage_pos, 1))
    % Actual stage motion, where the sweep happens
    XYZRz_mo = perr.motion_poses(ix, 13:18);
    % Stage motion composed with sensor fixture.
    stage_mo = perr.motion_poses(ix, 7:12);
    % Sensor fixture motion only.  Inverse transforms vectors into the sensor
    % fixture coordinates.
    se_fix_tr_inv = inv(vector2tr(stage_mo - XYZRz_mo));
    XYZRz_po = trans2pose(vector2tr(XYZRz_mo));
    % rotate the rotation (vector) by the (fixture) rotation, also converting to
    % degrees/mm.
    RxRyRz = se_fix_tr_inv * [XYZRz_po(4:6) 0]' * (180/pi);
    % Likewise, the translation.
    xyz = se_fix_tr_inv * [XYZRz_po(1:3) 1]' * 1e3;
    
    stage_pos(ix, :) = [xyz(1:3)' RxRyRz(1:3)'];
  end

  % Mask for zero elements in the stage position, used to separate out the
  % different axis sweeps.
  % ### We need this rather large value because of stage error
  % compensation resulting in non-zero values.
  zero_tol = 0.3;
  zero_ax = abs(stage_pos) < zero_tol;
  
  % Scale pose error to mm/degree. 
  pose_err = [perr.errors(:, 1:3)*1e3, perr.errors(:, 4:6)*(180/pi)];

  for (ax = 1:6)
    % Is there any sweep on this axis?
    if (all(zero_ax(:, ax)))
      fprintf(1, 'Axis %d: no sweep, skipping.\n', ax);
      res(ax).on_ax_ix = [];
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
    isjump = diff(on_ax_ix) ~= 1;
    if (any(isjump))
      fprintf(1, 'Axis %d: holes in sweep or multiple sweeps, using first chunk.\n', ax);
      on_ax_ix = on_ax_ix(1:(find(isjump, 1) - 1));
    end

    dx = diff(stage_pos(on_ax_ix, ax));
    bad_dx = (abs(dx - median(dx)) > zero_tol);
    if (any(bad_dx))
      bad_dx = [bad_dx(1); bad_dx];
      on_ax_ix = on_ax_ix(~bad_dx);
      fprintf(1, 'Axis %d: nonuniform step size, dropping %d poses.\n', ...
              ax, sum(bad_dx)); 
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
    res(ax).err = zeros(onax_num_kinds, length(on_ax_err), 2);
    res(ax).err(onax_on_axis, :, :) = shiftdim(on_ax_err, -1);
    
    % All the error kinds
    res(ax).err(onax_other_axes, :, :) = ...
        shiftdim(perr_filt(x, pose_err(on_ax_ix, off_ax), options), -1);
    res(ax).err(onax_same_axes, :, :) = ...
        shiftdim(perr_filt(x, pose_err(on_ax_ix, same_ax), options), -1);
    res(ax).err(onax_cross, :, :) = ...
        shiftdim(perr_filt(x, pose_err(on_ax_ix, diff_ax), options), -1);
    res(ax).err(onax_to_Rz, :, :) = ...
       shiftdim(perr_filt(x, pose_err(on_ax_ix, Rz_ax), options), -1);
    
    for (kix = 1:onax_num_kinds)
      for (dix = 1:2)
	res(ax).stats(kix, dix, 1) = sqrt(mean(squeeze(res(ax).err(kix, :, dix)).^2));
	res(ax).stats(kix, dix, 2) = max(abs(squeeze(res(ax).err(kix, :, dix))));
      end
    end
  end
end

function [res, x_out] = perr_filt_onax (x, y, options)
  [~, deriv, x_out, x_ix_out] = ...
    sg_filt(x, y, options.sg_filt_N, options.sg_filt_F);
  res = [y(x_ix_out) deriv];
end

% The columns of Y are multiple axis signals.  The result is the vector sum.
% res(:, 1) is the input signal (clipped for filter ends), and res(:, 2) is
% the derivitive.  We don't use the filter "smoothed" output since it doesn't
% need it, allowing higher smoothing on the derivative.
function [res, x_out] = perr_filt (x, y, options)
  [~, deriv, x_out, x_ix_out] = ...
    sg_filt(x, y, options.sg_filt_N, options.sg_filt_F);
  res = [sqrt(sum(y(x_ix_out, :).^2, 2)), sqrt(sum(deriv.^2, 2))];
end
