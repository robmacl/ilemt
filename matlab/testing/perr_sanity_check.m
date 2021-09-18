function [] = perr_sanity_check (perr, options)
% Check if any particular files have excess error.  This can be caused by
% errors during data collection (bad fixture position or sign calibration).

werr = weighted_error(perr, options);

for (f_ix = 1:length(perr.in_files))
  f_err = werr(f_ix == perr.file_map, :);
  rms = sqrt(sum(sum(f_err.^2)) / size(f_err, 1));
  if (rms > options.error_threshold)
    fprintf(1, '%s: excess error %.3g m RMS\n', perr.in_files{f_ix}, rms);
  end
end
