function [options] = calibrate_options (cal_mode, key_value)
% This function expects to be run in a directory with calibration input data
% files, and returns an options struct used to control calibration.  
% 
% cal_mode:
%     Char cal_mode value, or [] to not override the options default.
% 
% key_value:
%     Cell vector of key/value pairs which are stored into the options, after
%     all other options processing.
%
% See calibrate_main() for more on the cal_mode and key_value processing.
% 
% We run the 'local_cal_options.m' scripts in the working directory.  This
% data-specific script sets up defaults related to the particular dataset.


%%% Parameters:

% options.source and sensor are currently just for documentation.  These are
% propagated into the calibration.options (along with all the rest of this
% options struct).
% 
% 'dipole': corner dipole approximating
% 'rotated_dipole': corner dipole rotated so sensor stays in the +++XYZ quadrant.
% 'cmu': the CMU concentric cube coil.
options.source = 'dipole';
%
% 'dipole': corner dipole approximating
% 'premo': Premo model ??? concentric cube.
options.sensor = 'premo';


% Usually this assignment here is overridden by the local options or the
% cal_mode argument, see below.
options.cal_mode = 'default';


%%% Defaults:

% File name of calibration to use for initial state.  Defaults to the last
% calibration output.
options.base_calibration = [];

% Is this a high rate calibration?
options.ishigh = true;

% Normalize residue by coupling magnitude?  The idea is that it makes the
% calibration points equal weighted even though the coupling magnitude varies
% quite a bit.  In limited testing, this maybe improves accuracy 3%, and
% doesn't seem to hurt.
options.normalize = true;

% If true, then the quadrupole positions (source and sensor) are fixed to the
% corresponding dipole position.
options.pin_quadrupole = true;

% If true, the source and sensor dipole positions are forced to zero.  This
% is an ideal concentric coil model.
options.concentric = false;

% Additional correction based on generated poses, eg. linear transform.
% We have several correction modes, but 'optimize' is currently the best.
% See output_correction().  'none' means off.
options.correct_mode = 'optimize';

% If true, reoptimize the fixture poses in output_correction().
options.reoptimize_fixture = false;

% These allow sign flip on sensor input (coupling column) or source
% (coupling row).  These are only needed if the input signs or coupling
% signs were wrong in labview ilemt_ui when the data was taken.  Since sign
% flips may differ between files, we allow multiple regexp patterns on the
% file name.  This is a cell array with rows {pattern signs}, where pattern
% is a regexp char array and signs is a 3-vector [x y z] sign.  The first
% pattern that matches is used.  If none matches, we return [1 1 1].
% 
% Example: 
%    'soZoutYup_seYoutZup_(md|ld).dat' [-1 -1 1]
%    'soXoutZup_seYoutZup_md.dat' [-1 -1 1]
% 
options.sensor_signs = {};
options.source_signs = {};


% Options to define the input data files:
% 
% Data file names are of the format:
%  'so<source motion>_se<sensor motion>_<pattern>.dat'.
% 
% The <XXX motion> represents an additional rotation, see read_cal_data().
% (Or, if the pattern does not match, then we assume no fixture motion.)
% 
% The <pattern> is related to the test pattern used to generate the data,
% see data_patterns below.
% 
% We skip any generated filenames where no file exists.
options.sensor_fixtures = {
    'seYoutZup'
    'seZinYup'
    'seZinXdown'
}';

options.source_fixtures = {
    'soYoutZup'
    'soXoutZup'
    'soZoutYup'
    'soXinYup'
}';

% What data patterns to process:
% 
% 'sd', 'md', 'ld':
%    Small, medium and large data with XYZ grid + Rz rotation, with sensor
%    fixturings.  For sensor and sensor fixture calibration.
% 
% 'source':
%    XYZ grid data with source fixturings. For source and source fixture
%    calibration.
% 
% The data pattern present in the filename doesn't affect the processing, it
% just lets us have output multiple data patterns, or to have otherwise
% different files.  But different patterns are suitable for different
% calibration tasks.
options.data_patterns = {'md'};

