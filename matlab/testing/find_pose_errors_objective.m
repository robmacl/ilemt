function [state_err, perr] = find_pose_errors_objective(state, perr_in, options)
% Objective function for fixture transform optimization.
%
% Arguments:
%
% state: 
%    current state, additive offsets [so_fix(1:6) st_fix(1:6) se_fix(1:6)]
%    to the fixture transforms (units m, rad).
% 
% perr_in:
%    The result structure being built for find_pose_errors.  We use this to
%    access the initial fixture transforms and the (unchanging) pose solutions.
%  
% options:
%    The find_pose_errors options struct.  
% 
% Return values:
%
% state_err(n, 6): 
%    The residual for optimization, scaled to meters.  We weight the rotation
%    by options.moment, a distance at which the angular error becomes a
%    translation error.
%
% perr:
%    New result structure, updated for optimized fixture transforms.

  perr = perr_in;
  perr.so_fix = perr.so_fix + state(1:6);
  perr.st_fix = perr.st_fix + state(7:12);
  perr.se_fix = perr.se_fix + state(13:18);

  so_measured = perr.measured_source;
  so_desired = fk_pose_calculation(perr.motion_poses, perr.so_fix, ...
                                   perr.st_fix, perr.se_fix);

  if (options.stage_coords)
    so_fix_t = pose2trans(perr.so_fix);
    st_fix_t = pose2trans(perr.st_fix);
    se_fix_t = pose2trans(perr.se_fix);

    st_desired = zeros(size(so_desired));
    st_measured = st_desired;
    st_errors = st_desired;
    for (ix = 1:size(so_measured, 1))
      measured_t = pose2trans(so_measured(ix, :));
      desired_t = pose2trans(so_desired(ix,:));
      % Source fixture motion
      so_motion_t = vector2tr(perr.motion_poses(ix, 1:6));
      % T1 is a common subexpression
      T1 = so_fix_t * so_motion_t * st_fix_t;
      st_desired1 = inv(se_fix_t * inv(desired_t) * T1);
      st_measured1 = inv(se_fix_t * inv(measured_t) * T1);
      st_error1 = inv(st_desired1) * st_measured1;
      st_measured(ix, :) = trans2pose(st_measured1);
      st_desired(ix, :) = trans2pose(st_desired1);
      st_errors(ix, :) = trans2pose(st_error1);
if (norm(st_errors(ix, :)) > 0.1)
  keyboard;
end
    end
    perr.measured = st_measured;
    perr.desired = st_desired;
    perr.errors = st_errors;
  else
    perr.measured = so_measured;
    perr.desired = so_desired;
    perr.errors = perr.measured - perr.desired;
for (ix = 1:size(so_measured, 1))
  so_measured1 = perr.measured(ix, :);
  so_desired1 = perr.desired(ix, :);
  so_error1 = perr.errors(ix, :);
  if (norm(so_error1) > 0.1)
    %keyboard;
  end
end
  end

  npoints = size(perr.desired, 1);
  mo_scale = [ones(npoints, 3) ones(npoints, 3) * options.moment];
  state_err = perr.errors .* mo_scale;
end
