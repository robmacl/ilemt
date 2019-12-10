function workspace_vol(perr, options)
  figure(1);
  set(gca, 'FontSize', 20, 'LineWidth', 2);
  xyz_exaggeration = 100; % increase matching error by this factor.
  ex_xyz = perr.pose_err(:, 1:3) * options.xyz_exaggerate ...
    + perr.desired_pvec(:, 1:3) * 1e3;

  % Convert back into ASAP coords.
  F_inv = inv(perr.F)';
  ex_xyz = pad_ones(ex_xyz) * F_inv;
  s_xyz_desired = pad_ones(perr.desired_pvec(:, 1:3) * 1e3) * F_inv;

  [points,xs,ys,zs] = workspace_volume();
  % Scale to cm
  ex_xyz = ex_xyz * 1e-4;
  s_xyz_desired = s_xyz_desired * 1e-4;
  xs = xs * 1e-4;
  ys = ys * 1e-4;
  zs = zs * 1e-4;
  plot3(s_xyz_desired(:,1),s_xyz_desired(:,2),s_xyz_desired(:,3),'ko', ...
	[ex_xyz(:,1) s_xyz_desired(:,1)]', ...
	[ex_xyz(:,2) s_xyz_desired(:,2)]', ...
	[ex_xyz(:,3) s_xyz_desired(:,3)]', 'r.-', ...
	xs, ys, zs, 'b', ... 
	'LineWidth', 2);

  set(gcf, 'Name', ...
	   sprintf('XYZ errors (%dX)', xyz_exaggeration));
  grid on;
  daspect([1,1,1]);
  xlabel('x');
  ylabel('y');
  zlabel('z');
end
