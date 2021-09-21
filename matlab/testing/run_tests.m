function [cal_results, cp_results] = run_tests (clean)
% Run calibrate_main() and check_poses() on the current directory.  
% If clean is true then we delete output/{*.mat,*.xlsx} and truncate
% output/test_output.txt

if (nargin < 1)
  clean = false;
end

if (~exist('output', 'file'))
  mkdir output;
elseif (clean)
  % This may be necessary to be able to delete the old diary file.
  diary off;
  fclose all;
  % Truncate the file rather than deleting it, matlab tends to keep it open
  % so deleting or renaming doesn't work.
  fid = fopen('output/test_output.txt', 'w');
  if (fid > 0)
    fclose(fid);
  end

  delete('output/*.mat');
  delete('output/*.xlsx');
end

diary output/test_output.txt;
disp ________________________________________________________________
fprintf(1, 'Test start: ');
disp(datetime);


% Some defaults for test options.  See a test_options.m script for the format.
cal_runs = {};
cal_opts = {'verbose', 1, 'force', false};
cp_runs = {};

cp_variants = {
    'default' {}
    };

cp_opts = {
    'reports', {'overall'}
    };


% local_test_options.m in the calibration data directory decides what
% calibrations and tests to run.
run local_test_options.m;


%%% Calibration runs:

clear cal_results;
for (cal_ix = 1:length(cal_runs))
  [cal, options] = ...
       calibrate_main(cal_runs{cal_ix}{1}, ...
                     'base_calibration', cal_runs{cal_ix}{2:end}, ...
                     cal_opts{:});
  res1.calibration = cal;
  res1.options = options;
  cal_results{cal_ix} = res1;
end


%%% Calibration testing with check_poses()

clear cp_results;
for (cal_ix = 1:length(cp_runs))
  for (var_ix = 1:size(cp_variants, 1))
    cp_results(cal_ix, var_ix) = ...
        check_poses('cal_file', cp_runs{cal_ix}{:}, ...
                    'variant', cp_variants{var_ix, 1}, ...
                    cp_variants{var_ix, 2}{:}, ...
                    cp_opts{:});
  end
end

diary off;

if (~exist('cal_results', 'var'))
  cal_results = [];
end

if (~exist('cp_results', 'var'))
  cp_results = [];
end

save('output/test_results', 'cal_results', 'cp_results');

perr_overall_stats();