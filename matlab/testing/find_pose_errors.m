% Check accuracy of poses, returning information about the errors which is
% analyzed elsewhere.  
% 
% Here we (mostly) we represent a pose as a 6-vector with the units meters and
% radians, where the rotation part is a rotation vector, not Euler angles.
% (The stage pose is actual sequential axis positions, so *is* interpreted as
% Euler angles.)  Although the difference is small for small angles, direction
% vectors are a sound basis for mean and other statistics, while Euler angles
% (or even a 1DOF angle) aren't, due to problems with wrapping.
%
% options: see check_poses_options()
% 
% Results: 
% res struct, with fields:
% 
% measured(npoints, 6)
% desired(npoints, 6)
% errors(npoints, 6):
%    Pose vectors for the measured and desired poses, and the errors (the
%    difference).
% 
% so_fix, se_fix:
%    The source and sensor fixture transforms, possibly optimized.
% 
% stage_pos(npoints, 6):
%    The stage axis positions (mm, degrees)
% 
% couplings(npoints, 3, 3)
%    The coupling matrices.
% 
% coupling_norms(npoints)
%    norm() of each coupling matrix
%
function [res] = find_pose_errors (options)
  calibration = load(options.cal_file);
  res.so_fix = calibration.source_fixture;
  res.se_fix = calibration.sensor_fixture;
  options.bias = calibration.bias;
  [stage_pos, couplings] = read_cal_data(options);
  [measured, valid, resnorms] = ...
      pose_calculation(couplings, calibration, options);
  %{
  figure(10)
  probplot(resnorms);
  title('Pose solution residual');
  %}
  
  res.measured = measured(valid, :);
  res.stage_pos = stage_pos(valid, :);
  res.couplings = couplings(:, :, valid);
  for (ix = 1:size(res.couplings, 3))
    norms(ix) = norm(res.couplings(:,:,ix));
  end
  res.coupling_norms = norms;

  % State for minimization is: 
  %    [so_fixture_off(1:6) se_fixture_off(1:6)]
  % 
  % These are additive offsets from the nominal source and sensor fixture
  % poses.  see check_poses_objective.m.  What this does is refine our idea of
  % the *desired* (ground truth pose).  This differs from the main calibration
  % optimization in that we operate in *pose* space, and that we are searching
  % for the source and sensor fixtures that minimize the *pose* error, not the
  % *coupling* error.  We need the pose error to evaluate performance.

  % Intial value of x based on last run.  Initial initial value is all 1e-3,
  % giving what is (in our scaling) a small initial value.  This makes
  % optimization run much faster than all zeros, presumably because it
  % establishes the correct order of magnitude.
  persistent x;
  if (isempty(x))
    x = ones(1, 12) * 1e-3;
  end

  ofun = @(state) ...
    find_pose_errors_objective(state, res, options); 

  if (options.do_optimize)
    
    opt_options = optimset('lsqnonlin');
    opt_options = optimset(opt_options, 'Display', 'off');
    %opt_options = optimset(opt_options, 'PlotFcns', @optimplotresnorm);
    allow_opt = [ones(1,3) * 0.5, ones(1,3) * 3*pi];
    bounds = zeros(1, 12);
    if (strcmp(options.do_optimize, 'both'))
      bounds = [allow_opt, allow_opt];
    elseif (strcmp(options.do_optimize, 'source'))
      bounds(1, 1:6) = allow_opt;
    elseif (strcmp(options.do_optimize, 'sensor'))      
      bounds(1, 7:12) = allow_opt;
    else
      error('Unknown options.do_optimize: %s', options.do_optimize);
    end
    fprintf(1, 'Optimizing fixture poses: %s\n', options.do_optimize);

    [x,resnorm,residual,exitflag,output] = ...
	lsqnonlin(ofun, x, -bounds, bounds, opt_options);
  
    source_fix_delta = x(1:6)
    sensor_fix_delta = x(7:12)
  else
    x = zeros(1, 12);
  end

  [X_err, nres] = ofun(x);
  res = nres;
  
  sof = inv(pose2trans(res.so_fix));
  sef = inv(pose2trans(res.se_fix));
  s_measured = zeros(size(res.measured));
  for (ix = 1:size(res.stage_pos, 1))
    s_measured(ix, :) = tr2vector(sof * pose2trans(res.measured(ix, :)) * sef);
  end
  res.stage_pos_measured = s_measured;
  % ### The way we are computing res.stage_pos_errors via subtraction does not
  % work if there are large rotations.  Here, and with res.errors, it would be
  % more correct to compute the pose errors using pose multiplication rather
  % than subtraction, see perr_workspace_vol.  eg. inv(desired) * measured.
  % The difference of the pose vectors AFAIK can't be converted to a
  % transform, though subtracting sort of works when the rotations don't wrap.
  res.stage_pos_errors = res.stage_pos_measured - res.stage_pos;
end
