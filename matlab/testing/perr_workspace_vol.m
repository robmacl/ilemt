function perr_workspace_vol(perr, options)
% 3D plot of 
  figure(1);
  %set(gca, 'FontSize', 20, 'LineWidth', 2);
  errors = perr.errors;
  desired = perr.desired;
    
  if (options.stage_coords)
    so_fix_t = pose2trans(perr.so_fix);
    se_fix_t = pose2trans(perr.se_fix);
    
    measured = perr.measured;
    for (ix = 1:size(measured, 1))
      measured_t = pose2trans(measured(ix, :));
      desired_t = pose2trans(desired(ix,:));
      desired_stage = inv(se_fix_t * inv(desired_t) * so_fix_t);
      measured_stage = inv(se_fix_t * inv(measured_t) * so_fix_t);
      err_stage = inv(desired_stage) * measured_stage;
      desired(ix, :) = trans2pose(desired_stage);
      errors(ix, :) = trans2pose(err_stage);
    end
  end
  subplot(1, 2, 1);
  % trans->trans error
  perr_wv1(perr, options, desired(:, 1:3), errors(:, 1:3), ...
           options.xyz_exaggerate, 'trans->trans', 'm/m');
  
  subplot(1, 2, 2);
  % rot->trans error
  perr_wv1(perr, options, desired(:, 4:6), errors(:, 1:3), ...
           options.rot_xyz_exaggerate, 'rot->trans', 'm/rad');

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
