function [transform] = linear_correction(perr, cp_options, cal_options)
% Find a linear transform that minimizes the pose error

mode = cal_options.correct_mode;

if (strcmp(mode, 'none'))
  % We skip writing a corrected calibration if there is no correction
  transform = eye(6);
  return;
elseif (strcmp(mode, 'skew'))
  pd1 = pinv(pad_ones(perr.measured(:, 1:3)));
  tf1 = pd1 * pad_ones(perr.desired(:, 1:3));
  transform = tf1;
elseif (strcmp(mode, 'pose'))
  pd = pinv(perr.measured);
  transform = pd * perr.desired;
else
  error('Unknown correct_mode: %s', mode);
end

%{
% I tried weighting the linear solution by the moment to set the desired
% rotation/translation error tradeoff, but this gives almost exactly the same
% result.  Not sure if this is in worthless in general, or if in this case
% there is just really no conflict between the rotation and translation
% corrections.
moment_trans = diag([ones(1,3) ones(1,3)*cp_options.moment]);
pd_new = pinv(perr.measured * moment_trans);
transform_new = pd_new * (perr.desired * moment_trans);
tf_new1 = moment_trans * transform_new * inv(moment_trans)
%}

calibration = load(cp_options.cal_file);
calibration.linear_correction = transform;
[~, name, ext] = fileparts(cp_options.cal_file);
ofile = [name '_' mode '_corrected' ext];
save(ofile, '-struct', 'calibration');
fprintf(1, 'Wrote %s\n', ofile);
