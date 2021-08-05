function [] = set_fig_name (options)
% Set the figure name to help identify plots for this run.
  set(gcf, 'Name', sprintf('%s (%s)', options.cal_file, options.variant));
end
