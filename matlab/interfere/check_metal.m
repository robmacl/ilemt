options = interfere_options();
options.in_files = {'output_file.dat'}


% lookup = {
%     'thing i map from', 'thing I map to'
%     'another thing', 'other'
% }
%        
    

prefix = [options.cal_directory options.cal_file_base];

if (options.ishigh)
  options.concentric_cal_file = [prefix '_concentric_hr_cal'];
  cal = load_cal_file([prefix '_hr_cal']);
else
  options.concentric_cal_file = [prefix '_concentric_lr_cal'];
  cal = load_cal_file([prefix '_lr_cal']);
end

[motion, couplings] = read_cal_data(options);
[poses, valid] = pose_solution(couplings, cal, options);

%pose_difference(
