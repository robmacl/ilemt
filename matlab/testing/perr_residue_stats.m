function [overall] = perr_residue_stats(perr, options)
  % Initialize in case we return early (because no data).  This also makes these
  % fields come first. Field order is exploited in perr_overall_stats.
  overall.trans_rms = NaN;
  overall.trans_max = NaN;
  overall.rot_rms = NaN;
  overall.rot_max = NaN;

  resid_s = sort(perr.all_solution_residuals);
  pval = [0.5 0.95];
  vals = resid_s(round(pval * (length(resid_s) - 1)) + 1);
  overall.residue_p50 = vals(1);
  overall.residue_p95 = vals(2);
  overall.residue_max = resid_s(end);
end
