function perr_axis_stats (perr, onax, options)
% Write summary axis sweep statistics to an excel table.

  % First dim is kind * rms_max, ie. rows interleaved for RMS and max, for
  % each kind.  Second is the axis.
  inl = zeros(10, 6);
  dnl = zeros(10, 6);
  % Rows used in page 1 and 2 reports;
  old_slice = [1:8];
  
  % Assumes data directory is the working directory
  in_path = fileparts(which('perr_axis_stats'));
  fbase = 'check_poses.xlsx';
  fout = [pwd filesep fbase];
  fin = [in_path filesep fbase];
  copyfile(fin, fout);
  
  % Swap 3'rd and 4'th kind (cross and to-z).
  kix_perm = [0 1 3 2 4];
  for (ax_ix = 1:6)
    if (isempty(onax(ax_ix).on_ax_ix))
      continue;
    end
    for (kind_ix = 1:5)
      for (rms_mav_ix = 1:2)
	inl(kix_perm(kind_ix)*2 + rms_mav_ix, ax_ix) = ...
	  onax(ax_ix).stats(kind_ix, 1, rms_mav_ix);
	dnl(kix_perm(kind_ix)*2 + rms_mav_ix, ax_ix) = ...
	  onax(ax_ix).stats(kind_ix, 2, rms_mav_ix);
      end
    end
  end
  xlswrite(fout, inl(old_slice, :), 1, 'c4:h11');
  xlswrite(fout, dnl(old_slice, :), 1, 'c16:h23');

  % Sheet 2 is a more compact single table that pools some results across
  % axes using max (across axes).
  inldnl = zeros(8, 6);
  inldnl(:, 1) = max(inl(old_slice, 1:3), [], 2);
  inldnl(:, 2) = max(inl(old_slice, 4:5), [], 2);
  inldnl(:, 3) = inl(old_slice, 6);
  inldnl(:, 4) = max(dnl(old_slice, 1:3), [], 2);
  inldnl(:, 5) = max(dnl(old_slice, 4:5), [], 2);
  inldnl(:, 6) = dnl(old_slice, 6);

  xlswrite(fout, inldnl, 2, 'c4:h11');
  
  % Sheet 3 is even more compact, dropping on-axis vs. off-axis, and the Rz
  % special case.
  combo = zeros(4, 4);
  
  % Use only kinds 5 (total same type) and 2 (total cross type), with the
  % RMS/max row interleave.
  kind_ixs = [5*2-1 5*2 2*2-1 2*2];

  % Translation INL
  combo(:, 1) = max(inl(kind_ixs, 1:3), [], 2);
  
  % Rotation INL
  combo(:, 2) = max(inl(kind_ixs, 4:6), [], 2);  

  % Translation DNL
  combo(:, 3) = max(dnl(kind_ixs, 1:3), [], 2);
  
  % Rotation DNL
  combo(:, 4) = max(dnl(kind_ixs, 4:6), [], 2);  

  xlswrite(fout, combo, 3, 'c4:f7');
  
  fprintf(1, 'Wrote %s\n', fout);
end
