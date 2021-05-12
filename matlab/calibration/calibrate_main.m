% Use optimization to find a calibration using the coupling matrices and poses
% extracted from stage_calibration.vi output data file.


%%% Parameters:

% 'Z_only', 'XYZ', 'quadrupole', or 'all'
cal_mode = 'XYZ'

% 'dipole' or 'premo'
sensor = 'premo'


%%% Defaults:

% File name of calibration to use for initial state.  If [], then use the
% 'save_calibration' variable.  But if 'save_calibration' does not exist, or
% is empty, then use the default initial_state();
base_calibration = [];

% Input data files, from stage_calibration.vi.  If a cell vector of three,
% then they are in the three standard sensor rotation fixturings.  If only
% one, then it is not rotated.
in_files = {'Z_rot_sd.dat', 'X_rot_sd.dat' 'Y_rot_sd.dat'};
%in_files = {'Z_rot_md.dat', 'X_rot_md.dat' 'Y_rot_md.dat'};

% Is this for high rate calibration?
options.ishigh = true;

% Estimate and subtract coupling bias?  Seems to hurt, not help.
options.debias = false;

% Normalize residue by coupling magnitude?
options.normalize = true;

% calibration output .mat file name
out_file = [cal_mode '_hr_cal'];

% What to optimize: 'optimize' and 'freeze' arguments to state_bounds().

% Default is 'dipole only', ie. dipole and fixture 
optimize = {'d_so_pos' 'd_so_mo' 'd_se_pos' 'd_se_mo' 'so_fix' 'se_fix'};

% Portions of a component which is optimized, but that we don't actually want
% to optimize.  If this is already not enabled for optimization, then no harm
% done.
% 
% Specifically, If the XY axes are allowed to rotate in the XY plane then this
% degree of freedom is redundant with the fixture Rz component.  Pinning
% the Y component of the X moment to 0 prevents this.
freeze = {'d_so_y_co' 'd_se_y_co'};


%%% mode/sensor effects:
% 
% Settings conditional on mode/sensor

if (strcmp(cal_mode, 'Z_only'))
  % Z rotation only, use defaults instead of base calibration,
  in_files = 'Z_rot_sd.dat'
%  in_files = 'Z_rot_md.dat'
  % If we only have Rz data, then we can't identify the Z component of the
  % sensor fixture (as distinct from the source Z fixture).
  freeze = {freeze{:} 'z_se_fix'}
elseif (strcmp(cal_mode, 'XYZ'))
  % XYZ cal based on Z only
  base_calibration = 'Z_only_hr_cal'
elseif (strcmp(cal_mode, 'quadrupole'))
  base_calibration = 'XYZ_hr_cal'
  optimize = {'q_so_pos' 'q_so_mo' 'so_fix' 'd_so_mo'}
elseif (strcmp(cal_mode, 'all')) 
  base_calibration = 'quadrupole_hr_cal'
  optimize = cat(2, {'q_so_pos' 'q_so_mo'}, optimize)
elseif (strcmp(cal_mode, 'premo')) 
else
  error('Unknown cal_mode: %s', cal_mode);
end


if (strcmp(sensor, 'premo'))
  %optimize = {'se_fix'}
  %  base_calibration = 'initial_hr_cal'
  %base_calibration = '../cal_5_11_premo/so_fix_hr_cal'
  %optimize = {'se_fix', 'd_se_mo'}
  %freeze = {'d_so_y_co' 'd_se_y_co'}
  %base_calibration = 'Z_only_hr_cal'
elseif (strcmp(sensor, 'dipole'))
else
  error('Unknown sensor: %s', sensor);
end


%%% overrides:
% 
% Extra hacks here


%%% Body of script:

format short g
disp(pwd())

if (isempty(base_calibration))
  if (exist('save_calibration', 'var') && ~isempty(save_calibration))
    state0 = calibration2state(save_calibration);
  else
    state0 = initial_state();
  end
else
  % create an input state for the optimization from the calibration values and
  % source and sensor fixtures
  cal = load(base_calibration);
  % If there is no quadrupole, then we need to kick ourselves out of the
  % zero/near-zero special case.  Giving a significant magnitude also
  % usually helps optimization to take a more aggressive initial step.
  if (strcmp(cal_mode, 'quadrupole'))
    cal.q_source_moment = eye(3) .* -0.01;
  end
  state0 = calibration2state(cal);
end

%set upper and lower bounds with initial state and freeze cell as input arguments
bounds = state_bounds(state0, optimize, freeze);

%set the options for the optimization, including the "print_state" function
%created to dispaly at each iteration positions, moments and fixture poses
opt_option = optimoptions(...
    @lsqnonlin, 'Display', 'iter-detailed', ...
    'PlotFcns', @optimplotresnorm, 'OutputFcn', @print_state, ...
    'MaxFunctionEvaluations', 60000, 'MaxIterations', 1000, ...
    'FunctionTolerance', 1e-08, 'OptimalityTolerance', 1e-07);

% Read input data as poses and coupling matrices
[stage_poses, c_des] = read_cal_data(in_files, options.ishigh);

ofun = @(state)calibrate_objective(state, stage_poses, c_des, options);

% optimization of the state solving non linear least-square problem
% row 1 and 2 of bounds are respectively lower and upper bounds
state_new = lsqnonlin(ofun,state0,bounds(1,:),bounds(2,:), opt_option);

[norm_residue, pred_coupling, bias] = feval(ofun, state_new);
 
%create a calibration struct using the optimized state_new                     
hr_cal = state2calibration(state_new);
hr_cal.bias = bias;

if (~isempty(out_file))
  %save in a .mat file all the optimized values
  save(out_file, '-struct', 'hr_cal');
end