% Cell vector of input files, normally generated from
% source_fixtures/sensor_fixtures and data_patterns, but if you set to
% non-empty in local_cal_options.m then it will override the default list.
options.in_files = {};

% Output calibration file name, defaulted if empty.
options.out_file = [];

% If false, do not generate output when it already exists.
options.force = true;


% What to optimize: 'optimize' and 'freeze' arguments to state_bounds().

% Default is 'dipole only', ie. dipole and fixture 
options.optimize = {'d_so_pos' 'd_so_mo' 'd_se_pos' 'd_se_mo' 'st_fix' 'se_fix'};

% Portions of a component which is optimized, but that we don't actually want
% to optimize.  If this is already not enabled for optimization, then no harm
% done.
% 
% Z gain: because the partition of gain between source and sensor is
% arbitrary, either d_so_z_gain or d_se_z_gain must be frozen (typically
% depending on whether we are optimizing source or sensor parameters).
% 
% X axis Y component: If the XY axes are allowed to rotate in the XY plane
% then this degree of freedom is redundant with the fixture Rz component.
% Pinning the Y component of the X moment to 0 prevents this.
options.freeze = {'d_so_z_gain' 'd_so_y_co' 'd_se_y_co'};

% Maximum number of optimize iterations.  Can reduce to avoid excessive
% effort on preliminary optimizations, or increase if optimization is still
% progressing when it stops.
options.iterations = 200;

% Options to pass to optimoptions
options.optimoptions_opts = {};

% Controls display verbosity: 0, 1, 2
options.verbose = 2;

% Get local settings
run('./local_cal_options.m');

if (~isempty(cal_mode))
  options.cal_mode = cal_mode;
end


%%% cal_mode processing
%
% The cal_mode brings in a set of defaults for a particular optimization.

if (strcmp(options.cal_mode, 'default'))
  % Just take defaults and explicit settings in local options/override

elseif (strcmp(options.cal_mode, 'check_poses'))
  % Not actually calibrating, doing check_poses().
  options.source_fixtures = {'soYoutZup'};
  options.data_patterns = {'ld'};

elseif (strcmp(options.cal_mode, 'Z_only'))
  % Z rotation only, use defaults instead of base calibration,
  options.sensor_fixtures = options.sensor_fixtures(1);
  options.source_fixtures = options.source_fixtures(1);
  % If we only have Rz data, then we can't identify the Z component of the
  % sensor fixture (as distinct from the source Z fixture).
  options.freeze = {options.freeze{:} 'z_se_fix'};

elseif (strcmp(options.cal_mode, 'XYZ'))
  % Dipole calibration with all sensor fixtures, but single source fixture.
  options.source_fixtures = options.source_fixtures(1);

elseif (strcmp(options.cal_mode, 'XYZ_all'))
  % Dipole calibration with all source and sensor fixtures.n
  options.optimize = cat(2, {'so_fix'}, options.optimize);

elseif (strcmp(options.cal_mode, 'so_quadrupole'))
  % Preliminary optimization of source quadrupole parameters, without changing
  % sensor paramters.
  % ### not clear the 'source' pattern is a good idea, even with quadrupole.
  options.data_patterns = {'source'};
  options.optimize = {'q_so_mo' 'so_fix' 'st_fix' 'd_so_pos' 'd_so_mo'};
  options.freeze = {'d_se_z_gain' 'd_so_y_co' 'd_se_y_co'};
  options.correct_mode = 'none';
  %options.iterations = 50;
  if (~options.pin_quadrupole)
    options.optimize = cat(2, {'q_so_pos'}, options.optimize);
  end

elseif (strcmp(options.cal_mode, 'so_quadrupole_reopt')) 
  % Reoptimize sensor parameters in source quadrupole optimization, while
  % holding source fixed, using single source fixture.
  options.optimize = {'d_se_mo' 'd_se_pos' 'st_fix' 'se_fix'};

