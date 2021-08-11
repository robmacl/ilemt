function perr_workspace_vol(perr, options)
% 3D plot of error vectors
  %figure(options.figure_base + 3);
  figure();
  errors = perr.errors;
  desired = perr.desired;

  subplot(2, 2, 1);
  % trans->trans error
  perr_wv1(perr, options, desired(:, 1:3), errors(:, 1:3), ...
           options.xyz_exaggerate(1), 'trans->trans', 'm/m');
  
  subplot(2, 2, 2);
  % rot->trans error
  perr_wv1(perr, options, desired(:, 4:6), errors(:, 1:3), ...
           options.xyz_exaggerate(2), 'rot->trans', 'm/rad');
  
  subplot(2, 2, 3);
  % trans->rot error
  perr_wv1(perr, options, desired(:, 1:3), errors(:, 4:6), ...
           options.xyz_exaggerate(3), 'trans->rot', 'rad/m');
  
  subplot(2, 2, 4);
  % rot->rot error
  perr_wv1(perr, options, desired(:, 4:6), errors(:, 4:6), ...
           options.xyz_exaggerate(4), 'rot->rot', 'rad/rad');

  set_fig_name(options);
end

function perr_wv1 (perr, options, desired, errors, exaggerate, what, unit);
  
  ex_xyz = errors(:, 1:3) * exaggerate + desired(:, 1:3);

  plot3(desired(:,1),desired(:,2),desired(:,3),'ko', ...
	[ex_xyz(:,1) desired(:,1)]', ...
	[ex_xyz(:,2) desired(:,2)]', ...
	[ex_xyz(:,3) desired(:,3)]', 'r.-', ...
	'LineWidth', 2);
  grid on;
  daspect([1,1,1]);
  xlabel('x');
  ylabel('y');
  zlabel('z');
  title(sprintf('%s errors (%s %dX)', what, unit, exaggerate));
end
