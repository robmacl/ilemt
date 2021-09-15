function [fout] = perr_overall_stats ()
load('output/test_results');

% String calibration file and variant names.
cal_files = {};
variants = {};

% overall stats
% overall(cal_ix, metrics 1:4, var_ix)

% Convert units to mm/degrees
unit_convert = [1e3 1e3 180/pi 180/pi];

for (cal_ix = 1:size(cp_results, 1))
  cal_files{cal_ix, 1} = cp_results(cal_ix, 1).options.cal_file;
  for (var_ix = 1:size(cp_results, 2))
    metrics = struct2array(cp_results(cal_ix, var_ix).overall);
    overall(cal_ix, :, var_ix) = metrics .* unit_convert;
  end
end

for (var_ix = 1:size(cp_results, 2))
  variants{1, var_ix} = cp_results(1, var_ix).options.variant;
end

flat_overall = reshape(overall, length(cal_files), []);

% These are set according to the Excel template file.
fout = copy_excel_template('overall_stats.xlsx');
firstcol = 'b';
firstrow = 4;

lastcol = char('b' + size(flat_overall, 2) - 1);
lastrow = firstrow + size(flat_overall, 1) - 1;

xlswrite(fout, flat_overall, 1, ...
         sprintf('%s%d:%s%d', firstcol, firstrow, lastcol, lastrow));
xlswrite(fout, cal_files, 1, ...
         sprintf('a%d:a%d', firstrow, lastrow));

% The title cells are collapsed, so not contiguous, so we write each seperately.
next_ix = firstcol; % Start column of next cell to write
for (var_ix = 1:length(variants))
  % New next_ix, 1+ our end.
  new_ix = char(var_ix*size(overall, 2) + firstcol);
  corners = sprintf('%s1:%s1', next_ix, char(new_ix - 1));
  %keyboard
  % If we write just one string, then it splits it into characters, so
  % write a single element cell.
  xlswrite(fout, variants(var_ix), 1, corners);
  next_ix = new_ix;
end
                   
%{
for (ix = 1:length(metrics))
  fname = metrics{ix};
  wot = array2table(cellfun(@(x)x.overall.(fname), cp_results));
  wot.Properties.RowNames = cellfun(@(x) x{1}, cp_runs, 'uniformoutput', false);
  wot.Properties.VariableNames = cp_variants(:,1)';
  fprintf('\n%s:\n', fname);
  disp(wot);
end
%}
