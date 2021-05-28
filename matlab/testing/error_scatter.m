function [] = error_scatter (perr)
  % Vector magnitude of translation and rotation error at each point.
  trans_err_mag = sqrt(sum(perr.errors(:, 1:3).^2, 2));
  rot_err_mag = sqrt(sum(perr.errors(:, 4:6).^2, 2));

  x_type = 'Coupling';
  
  if (strcmp(x_type, 'Coupling'))
    xvals = perr.coupling_norms;
  elseif (strcmp(x_type, 'Distance'))
    xvals = sqrt(sum(perr.desired(:, 1:3).^2, 2));
  else
    error('bad!');
  end
  
  subplot(2, 1, 1);
  scatter(xvals, trans_err_mag);
  ylabel('Error (m RMS)');
  subplot(2, 1, 2);
  scatter(xvals, rot_err_mag);
  ylabel('Error (rad RMS)');
  xlabel(x_type);
