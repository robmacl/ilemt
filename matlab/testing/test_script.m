diary test_output.txt;
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
    'reports', {'overall'}
    };


% test_options.m in the calibration data directory decides what calibrations
% and tests to run.
run test_options.m;


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
  for (var_ix = 1:length(cp_variants))
    cp_results {cal_ix, var_ix} = ...
        check_poses('cal_file', cp_runs{cal_ix}{:}, ...
                    'variant', cp_variants{var_ix, 1}, ...
                    cp_variants{var_ix, 2}{:}, ...
                    cp_opts{:});
  end
end

oa_fields = fieldnames(cp_results{1,1}.overall);
for (ix = 1:length(oa_fields))
  fname = oa_fields{ix};
  wot = array2table(cellfun(@(x)x.overall.(fname), cp_results));
  wot.Properties.RowNames = cellfun(@(x) x{1}, cp_runs, 'uniformoutput', false);
  wot.Properties.VariableNames = cp_variants(:,1)';
  fprintf('\n%s:\n', fname);
  disp(wot);
end

diary off;
