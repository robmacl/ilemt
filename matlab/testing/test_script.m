diary output/test_output.txt;
disp ________________________________________________________________
fprintf(1, 'Test start: ');
disp(datetime);


% Some defaults for test options.  See a test_options.m script for the format.
cal_runs = {};
cal_opts = {'verbose', 1};
cp_runs = {};

cp_variants = {
    'default' {}
    };

cp_opts = {
    'reports', {'overall', 'bias'}
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

if (~exist('cal_results', 'var'))
  cal_results = [];
end

if (~exist('cp_results', 'var'))
  cp_results = [];
end

save('output/test_results', 'cal_results', 'cp_results');

perr_overall_stats();
