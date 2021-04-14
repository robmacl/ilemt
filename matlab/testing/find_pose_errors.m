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
% Arguments: 
% data_files:
%     Holds the test data files.  May be a cell 3-vector of fixturings, as in 
%     read_cal_data(). 
% 
% calibration: ILEMT calibration struct
% 
% so_fix, se_fix: source and sensor fixture transforms
%
% options: see check_poses_defaults().
% 
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
%    The stage axis positions (meters, degrees)
% 
% couplings(npoints, 3, 3)
%    The coupling matrices.
%
function [res] = find_pose_errors(data_files, calibration, so_fix, se_fix, options)
  res.so_fix = so_fix;
  res.se_fix = se_fix;
  [res.stage_pos, res.couplings] = read_cal_data(data_files, options.ishigh);
  res.measured = pose_calculation(res.couplings, calibration);

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
    opt_options = optimset('MaxFunEvals', 2000);
    %opt_options = optimset(options, 'PlotFcns', @optimplotresnorm);
    x_max = [0.2 0.2 0.2 0.2 0.2 0.2];
    x_max = [x_max x_max];

    [x,resnorm,residual,exitflag,output] = ...
	lsqnonlin(ofun, x, -x_max, x_max, opt_options);
  
    x
  else
    fprintf(1, 'Not doing optimization.\n');
    x = zeros(1, 12);
  end

  [X_err, nres] = ofun(x);
  res = nres;
end
