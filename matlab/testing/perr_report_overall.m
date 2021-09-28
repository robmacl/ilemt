function [overall] = perr_report_overall (perr, options, overall)
% Summary statistics of error.

  % Vector magnitude of translation and rotation error at each point.
  trans_err_mag = sqrt(sum(perr.errors(:, 1:3).^2, 2));
  rot_err_mag = sqrt(sum(perr.errors(:, 4:6).^2, 2));
  overall.trans_rms = sqrt(mean(trans_err_mag.^2));
  overall.trans_max = max(trans_err_mag);
  overall.rot_rms = sqrt(mean(rot_err_mag.^2));
  overall.rot_max = max(abs(rot_err_mag));

  if (any(strcmp(options.reports, 'overall')))
    fprintf(1, 'Position error (m): %.2e RMS, %.2e max.\n', ...
            overall.trans_rms, overall.trans_max);
    fprintf(1, 'Orientation error (radians): %.2e RMS, %.2e max\n', ...
            overall.rot_rms, overall.rot_max);
  end
end
