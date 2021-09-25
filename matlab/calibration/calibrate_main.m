function [calibration, options] = calibrate_main (cal_mode, varargin)
% Use optimization to find a calibration using the coupling matrices and poses
% extracted from stage_calibration.vi output data file.
% 
% This script expects to be run in a directory with calibration output files
% and configuration scripts.  See calibrate_options().  
% 
% cal_mode: 
%     If a string, sets options.cal_mode, definining what we optimize.  See
%     immediately below for cal_mode values.  If arg is an options struct,
%     then this replaces all of the options processing we would otherwise do.
% 
% varargin:
%     name value pairs which are assigned into options, overriding the
%     values established by cal_mode and local_cal_options.
%
%% cal_mode settings:
%
% 'default'
%     No special processing
% 
% 'Z_only'
%     Optimize source and sensor dipole from single source and sensor
%     fixture.  Useful first step, unless the fixture transforms are
%     unknown.
% 
% 'XYZ'
%     Optimize source and sensor dipole from single source fixture, but
%     multiple sensor fixtures.
% 
% 'so_quadrupole'
%     Optimize source quadrupole and dipole only.
% 
% 'so_quadrupole_all'
%     Add sensor parameters to quadrupole optimization.
% 
% 'se_quadrupole'
% 'se_quadrupole_all'
%     Sensor quadrupole, analogous to source quadrupole.
% 
% 'so_fixture'
% 'so_fixture_all'
% 'st_fixture'
% 'se_fixture'
%     Optimize only fixture transforms.  Useful preliminary if the fixture
%     transform is unknown or has changed, since the calibration optimization
%     does not work well if the fixture transforms are far off. 'so_fixture'
%     means source and stage fixture, while 'se_fixture' is stage and sensor
%     fixture.  'st_fixture' is the stage fixture alone.  Usually you want
%     source fixture motions to solve for the source fixture, and likewise
%     sensor fixture motions to solve for the sensor fixture.
% 

if (isstruct(cal_mode) && isfield(cal_mode, 'cal_mode'))
  options = cal_mode;
else
  options = calibrate_options(cal_mode, varargin);
  check_options({options}, varargin);
end

% Used by save_checkpoint()
global current_calibrate_options;
current_calibrate_options = options;

global last_calibration;

fprintf(1, '\nCalibrating from: %s\n', pwd());

if (~options.force)
  found = load_cal_file(options.out_file, true);
  if (~isempty(found))
    fprintf('%s: output already exists, skipping.\n', ...
            options.out_file);
    calibration = found;
    options = found.options;
    return;
  end
end

if (isempty(options.base_calibration))
  if (isempty(last_calibration))
    error('No last_calibration, must specifiy options.base_calibration');
  end
  fprintf(1, 'Using last_calibration "%s" as base calibration.\n', ...
          last_calibration);
  options.base_calibration = last_calibration;
end


%%% Body of script:

format short g
disp(options)

% create an input state for the optimization from the calibration values and
% source and sensor fixtures
base_cal = load_cal_file(options.base_calibration);

% If there is no quadrupole, then we need to kick ourselves out of the
% zero/near-zero special case.  Giving a significant magnitude also usually
% helps optimization to take a more aggressive initial step.
if (strcmp(options.cal_mode, 'so_quadrupole'))
  if (all(all(base_cal.q_source_moment == 0)))
    base_cal.q_source_moment = eye(3) .* -0.01;
  end
elseif (strcmp(options.cal_mode, 'se_quadrupole'))
  if (all(all(base_cal.q_sensor_moment == 0)))
    base_cal.q_sensor_moment = eye(3) .* -0.01;
  end
end

% With concentric model, the dipole moments are forced to the origin.
% Used for kim18 pose solution method.
if (options.concentric)
  base_cal.d_source_pos = zeros(3);
  base_cal.d_sensor_pos = zeros(3);
end


% Set initial state from base calibration.
state0 = calibration2state(base_cal);

% Set upper and lower state bounds according to 'optimize' and 'freeze' specs.
% Rowe 1 and 2 of bounds are respectively lower and upper bounds.  See
% state_bounds() for details.
bounds = state_bounds(state0, options.optimize, options.freeze);

% Set the options for the optimization.
% Tighter tolerances than the default 1e-6 probably don't really help, but
% also don't slow that much.
opt_option = optimoptions(...
    @lsqnonlin, ...
    'MaxIterations', options.iterations, ...
    'OutputFcn', @(state, ~, ~) print_state(state, options), ...
    'FunctionTolerance', 1e-08, 'OptimalityTolerance', 1e-07, ...
    options.optimoptions_opts{:});

if (options.verbose >= 1)
  opt_option = optimoptions(opt_option, ...
      'Display', 'iter-detailed');
end

% optional display of optimization progress.
if (options.verbose >= 2)
  opt_option = optimoptions(opt_option, ...
      'PlotFcns', @optimplotresnorm);
end

% Read input data as stage/fixture poses (ground truth) and the measured
% coupling matrices.
[motion_poses, measured_couplings] = read_cal_data(options);

ofun = @(state)calibrate_objective(state, motion_poses, measured_couplings, options);

% Calibration optimization as a nonlinear least-square problem.  The
% calibration that we seek is the one that generates the measured couplings
% from the known poses.
[state_new, cal_residue] = lsqnonlin(ofun,state0,bounds(1,:),bounds(2,:), opt_option);

calibration = state2calibration(state_new, options);
stats.rms_residue = sqrt(cal_residue/size(motion_poses, 1));
stats.sum_squared_residue = cal_residue;
stats.num_points = size(motion_poses, 1);
calibration.stats = stats;

% Apply output correction minimizing error in pose space (linear correction).
calibration = output_correction(calibration, options);

fprintf(1, '\nCalibration result:\n');
print_calibration(calibration)
fprintf(1, 'RMS/point residue %.4f, sum square %.4f\n', ...
        stats.rms_residue, stats.sum_squared_residue);

save_calibration(calibration, options.out_file);

% last_calibration is the default base_calibration for the next calibration
% or check_poses().
global last_calibration;
last_calibration = options.out_file;
