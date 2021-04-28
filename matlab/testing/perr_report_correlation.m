function [res] = perr_report_correlation (perr)
% This finds some kind of correlation between the pose errors and the stage
% position.  There is probably a more standard or better way to do this
% (linear regression?), but this shows something about the influence of stage
% axis motion on the measured pose elements.  I don't have a quantitative
% interpretation for the result, but the larger magnitude elements are for
% axes of motion which create more error.

% We use stage position rather than 'desired' because it doesn't wrap
% angles due fixture transform effects.
% ### this is confusing because the stage is rotated 90 degrees wrt. source
% and sensor coordinates.
npoints = size(perr.stage_pos, 1);
stage_scale = [ones(1, 3) * 1e-3, ones(1, 3) * pi/360];
sp_conv = perr.stage_pos .* (repmat(stage_scale, npoints, 1));
                                   
cov1 = cov([sp_conv perr.errors]);
res = cov1(1:6, 7:12);
colname = {'Err X' 'Err Y' 'Err Z' 'Err Rx' 'Err Ry' 'Err Rz'};
rowname = {'Stage X' 'Stage Y' 'Stage Z' 'Stage Rx' 'Stage Ry' 'Stage Rz'};
res_t = array2table(res, 'VariableNames', colname, 'RowNames', rowname);
fprintf(1, 'Stage to error correlation (meters, radians):\n');
disp(res_t);

db_t = array2table(log10(abs(res))*10, 'VariableNames', colname, 'RowNames', rowname);
fprintf(1, 'Stage to error correlation, as dB:\n');
disp(db_t);
