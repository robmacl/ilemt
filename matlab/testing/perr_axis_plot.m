function perr_axis_plot (perr, onax, options)

  ax_names = {'X', 'Y', 'Z', 'Rx', 'Ry', 'Rz'};

  % Handles to all our our axes, 2 figures x 3x3 subplots x left and right axes.
  axes_h = zeros(2, 3, 3, 2);

  % Ranges of Y values, so we can force Y scales the same.  (fig, row, lr_ax)
  max_abs_y = zeros(2, 3, 2);

  for (ax = 1:6)
    if (ax >= 4)
      unit = 'degrees';
      xunit = 'mm';
      col = ax - 3;
      if (ax == 4)
        figure();
      end
      fig_ix = 2;
    else
      unit = 'mm';
      xunit = 'degrees';
      col = ax;
      if (ax == 1)
        figure();
      end
      fig_ix = 1;
    end
    set_fig_name(options);

    if (isempty(onax(ax).on_ax_ix))
      continue;
    end

    x = onax(ax).x;

    % left and right ylabels in plotyy
    lylabel = {sprintf('On axis INL (%s)', unit), ...
	      sprintf('Off axis INL (%s)', unit), ...
	      sprintf('Cross INL (%s)', xunit)};
    rylabel = {sprintf('On axis DNL (%% of %s)', unit), ...
               sprintf('Off axis DNL (%% of %s)', unit), ...
               sprintf('Cross DNL (%s/%s)', xunit, unit)};

    % Row in subplot is kind of err (on-axis, off-axis, cross.)
    for (row = 1:3)
      subplot(3, 3, (row-1)*3+col);
      ryscale = 100; %Scaling of right y axis (percent)
      if (row == 3)
        ryscale = 1;
      end
      lydata = squeeze(onax(ax).err(row, :, 1));
      rydata = squeeze(onax(ax).err(row, :, 2))*ryscale;
      ah = plotyy(x, lydata, x, rydata);
      axes_h(fig_ix, row, col, :) = ah;
      max_abs_y(fig_ix, row, :) = ...
        max([squeeze(max_abs_y(fig_ix, row, :))'
	    max(abs(lydata)) max(abs(rydata))]);
      if (col == 1)
	ylabel(ah(1), lylabel{row})
      elseif (col == 3)
	ylabel(ah(2), rylabel{row})	     
      end
      if (row == 3)
	xlabel(ah(1), sprintf('%s position (%s)', ax_names{ax}, unit))
      end
    end
  end
  for (fx = 1:2)
    % ### Seems a given axes can only participate in one linking, so we
    % have to choose to link X or Y.  I choose X.
    % Link all X axes in each column
    for (col = 1:3)
      axes1 = squeeze(axes_h(fx, :, col, :));
      axes1(axes1 == 0) = [];
      if (~isempty(axes1))
        linkaxes(axes1, 'x');
      end
    end
    % Force left Y axes to have the same scale, and ditto for right.
    for (row = 1:3)
      for (col = 1:3)
	for (lr = 1:2)
          h1 = axes_h(fx, row, col, lr);
          if (h1 == 0)
            continue;
          end
	  may = max_abs_y(fx, row, lr);
	  if (row == 1)
	    yl = [-may may];
	  else
	    yl = [0 may];		
          end
	  ylim(h1, yl);
	end
      end
    end
  end
	
  if (false)
    [x0, dir] = ls3dline(measured_ax(:, same_ax));
  end
end
