diary test_output.txt;

%calibrate_main('XYZ', 'base_calibration', 'base_calibration');
%calibrate_main('XYZ_all', 'base_calibration', 'XYZ_hr_cal');
%calibrate_main('so_quadrupole', 'base_calibration', 'XYZ_hr_cal');
%calibrate_main('so_quadrupole_reopt', 'base_calibration', 'so_quadrupole_hr_cal');
%calibrate_main('so_quadrupole_all', 'base_calibration', 'so_quadrupole_hr_cal');

cp_opts = {
    {'XYZ_hr_cal'}
    {'XYZ_all_hr_cal', 'linear_correction', false}
    {'so_quadrupole_hr_cal'}
    {'so_quadrupole_reopt_hr_cal'}
    {'so_quadrupole_all_hr_cal', 'linear_correction', false}
    };

cp_variants = {
    'default' {}
    'source fix' {'source_fixtures', {'soYoutZup' 'soXoutZup' 'soZoutYup' 'soXinYup'}}
    };


for (cal_ix = 1:length(cp_opts))
  for (var_ix = 1:length(cp_variants))
    cp_results {cal_ix, var_ix} = ...
        check_poses('cal_file', cp_opts{cal_ix}{:}, ...
                    'variant', cp_variants{var_ix, 1}, ...
                    cp_variants{var_ix, 2}{:}, ...
                    'reports', {'overall'});
  end
end

diary off;
