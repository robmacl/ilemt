function [state_err, perr_new] = find_pose_errors_objective(state, perr, options)
% Objective function for fixture transform optimization.
%
% Arguments:
%
% state: 
%    current state, additive offsets [so_fix(1:6) st_fix(1:6) se_fix(1:6)]
%    to the fixture transforms (units m, rad).
% 
% perr:
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
% perr_new:
%    New result structure, updated for optimized fixture transforms.

  perr_new = perr;
  perr_new.so_fix = perr.so_fix + state(1:6);
  perr_new.st_fix = perr.st_fix + state(7:12);
  perr_new.se_fix = perr.se_fix + state(13:18);

  perr_new.desired = ...
      fk_pose_calculation(perr.motion_poses, perr_new.so_fix, perr.st_fix, perr_new.se_fix);
  npoints = size(perr_new.desired, 1);
  perr_new.errors = perr_new.measured - perr_new.desired;
  mo_scale = [ones(npoints, 3) ones(npoints, 3) * options.moment];
  state_err = perr_new.errors .* mo_scale;
end
