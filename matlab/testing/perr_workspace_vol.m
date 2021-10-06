function perr_workspace_vol(perr, options)
% 3D plot of error vectors
  figure();
  unit_convert = [1e3 1e3 1e3 180/pi 180/pi 180/pi];
  t_unit = 'mm';
  r_unit = 'degrees';
  errors = perr.errors .* unit_convert;
  desired = perr.desired .* unit_convert;
  exaggerate = options.xyz_exaggerate;
  t_only = isscalar(exaggerate);

  if (t_only)
    unit2 = [];
  else
    unit2 = t_unit;
    subplot(2, 2, 1);
  end
  % trans->trans error
  perr_wv1(perr, options, desired(:, 1:3), errors(:, 1:3), ...
           exaggerate(1), 'trans->trans', t_unit, unit2);
  
  if (~t_only)
    subplot(2, 2, 2);
    % rot->trans error
    perr_wv1(perr, options, desired(:, 4:6), errors(:, 1:3), ...
             exaggerate(2), 'rot->trans', t_unit, r_unit);

    subplot(2, 2, 3);
    % trans->rot error
    perr_wv1(perr, options, desired(:, 1:3), errors(:, 4:6), ...
             exaggerate(3), 'trans->rot', r_unit, t_unit);
    
    subplot(2, 2, 4);
    % rot->rot error
    perr_wv1(perr, options, desired(:, 4:6), errors(:, 4:6), ...
             exaggerate(4), 'rot->rot', r_unit, r_unit);
  end

  set_fig_name(options);
end

function perr_wv1 (perr, options, desired, errors, exaggerate, what, ...
                   unit1, unit2);
  
  ex_xyz = errors(:, 1:3) * exaggerate + desired(:, 1:3);

  plot3(desired(:,1),desired(:,2),desired(:,3),'ko', ...
	[ex_xyz(:,1) desired(:,1)]', ...
	[ex_xyz(:,2) desired(:,2)]', ...
	[ex_xyz(:,3) desired(:,3)]', 'r.-', ...
        'LineWidth', 1);
  grid on;
  daspect([1,1,1]);
  xlabel(sprintf('x (%s)', unit1));
  ylabel(sprintf('y (%s)', unit1));
  zlabel(sprintf('z (%s)', unit1));
  if (~isempty(unit2))
    title(sprintf('%s errors (%s/%s %dX)', what, unit1, unit2, exaggerate));
  end
end
