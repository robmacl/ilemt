options = interfere_options();

prefix = [options.cal_directory options.cal_file_base];

if (options.ishigh)
  options.concentric_cal_file = [prefix '_concentric_hr_cal'];
  cal = load_cal_file([prefix '_hr_cal']);
else
  options.concentric_cal_file = [prefix '_concentric_lr_cal'];
  cal = load_cal_file([prefix '_lr_cal']);
end

[~, couplings] = read_cal_data(options);
[poses, valid, resnorms] = pose_solution(couplings, cal, options);
