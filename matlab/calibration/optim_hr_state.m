%Optimizes the state using high rate coupling matrices extracted from
%LabView output data file 

%%% Parameters:

% 'Z_only', 'XYZ', 'quadrupole', or 'all'
cal_mode = 'all'

% File name of calibration to use for initial state.  If [], then use the
% 'save_calibration' variable.  But if 'save_calibration' does not exist, or
% is empty, then use the default initial_state();
base_calibration = [];

% Input data files, from stage_calibration.vi.  If a cell vector of three,
% then they are in the three standard sensor rotation fixturings.  If only
% one, then it is not rotated.
in_files = {'Z_rot_sd.dat', 'X_rot_sd.dat' 'Y_rot_sd.dat'};

% Is this for high rate calibration?
ishigh = true;

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


% ### overrides:

if (strcmp(cal_mode, 'Z_only'))
  % Z rotation only, use defaults instead of base calibration,
  in_files = 'Z_rot_sd.dat'
  % If we only have Rz data, then we can't identify the Z component of the
  % sensor fixture (as distinct from the source Z fixture).
  freeze = {freeze{:} 'z_se_fix'}
elseif (strcmp(cal_mode, 'XYZ'))
  % XYZ cal based on Z only
  base_calibration = 'Z_only_hr_cal'
elseif (strcmp(cal_mode, 'quadrupole'))
  base_calibration = 'XYZ_hr_cal'
  optimize = {'q_so_pos' 'q_so_mo' 'so_fix' 'se_fix'}
elseif (strcmp(cal_mode, 'all')) 
  base_calibration = 'quadrupole_hr_cal'
  optimize = cat(2, {'q_so_pos' 'q_so_mo'}, optimize)
else
  error('Unknown cal_mode: %s', cal_mode);
end



%%% Body of script:
format short g

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
  state0 = calibration2state(cal);
end

%set upper and lower bounds with initial state and freeze cell as input arguments
bounds = state_bounds(state0, optimize, freeze);

%set the options for the optimization, including the "print_state" function
%created to dispaly at each iteration positions, moments and fixture poses
option = optimoptions(...
    @lsqnonlin, 'Display', 'iter-detailed', ...
    'PlotFcns', @optimplotresnorm, 'OutputFcn', @print_state, ...
    'MaxFunctionEvaluations', 60000, 'MaxIterations', 1000, ...
    'FunctionTolerance', 1e-08, 'OptimalityTolerance', 1e-07);

% Read input data as poses and coupling matrices
[stage_poses, c_des] = read_cal_data(in_files, ishigh);

ofun = @(state)calibrate_objective(state, stage_poses, c_des);

% optimization of the state solving non linear least-square problem
% row 1 and 2 of bounds are respectively lower and upper bounds
state_new = lsqnonlin(ofun,state0,bounds(1,:),bounds(2,:),option);

[norm_residue, pred_coupling] = feval(ofun, state_new);
raw_residue = pred_coupling - c_des;
 
%create a calibration struct using the optimazed state_new                     
hr_cal = state2calibration(state_new);

if (~isempty(out_file))
  %save in a .mat file all the optimized values
  save(out_file, '-struct', 'hr_cal');
end
