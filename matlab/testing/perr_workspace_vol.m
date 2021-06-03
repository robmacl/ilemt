function perr_workspace_vol(perr, options)

  figure(1);
  %set(gca, 'FontSize', 20, 'LineWidth', 2);
  
  errors = perr.errors(:, 1:3);
  desired = perr.desired(:, 1:3);
  if (options.stage_coords)
    so_fix = pose2trans(perr.so_fix);
    errors = pad_zeros(errors) * so_fix;
    desired = pad_ones(desired) * so_fix;
  end
  
  ex_xyz = errors(:, 1:3) * options.xyz_exaggerate ...
    + desired(:, 1:3);

  plot3(desired(:,1),desired(:,2),desired(:,3),'ko', ...
	[ex_xyz(:,1) desired(:,1)]', ...
	[ex_xyz(:,2) desired(:,2)]', ...
	[ex_xyz(:,3) desired(:,3)]', 'r.-', ...
	'LineWidth', 2);

  set(gcf, 'Name', ...
	   sprintf('XYZ errors (%dX)', options.xyz_exaggerate));
  grid on;
  daspect([1,1,1]);
  xlabel('x');
  ylabel('y');
  zlabel('z');
end
