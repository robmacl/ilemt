function [state_err, nres] = find_pose_errors_objective(state, res, options)
% Objective function for fixture transform optimization.
%
% Arguments:
%
% state: 
%    current state, additive offsets [so_fix(1:6) se_fix(1:6)] to the
%    source and sensor fixture transforms (units m, rad).
% 
% res:
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
% nres:
%    New result structure, updated for optimized fixture transforms.

  nres = res;
  nres.so_fix = res.so_fix + state(1:6);
  nres.se_fix = res.so_fix + state(7:12);
  nres.desired = fk_pose_calculation(res.stage_pos, nres.so_fix, nres.se_fix);
  npoints = size(nres.desired, 1);
  nres.errors = nres.measured - nres.desired;
  mo_scale = [ones(npoints, 3) ones(npoints, 3) * options.moment];
  state_err = nres.errors .* mo_scale;
end