elseif (strcmp(options.cal_mode, 'so_quadrupole_all')) 
  % With source quadrupole, optimize source and sensor parameters all together.
  options.data_patterns = {'source', 'md'};
  options.optimize = cat(2, {'so_fix' 'q_so_mo'}, options.optimize);
  if (~options.pin_quadrupole)
    options.optimize = cat(2, {'q_so_pos'}, options.optimize);
  end

elseif (strcmp(options.cal_mode, 'se_quadrupole'))
  % Sensor quadrupole, analogous to source quadrupole.
  options.optimize = {'q_se_mo' 'se_fix' 'd_se_mo'};
  %options.iterations = 50;
  if (~options.pin_quadrupole)
    options.optimize = cat(2, {'q_se_pos'}, options.optimize);
  end

elseif (strcmp(options.cal_mode, 'se_quadrupole_all')) 
  options.optimize = cat(2, {'q_se_mo'}, options.optimize);
  if (~options.pin_quadrupole)
    options.optimize = cat(2, {'q_se_pos'}, options.optimize);
  end

% Optimize just fixture transforms.  A useful preliminary after a change in
% fixturing.
elseif (strcmp(options.cal_mode, 'so_fixture'))
  options.sensor_fixtures = options.sensor_fixtures(1);
  options.optimize = {'so_fix', 'st_fix'};
  options.correct_mode = 'none';
elseif (strcmp(options.cal_mode, 'so_fixture_all'))
  options.optimize = {'so_fix', 'st_fix'};
  options.correct_mode = 'none';
elseif (strcmp(options.cal_mode, 'st_fixture'))
  options.optimize = {'st_fix'};
  options.correct_mode = 'none';
elseif (strcmp(options.cal_mode, 'se_fixture'))
  options.source_fixtures = options.source_fixtures(1);
  options.optimize = {'st_fix', 'se_fix'};
  options.correct_mode = 'none';
end


%%% overrides:

% You can override the cal_mode derived settings by using the key value
% arguments.  You can also use the 'default' cal_mode, which suppresses the
% above cal_mode specific option setting, and then set everything in
% local_cal_options.

for (key_ix = 1:2:(length(key_value) - 1))
  key = key_value{key_ix};
  if (isfield(options, key))
    options.(key) = key_value{key_ix + 1};
  end
end


% This has to be after the keyword overrides in order to be able to specify
% 'concentric' there.  This should be harmless because it makes no sense to
% optimize the position with concentric solution.
if (options.concentric)
  options.optimize = setdiff(options.optimize, {'d_so_pos', 'd_se_pos'});
end


%%% file defaulting:

% If options.in_files is not explicitly specified, then generate input file
% names from the fixtures and patterns.  This is after overrides so that they
% affect the result.
if (isempty(options.in_files))
  ifiles = {};
  for (so_ix = 1:length(options.source_fixtures))
    for (se_ix = 1:length(options.sensor_fixtures))
      for (p_ix = 1:length(options.data_patterns))
        ifile = [options.source_fixtures{so_ix} '_' ...
                 options.sensor_fixtures{se_ix} '_' ...
                 options.data_patterns{p_ix} ...
                 '.dat'];
        if (exist(ifile, 'file'))
          ifiles{end+1} = ifile;
        else
          %fprintf(1, 'File does not exist: %s\n', ifile);
        end
      end
    end
  end
  if (isempty(ifiles))
    error('No input files found?');
  end
  options.in_files = ifiles;
end

% out_file: calibration output .mat file name
if (isempty(options.out_file))
  wot = options.cal_mode;
  if (options.concentric)
    wot = [wot '_concentric'];
  end
  if (options.ishigh)
    rate = 'hr';
  else
    rate = 'lr';
  end
  options.out_file = ['output' filesep wot '_' rate '_cal'];
end

path = fileparts(options.out_file);
if (~isempty(path) && ~exist(path, 'dir'))
  mkdir(path);
end
