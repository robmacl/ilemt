function perr_axis_response (perr, onax, ax)
  % Plot error data for a particular axis sweep, given axis index ax.
  oai = onax(ax).on_ax_ix;

  subplot(2, 1, 1)
  plot(perr.desired_pvec(oai, ax), perr.pose_err(oai, 1:3));
  ylabel('Translation error (um)');
  legend('X', 'Y', 'Z');
  
  subplot(2, 1, 2)
  plot(perr.desired_pvec(oai, ax), perr.pose_err(oai, 4:6));
  anames = {'X', 'Y', 'Z', 'Rx', 'Ry', 'Rz'};
  if (ax >= 4)
    unit = 'degrees';
  else
    unit = 'mm';
  end
  xlabel(sprintf('%s axis position (%s)', anames{ax}, unit));
  ylabel('Orientation error (radians)');
  legend('Rx', 'Ry', 'Rz');
end
