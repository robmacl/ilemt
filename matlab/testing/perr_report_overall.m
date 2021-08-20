function [res] = perr_report_overall (perr)
% Summary statistics of error.

  % Vector magnitude of translation and rotation error at each point.
  trans_err_mag = sqrt(sum(perr.errors(:, 1:3).^2, 2));
  rot_err_mag = sqrt(sum(perr.errors(:, 4:6).^2, 2));
  res.trans_rms = sqrt(mean(trans_err_mag.^2));
  res.trans_max = max(trans_err_mag);
  res.rot_rms = sqrt(mean(rot_err_mag.^2));
  res.rot_max = max(abs(rot_err_mag));
  fprintf(1, 'Position error (m): %.2e RMS, %.2e max.\n', ...
	  res.trans_rms, res.trans_max);
  fprintf(1, 'Orientation error (radians): %.2e RMS, %.2e max\n', ...
          res.rot_rms, res.rot_max);

  %trans_err_rms = sqrt(mean(perr.errors(:, 1:3).^2))
  %rot_err_rms = sqrt(mean(perr.errors(:, 4:6).^2))
end
