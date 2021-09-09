function [inl, dnl] = perr_axis_stats (perr, onax, options)
% Write summary axis sweep statistics to an excel table.

  on_axis_kind;
  % First dim is kind * rms_max, ie. rows interleaved for RMS and max, for
  % each kind.  Second is the axis.
  inl = zeros(onax_num_kinds*2, 6);
  dnl = zeros(onax_num_kinds*2, 6);
  
  % Assumes data directory is the working directory
  in_path = fileparts(which('perr_axis_stats'));
  fbase = 'check_poses.xlsx';
  fout = [pwd filesep fbase];
  fin = [in_path filesep fbase];
  copyfile(fin, fout);
  
  for (ax_ix = 1:6)
    if (isempty(onax(ax_ix).on_ax_ix))
      continue;
    end
    for (kind_ix = 1:onax_num_kinds)
      for (rms_mav_ix = 1:2)
	inl((kind_ix - 1)*2 + rms_mav_ix, ax_ix) = ...
	  onax(ax_ix).stats(kind_ix, 1, rms_mav_ix);
	dnl((kind_ix - 1)*2 + rms_mav_ix, ax_ix) = ...
	  onax(ax_ix).stats(kind_ix, 2, rms_mav_ix);
      end
    end
  end

  % What kinds to write in Sheet 1-2 tables.
  kix_kinds = [onax_on_axis onax_other_axes onax_same_axes onax_cross];
  % Indices in inl/dnl after rms/max interleave
  kix_indices = reshape(cat(1, kix_kinds*2-1, kix_kinds*2), [], 1);

  xlswrite(fout, inl(kix_indices, :), 1, 'c4:h11');
  xlswrite(fout, dnl(kix_indices, :), 1, 'c18:h25');

  % Sheet 2 is a more compact single table that pools some results across axes
  % using max (across axes).  So as well as max of per-axis max we are also
  % taking max of per-axis RMS.  This is perhaps reasonable since we are only
  % sweeping one axis at a time.  We are implicitly using the stage axes a
  % sample of what we might see across a variety of lines.  It would not make
  % sense to use the vector magnitude since that would be summing off-axis
  % terms across multiple lines.  We could take the actual root-MEAN-square
  % across the axes, but using max is strictly greater, so is anyway
  % conservative.  Probably a rationalization for what is slightly easier
  % to code, since max and RMS are interleaved...
  inldnl = zeros(length(kix_indices), 6);

  % Fill in by columns of interleaved RMS/max
  inldnl(:, 1) = max(inl(kix_indices, 1:3), [], 2); % XYZ INL
  inldnl(:, 2) = max(inl(kix_indices, 4:6), [], 2); % RzRyRz
  inldnl(:, 3) = max(dnl(kix_indices, 1:3), [], 2); % XYZ DNL
  inldnl(:, 4) = max(dnl(kix_indices, 4:6), [], 2); % RzRyRz

  xlswrite(fout, inldnl, 2, 'c4:f11');
  
  % Sheet 3 is defined in excel as being a subset of the rows in sheet 2.
  
  fprintf(1, 'Wrote %s\n', fout);
end
