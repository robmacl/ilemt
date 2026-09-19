function [cal, options] = load_interfere_cal (options)
% Load suitable calibration for interfere_options, selecting according 
% to options.concentric and options.ishigh.  options is updated with pose
% solution options and needs to be used by the caller.

prefix = [options.cal_directory options.cal_file_base];

if (options.concentric)
  prefix = [prefix '_concentric'];
  options.pose_solution = 'kim18';
else
  if (options.ishigh)
    options.concentric_cal_file = [prefix '_concentric_hr_cal'];
  else
    options.concentric_cal_file = [prefix '_concentric_lr_cal'];
  end
  options.pose_solution = 'optimize';
end
   
if (options.ishigh)
  cal = load_cal_file([prefix '_hr_cal']);
else
  cal = load_cal_file([prefix '_lr_cal']);
end
