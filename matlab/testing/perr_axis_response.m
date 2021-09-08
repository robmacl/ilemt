function perr_axis_response (perr, onax, ax, options)
  % Plot error data for a particular axis sweep, given axis index ax.
  oai = onax(ax).on_ax_ix;
  stage_pos = perr.motion_poses(:, 13:18);
  pose_err = [perr.errors(:, 1:3)*1e3, perr.errors(:, 4:6)*(180/pi)];

  figure();
  subplot(2, 1, 1)
  plot(stage_pos(oai, ax), pose_err(oai, 1:3));
  ylabel('Translation error (mm)');
  legend('X', 'Y', 'Z');
  
  subplot(2, 1, 2)
  plot(stage_pos(oai, ax), pose_err(oai, 4:6));
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
