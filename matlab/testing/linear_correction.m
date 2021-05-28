function [transform] = linear_correction(perr, options)
% Find a linear transform that minimizes the pose error

pd = pinv(perr.measured);
transform = pd * perr.desired;

calibration = load(options.cal_file);
calibration.linear_correction = transform;
[~, name, ext] = fileparts(options.cal_file);
ofile = [name '_corrected' ext];
save(ofile, '-struct', 'calibration');
fprintf(1, 'Wrote %s\n', ofile);
