function perr_workspace_vol(perr, options)
  figure(1);
  %set(gca, 'FontSize', 20, 'LineWidth', 2);

  ex_xyz = perr.errors(:, 1:3) * options.xyz_exaggerate ...
    + perr.desired(:, 1:3);

  plot3(perr.desired(:,1),perr.desired(:,2),perr.desired(:,3),'ko', ...
	[ex_xyz(:,1) perr.desired(:,1)]', ...
	[ex_xyz(:,2) perr.desired(:,2)]', ...
	[ex_xyz(:,3) perr.desired(:,3)]', 'r.-', ...
	'LineWidth', 2);

  set(gcf, 'Name', ...
	   sprintf('XYZ errors (%dX)', options.xyz_exaggerate));
  grid on;
  daspect([1,1,1]);
  xlabel('x');
  ylabel('y');
  zlabel('z');
end
