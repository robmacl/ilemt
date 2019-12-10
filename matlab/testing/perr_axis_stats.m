function perr_axis_plot (data_name, perr, onax, options)
  inl = zeros(8, 6);
  dnl = zeros(8, 6);
  [pathstr, name, ext] = fileparts(data_name);
  fout = [pathstr '\' name '.xlsx'];
  copyfile('check_poses.xlsx', fout);
  % Swap 3'rd and 4'th kind (cross and to-z).
  kix_perm = [0 1 3 2];
  for (ax_ix = 1:6)
    for (kind_ix = 1:4)
      for (rms_mav_ix = 1:2)
	inl(kix_perm(kind_ix)*2 + rms_mav_ix, ax_ix) = ...
	  onax(ax_ix).stats(kind_ix, 1, rms_mav_ix);
	dnl(kix_perm(kind_ix)*2 + rms_mav_ix, ax_ix) = ...
	  onax(ax_ix).stats(kind_ix, 2, rms_mav_ix);
      end
    end
  end
  xlswrite(fout, inl, 1, 'c4:h11');
  xlswrite(fout, dnl, 1, 'c16:h23');

  inldnl = zeros(8, 6);
  inldnl(:, 1) = max(inl(:, 1:3), [], 2);
  inldnl(:, 2) = max(inl(:, 4:5), [], 2);
  inldnl(:, 3) = inl(:, 6);
  inldnl(:, 4) = max(dnl(:, 1:3), [], 2);
  inldnl(:, 5) = max(dnl(:, 4:5), [], 2);
  inldnl(:, 6) = dnl(:, 6);

  xlswrite(fout, inldnl, 2, 'c4:h11');
end
