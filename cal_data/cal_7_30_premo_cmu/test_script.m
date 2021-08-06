diary test_output.txt;
disp ________________________________________________________________
disp(datetime);


%%% Calibration runs:

% {cal_mode base_calibration option*}
cal_runs = {
    {'XYZ', 'base_calibration'}
    {'XYZ_all', 'XYZ_hr_cal'}
    {'so_quadrupole', 'XYZ_hr_cal'}
%{'so_quadrupole_reopt', 'so_quadrupole_hr_cal'}
    {'so_quadrupole_all', 'so_quadrupole_hr_cal'}
    {'XYZ' 'base_calibration', 'concentric', true}
    {'XYZ_all', 'XYZ_all_concentric_hr_cal', 'concentric', true}
    };

cal_opts = {'verbose', 1};

clear cal_results;
for (cal_ix = 1:length(cal_runs))
  [cal, options] = ...
      calibrate_main(cal_runs{cal_ix}{1}, ...
                     'base_calibration', cal_runs{cal_ix}{2}, ...
                     cal_opts{:});
  res1.calibration = cal;
  res1.options = options;
  cal_results{cal_ix} = res1;
end


%%% Calibration testing with check_poses()

% cp_runs{:, 1} is the cal_file
% cp_runs(:, 2:end} are additional options
%{'so_quadrupole_reopt_hr_cal'}
cp_runs = {
    {'XYZ_hr_cal'}
    {'XYZ_all_hr_cal', 'linear_correction', false}
    {'so_quadrupole_hr_cal'}
    {'so_quadrupole_all_hr_cal', 'linear_correction', false}
    {'XYZ_concentric_hr_cal', 'pose_solution', 'kim18'}
    {'XYZ_all_concentric_hr_cal', 'linear_correction', false}
    };

% Options for all check_poses() runs.n
cp_opts = {
    'reports', {'overall'}
    };

% Variants are different options that we test on each run.
cp_variants = {
    'default' {}
    'source fix' {'source_fixtures', {'soYoutZup' 'soXoutZup' 'soZoutYup' 'soXinYup'}}
    };

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

diary off;
