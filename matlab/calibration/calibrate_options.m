function [options] = calibrate_options ()
% This function expects to be run in a directory with calibration output
% files, and returns an options struct used to control calibration.
% 
% We run sub-scripts in the working directory: 'local_cal_options.m',
% 'local_cal_override.m'.  These local scripts allow to have different
% settings for different data, and avoids frequent modifications to this
% script.
%
% The local_cal_override allows changing some settings which are normally
% computed from the local options, eg. from cal_mode.  This is useful for
% setting things like a nonstandard base calibration from another
% directory, or a nonstandard output file name.


%%% Parameters:

% must set these in 'local_cal_options.m'

% 'Z_only', 'XYZ', 'so_quadrupole', 'so_quadrupole_all', 'se_quadrupole',
% 'st_fixture', 'se_fixture'.
options.cal_mode = 'XYZ';

% 'dipole' or 'premo'.  
% ### This doesn't do anything currently, but used to, and might again
options.sensor = 'premo';


%%% Defaults:

% File name of calibration to use for initial state.  If [], then use the
% default initial_state();
options.base_calibration = [];

% Is this a high rate calibration?
options.ishigh = true;

% Estimate and subtract coupling bias?  Seems to hurt, not help.
options.debias = false;
options.bias = zeros(3);

% Normalize residue by coupling magnitude?
options.normalize = true;

% If true, then the quadrupole positions (source and sensor) are fixed to the
% corresponding dipole position.
options.pin_quadrupole = true;

% If true, the source and sensor dipole positions are forced to zero.  This
% is an ideal concentric coil model.
options.concentric = false;

% Additional correction based on generated poses, eg. linear transform.
% We have several correction modes, but 'DLT' is currently the best.
% See output_correction().
options.correct_mode = 'DLT';

% These allow sign flip on sensor input (coupling column) or source
% (coupling row).  These are only needed if the input signs or coupling
% signs were wrong in labview ilemt_ui when the data was taken.
options.sensor_signs = [1 1 1];
options.source_signs = [1 1 1];


% Options to define the input data files:
% 
% Data file names are of the format:
%  'so<source motion>_se<sensor motion>_<size>.dat'.
% 
% The <XXX motion> represents an additional rotation, see read_cal_data().
% (Or, if the pattern does not match, then we assume no fixture motion.)
% 
% The <size> is related to the test pattern used to generate the data, where
% we typically have small, medium and large: 'sd', 'md', 'ld'.  The size
% doesn't affect anything, it just lets us have multiple data sizes, or
% otherwise different files.
%
% The default is for source fixture motion.
options.input_motion = {
    'so+X+Y+Z_se+X+Y+Z'
    'so+X+Y+Z_se+X-Z+Y'
    'so+X+Y+Z_se-Y-Z+X'
    };

options.data_size = 'md';

% Cell vector of input files, normally generated from input_motion and
% data_size, but if you set to non-empty in local_cal_options.m then it will
% override the default list.
options.in_files = {};

% Output calibration file name, defaulted if empty.
options.out_file = [];


% What to optimize: 'optimize' and 'freeze' arguments to state_bounds().

% Default is 'dipole only', ie. dipole and fixture 
options.optimize = {'d_so_pos' 'd_so_mo' 'd_se_pos' 'd_se_mo' 'st_fix' 'se_fix'};

% Portions of a component which is optimized, but that we don't actually want
% to optimize.  If this is already not enabled for optimization, then no harm
% done.
% 
% Specifically, If the XY axes are allowed to rotate in the XY plane then this
% degree of freedom is redundant with the fixture Rz component.  Pinning
% the Y component of the X moment to 0 prevents this.
options.freeze = {'d_so_y_co' 'd_se_y_co'};


% Get local settings
run('./local_cal_options.m');


%%% mode/sensor effects:
% 
% Settings conditional on mode/sensor

% out_file: calibration output .mat file name
if (isempty(options.out_file))
  options.out_file = [options.cal_mode '_hr_cal'];
end

bc_default = [];

if (strcmp(options.cal_mode, 'default'))
  % Just take defaults and explicit settings in local options/override
elseif (strcmp(options.cal_mode, 'Z_only'))
  % Z rotation only, use defaults instead of base calibration,
  options.input_motion = options.input_motion(1);
  % If we only have Rz data, then we can't identify the Z component of the
  % sensor fixture (as distinct from the source Z fixture).
  options.freeze = {options.freeze{:} 'z_se_fix'};
elseif (strcmp(options.cal_mode, 'XYZ'))
  % XYZ cal based on Z only
  bc_default = 'Z_only_hr_cal';
elseif (strcmp(options.cal_mode, 'so_quadrupole'))
  bc_default = 'XYZ_hr_cal';
  options.optimize = {'q_so_mo' 'so_fix' 'd_so_pos' 'd_so_mo'};
  if (~options.pin_quadrupole)
    options.optimize = cat(2, {'q_so_pos'}, options.optimize);
  end
elseif (strcmp(options.cal_mode, 'so_quadrupole_all')) 
  bc_default = 'so_quadrupole_hr_cal';
  options.optimize = cat(2, {'q_so_mo' 'so_fix'}, options.optimize);
  if (~options.pin_quadrupole)
    options.optimize = cat(2, {'q_so_pos'}, options.optimize);
  end
elseif (strcmp(options.cal_mode, 'se_quadrupole'))
  bc_default = 'XYZ_hr_cal';
  options.optimize = {'q_se_mo' 'se_fix' 'd_se_mo'};
  if (~options.pin_quadrupole)
    options.optimize = cat(2, {'q_se_pos'}, options.optimize);
  end
elseif (strcmp(options.cal_mode, 'se_quadrupole_all')) 
  bc_default = 'se_quadrupole_hr_cal';
  options.optimize = cat(2, {'q_se_mo'}, options.optimize);
  if (~options.pin_quadrupole)
    options.optimize = cat(2, {'q_se_pos'}, options.optimize);
  end
elseif (any(strcmp(options.cal_mode, {'so_fixture', 'st_fixture', 'se_fixture'})))
  % Like z_only, but only solve for source fixture
  bc_default = 'base_calibration';
  options.input_motion = options.input_motion(1);
  options.freeze = {options.freeze{:} 'z_se_fix'};
  options.out_file = [];
  if (strcmp(options.cal_mode, 'so_fixture'))
    options.optimize = {'so_fix'};
  elseif (strcmp(options.cal_mode, 'st_fixture'))
    options.optimize = {'st_fix'};
  elseif (strcmp(options.cal_mode, 'se_fixture'))
    options.optimize = {'se_fix'};
  end
else
  error('Unknown cal_mode: %s', options.cal_mode);
end

if (isempty(options.base_calibration))
  options.base_calibration = bc_default;
end

if (options.concentric)
  options.optimize = setdiff(options.optimize, {'d_so_pos', 'd_se_pos'});
end

if (strcmp(options.sensor, 'premo'))
elseif (strcmp(options.sensor, 'dipole'))
else
  error('Unknown sensor: %s', options.sensor);
end

if (isempty(options.in_files))
  ifiles = cell(size(options.input_motion));
  for (ix = 1:length(options.input_motion))
    ifiles{ix} = [options.input_motion{ix} '_' options.data_size '.dat'];
  end
  options.in_files = ifiles;
end


%%% overrides:

% You can override the cal_mode derived settings here, or just use the
% 'default' cal_mode, which does nothing.
if (exist('./local_cal_override.m', 'file'))
  run('./local_cal_override.m');
end
