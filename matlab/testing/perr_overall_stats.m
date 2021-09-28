function [fout] = perr_overall_stats ()
results = load('output/test_results');

fout = copy_excel_template('overall_stats');


%%% check_poses() results

% String calibration file and variant names.
cal_files = {};
variants = {};

% overall stats
% overall(cal_ix, metrics, var_ix)
clear overall;

% Convert units to mm/degrees
unit_convert = [1e3 1e3 180/pi 180/pi 1 1 1];

for (cal_ix = 1:size(results.cp_results, 1))
  cal_files{cal_ix, 1} = results.cp_results(cal_ix, 1).options.cal_file;
  for (var_ix = 1:size(results.cp_results, 2))
    metrics = struct2array(results.cp_results(cal_ix, var_ix).overall);
    overall(cal_ix, :, var_ix) = metrics .* unit_convert;
  end
end

for (var_ix = 1:size(results.cp_results, 2))
  variants{1, var_ix} = results.cp_results(1, var_ix).options.variant;
end

% Start corners are set according to the Excel template file.  

% Page 1 for check_poses() stats.
write_variants(overall(:, 1:4, :), 1, 'B', 4);

% Spreadsheet page 2
write_variants(overall(:, 5:7, :), 2, 'B', 3);

%{
for (ix = 1:length(metrics))
  fname = metrics{ix};
  wot = array2table(cellfun(@(x)x.overall.(fname), results.cp_results));
  wot.Properties.RowNames = cellfun(@(x) x{1}, cp_runs, 'uniformoutput', false);
  wot.Properties.VariableNames = cp_variants(:,1)';
  fprintf('\n%s:\n', fname);
  disp(wot);
end
%}


%%% calibration statistics
% 
% spreadsheet page 3

% Calibration output files
cal_names = {};

% Statistics table
cal_stats = zeros(length(results.cal_results), 5);

for (cal_ix = 1:length(results.cal_results))
  cal1 = results.cal_results{cal_ix};
  stats = cal1.calibration.stats;
  cal_names{cal_ix, 1} = cal1.options.out_file;
  cal_stats(cal_ix, 1) = stats.rms_residue;
  cal_stats(cal_ix, 2) = stats.num_points;
  cal_stats(cal_ix, 3) = stats.num_invalid;
  % Convert to mm
  cal_stats(cal_ix, 4) = stats.uncorrected * 1e3;
  cal_stats(cal_ix, 5) = stats.corrected * 1e3;
end


% These are set according to the Excel template file.  Page 3 for cal stats.
firstcol = 'B';
firstrow = 2;
cal_sheet = 3;

lastcol = excel_column('B', size(cal_stats, 2) - 1);
lastrow = firstrow + size(cal_stats, 1) - 1;

xlswrite(fout, cal_names, cal_sheet, ...
         sprintf('A2:A%d', lastrow));
xlswrite(fout, cal_stats, cal_sheet, ...
         sprintf('%s%d:%s%d', firstcol, firstrow, lastcol, lastrow));



function [] = write_variants (stats, sheet, firstcol, firstrow)
  flat_stats = reshape(stats, length(cal_files), []);

  lastcol = excel_column(firstcol, size(flat_stats, 2) - 1);
  lastrow = firstrow + size(flat_stats, 1) - 1;

  xlswrite(fout, flat_stats, sheet, ...
           sprintf('%s%d:%s%d', firstcol, firstrow, lastcol, lastrow));
  xlswrite(fout, cal_files, sheet, ...
           sprintf('a%d:a%d', firstrow, lastrow));

  % The title cells are collapsed, so not contiguous, so we write each seperately.
  next_ix = firstcol; % Start column of next cell to write
  for (var_ix = 1:length(variants))
    % New next_ix, 1+ our end.
    new_offset = var_ix*size(stats, 2);
    new_ix = excel_column(firstcol, new_offset);
    corners = sprintf('%s1:%s1', next_ix, excel_column(firstcol, new_offset - 1));
    %keyboard
    % If we write just one string, then it splits it into characters, so
    % write a single element cell.
    xlswrite(fout, variants(var_ix), sheet, corners);
    next_ix = new_ix;
  end
end

end % perr_overall_stats

