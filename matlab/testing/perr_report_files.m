function [summary] =  perr_report_files(perr, options, res)
drift = res.overall.drift;
m_err = res.overall.moment_error;
files = perr.in_files;

for (ix = 1:length(files))
  summary(ix).file = string(files{ix});
  summary(ix).drift = drift(ix);
  summary(ix).moment_error = m_err(ix);
end

disp(struct2table(summary));
