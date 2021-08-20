function [perr] = find_pose_errors (calibration, options)
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
% perr struct, with fields:
% 
% measured_source(npoints, 6)
% measured(npoints, 6)
% desired(npoints, 6)
% errors(npoints, 6):
%    Pose vectors for the measured and desired poses, and the errors (the
%    difference).  measured_source is the normal pose measurement (sensor in
%    stage coordinates).  If options.stage_coords is true (default), then
%    measured, desired, and errors are in stage coordinates.
% 
% so_fix, st_fix, se_fix:
%    The source, stage, and sensor fixture transforms, possibly optimized.
% 
% motion_poses(npoints, 12):
%    The motion axis poses [so_fixture se_stage] (mm, degrees)
% 
% couplings(npoints, 3, 3)
%    The coupling matrices.
% 
% coupling_norms(npoints)
%    norm() of each coupling matrix
%
  perr.so_fix = calibration.source_fixture;
  perr.st_fix = calibration.stage_fixture;
  perr.se_fix = calibration.sensor_fixture;
  [motion_poses, couplings] = read_cal_data(options);
  
  if (options.hemisphere == 0)
    % Find hemisphere for pose solutions.  We use the ground truth pose and pick
    % the direction with the largest translation.
    desired1 = fk_pose_calculation(motion_poses, perr.so_fix, perr.st_fix, perr.se_fix);
    desired1 = desired1(:, 1:3);
    hemisphere = zeros(size(desired1, 1), 1);
    for (ix = 1:size(desired1, 1))
      [~, m_ix] = max(abs(desired1(ix, :)), [], 2);
      hemisphere(ix) = m_ix * sign(desired1(ix, m_ix));
    end
  else
    hemisphere = [];
  end
  [so_measured, valid, resnorms] = ...
      pose_solution(couplings, calibration, options, hemisphere);
  %{
  figure(10)
  probplot(resnorms);
  title('Pose solution residual');
  %}

  perr.solution_residuals = resnorms;
  perr.measured_source = so_measured(valid, :);
  perr.motion_poses = motion_poses(valid, :);
  perr.couplings = couplings(:, :, valid);
  for (ix = 1:size(perr.couplings, 3))
    norms(ix) = norm(perr.couplings(:,:,ix));
  end
  perr.coupling_norms = norms;

  % State for minimization is: 
  %    [so_fixture_off(1:6) st_fixture_off(1:6) se_fixture_off(1:6)]
  % 
  % These are additive offsets from the nominal source and sensor fixture
  % poses.  See find_pose_errors_objective.m.  What this does is refine our
  % idea of the *desired* (ground truth pose).  This differs from the main
  % calibration optimization in that we operate in *pose* space, and that we
  % are searching for the source and sensor fixtures that minimize the *pose*
  % error, not the *coupling* error.  We need the pose error to evaluate
  % performance.

  % Intial value of x based on last run.  Initial initial value is all 1e-3,
  % giving what is (in our scaling) a small initial value.  This makes
  % optimization run much faster than all zeros, presumably because it
  % establishes the correct order of magnitude.
  persistent state;
  if (isempty(state))
    state = ones(1, 18) * 1e-3;
  end

  ofun = @(state) ...
    find_pose_errors_objective(state, perr, options); 

  if (~isempty(options.optimize_fixtures))
    badopt = setdiff(options.optimize_fixtures, {'source', 'stage', 'sensor'});
    if (~isempty(badopt))
      error('Unknown options.optimize_fixtures: %s', badopt{1});
    end

    opt_options = optimset('lsqnonlin');
    opt_options = optimset(opt_options, 'Display', 'off');
    %opt_options = optimset(opt_options, 'PlotFcns', @optimplotresnorm);
    allow_opt = [ones(1,3) * 0.5, ones(1,3) * 3*pi];
    bounds = zeros(1, 18);
    if (any(strcmp(options.optimize_fixtures, 'source')))
      bounds(1:6) = allow_opt;
    end
    if (any(strcmp(options.optimize_fixtures, 'stage')))
      bounds(1, 7:12) = allow_opt;
    end
    if (any(strcmp(options.optimize_fixtures, 'sensor')))
      bounds(1, 13:18) = allow_opt;
    end

    fprintf(1, 'Optimizing fixture poses:\n');
    disp(options.optimize_fixtures);

    figure(1);
    [state,resnorm,residual,exitflag,output] = ...
	lsqnonlin(ofun, state, -bounds, bounds, opt_options);
    close();

    % No semicolon, delibrate display of results
    source_fix_delta = state(1:6)
    stage_fix_delta = state(7:12)
    sensor_fix_delta = state(13:18)
  else
    state = zeros(1, 18);
  end

  [~, perr] = ofun(state);
end
