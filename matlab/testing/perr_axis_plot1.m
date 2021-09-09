function perr_axis_plot1 (onax, options, ax_names, unit, xunit)
% Do one plot, for just XYZ or RzRyRz
% onax: subsequence of on-axis info for these axes (trans or rot)
% ax_names: names for these axes
% unit: direct coupling unit
% xunit: cross coupling unit

figure;
set_fig_name(options);

% ylabels for each subplot {row, col}
ylabels = {sprintf('On axis (%s)', unit)	sprintf('On axis (%% of %s)', unit)
           sprintf('Direct (%s)', unit)		sprintf('Direct (%% of %s)', unit)
           sprintf('Cross (%s)', xunit)		sprintf('Cross (%s/%s)', xunit, unit)
};

titles = {'Absolute error', 'Nonlinearity'};

on_axis_kind;
% Error kinds for rows
err_kinds = [onax_on_axis onax_same_axes onax_cross];

if (~options.plot_on_axis)
  err_kinds = err_kinds(2:end);
  ylabels = ylabels(2:end, :);
end

num_kinds = length(err_kinds);

% Column is INL/DNL
for (col = 1:2)
  % Row in subplot is kind of err (on-axis, direct, cross.)
  for (row = 1:num_kinds)
    subplot(num_kinds, 2, (row-1)*2+col);
    kix = err_kinds(row);
    if (kix == onax_cross)
      ryscale = 1; % Cross DNL is not percent
    else 
      ryscale = 100; % Scaling of right column (percent)
    end
    leg_names = {}; % legend entries
    for (ax = 1:3)
      if (isempty(onax(ax).on_ax_ix))
        continue;
      end
      % Different axes might have different X values, so do seperate
      % plots.
      x = onax(ax).x;
      ydata = squeeze(onax(ax).err(kix, :, col));
      hold on;
      plot(x, ydata);
      leg_names{end+1} = ax_names{ax};
    end
    hold off;
    if (row == 1 && col == 1);
      legend(leg_names, 'location', 'southwest');
    end
    ylabel(ylabels{row, col});
    if (row == 1)
      title(titles{col});
    end
    if (row == num_kinds)
      xlabel(sprintf('Position (%s)', unit));
    end
  end
end
