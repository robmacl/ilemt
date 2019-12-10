function perr_report_overall (perr)
  trans_err_mag = sqrt(sum(perr.pose_err(:, 1:3).^2, 2));
  rot_err_mag = sqrt(sum(perr.pose_err(:, 4:6).^2, 2));
  
  fprintf(1, 'Position error (microns): %.0f RMS, %.0f max.\n', ...
	  sqrt(mean(trans_err_mag.^2)), max(trans_err_mag));

  fprintf(1, 'Orientation error (radians): %.2e RMS, %.2e max\n', ...
	  sqrt(mean(rot_err_mag.^2)), max(abs(rot_err_mag)));

  trans_err_rms = sqrt(mean(perr.pose_err(:, 1:3).^2))
  rot_err_rms = sqrt(mean(perr.pose_err(:, 4:6).^2))
end
