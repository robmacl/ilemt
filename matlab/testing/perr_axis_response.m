function perr_axis_response (perr, onax, ax, options)
  % Plot error data for a particular axis sweep, given axis index ax.
  oai = onax(ax).on_ax_ix;

  %figure(options.figure_base + 10 + ax);
  figure();
  subplot(2, 1, 1)
  plot(perr.stage_pos(oai, ax), perr.stage_pos_errors(oai, 1:3));
  ylabel('Translation error (mm)');
  legend('X', 'Y', 'Z');
  
  subplot(2, 1, 2)
  plot(perr.stage_pos(oai, ax), perr.stage_pos_errors(oai, 4:6));
  anames = {'X', 'Y', 'Z', 'Rx', 'Ry', 'Rz'};
  if (ax >= 4)
    unit = 'degrees';
  else
    unit = 'mm';
  end
  xlabel(sprintf('%s axis position (%s)', anames{ax}, unit));
  ylabel('Orientation error (degrees)');
  legend('Rx', 'Ry', 'Rz');
  set_fig_name(options);
end
