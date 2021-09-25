function [] = error_scatter (perr, options)
% Scatter plot of error vs. distance or coupling magnitude

  % Vector magnitude of translation and rotation error at each point.
  trans_err_mag = sqrt(sum(perr.errors(:, 1:3).^2, 2));
  rot_err_mag = sqrt(sum(perr.errors(:, 4:6).^2, 2));

  x_type = options.scatter_x_axis;
  if (strcmp(x_type, 'coupling'))
    xvals = perr.coupling_norms;
  elseif (strcmp(x_type, 'distance'))
    xvals = sqrt(sum(perr.desired(:, 1:3).^2, 2));
  elseif (strcmp(x_type, 'residual'))
    xvals = perr.solution_residuals;
  else
    error('error_scatter: unknown options.scatter_x_axis: %s', x_type);
  end

  %figure(options.figure_base + 6);
  figure();
  subplot(2, 1, 1);
  scatter(xvals, trans_err_mag);
  ylabel('Error (m RMS)');
  subplot(2, 1, 2);
  scatter(xvals, rot_err_mag);
  ylabel('Error (rad RMS)');
  xlabel(x_type);
  set_fig_name(options);
