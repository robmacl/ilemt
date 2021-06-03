% Use optimization to find a calibration using the coupling matrices and poses
% extracted from stage_calibration.vi output data file.  
%
% This script expects to be run in a directory with calibration output files
% and configuration scripts.  See calibrate_options().

options = calibrate_options();


%%% Body of script:

format short g
disp(pwd())
disp(options)

if (isempty(options.base_calibration))
  state0 = initial_state();
else
  % create an input state for the optimization from the calibration values and
  % source and sensor fixtures
  cal = load(options.base_calibration);
  % If there is no quadrupole, then we need to kick ourselves out of the
  % zero/near-zero special case.  Giving a significant magnitude also
  % usually helps optimization to take a more aggressive initial step.
  if (strcmp(options.cal_mode, 'so_quadrupole'))
    cal.q_source_moment = eye(3) .* -0.01;
  elseif (strcmp(options.cal_mode, 'se_quadrupole'))
    cal.q_sensor_moment = eye(3) .* -0.01;
  end
  state0 = calibration2state(cal);
end

%set upper and lower bounds with initial state and freeze cell as input arguments
bounds = state_bounds(state0, options.optimize, options.freeze);

%set the options for the optimization, including the "print_state" function
%created to dispaly at each iteration positions, moments and fixture poses
opt_option = optimoptions(...
    @lsqnonlin, 'Display', 'iter-detailed', ...
    'PlotFcns', @optimplotresnorm, 'OutputFcn', @print_state, ...
    'MaxFunctionEvaluations', 60000, 'MaxIterations', 1000, ...
    'FunctionTolerance', 1e-08, 'OptimalityTolerance', 1e-07);

% Read input data as poses and coupling matrices
[stage_poses, c_des] = read_cal_data(options);

ofun = @(state)calibrate_objective(state, stage_poses, c_des, options);

% optimization of the state solving non linear least-square problem
% row 1 and 2 of bounds are respectively lower and upper bounds
[state_new, cal_residue] = lsqnonlin(ofun,state0,bounds(1,:),bounds(2,:), opt_option);
cal_residue

[norm_residue, pred_coupling, bias] = feval(ofun, state_new);
 
%create a calibration struct using the optimized state_new                     
hr_cal = state2calibration(state_new);
hr_cal.bias = bias;
hr_cal.pin_quadrupole = options.pin_quadrupole;
hr_cal.options = options;

if (~isempty(options.out_file))
  %save in a .mat file all the optimized values
  save(options.out_file, '-struct', 'hr_cal');
end
