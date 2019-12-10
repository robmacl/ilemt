function make_axis_sweep (out_file, ranges, xyz_step, Rxyz_step)
% Generate position sweeps along each axis.  The XXX_rng parameters are:
%   [[min_x max_x]
%    [min_y max_y]
%    [min_z max_z]
%    ... Rxyz etc ...]
%
% Points begin at the XXX_min value, with the specified increment.  Make
% the spacing be a submultiple of all the axis spans to insure that the
% last point is placed at the max value.
%
% Example:
  if (0)
    ranges = [[-5 5]; [-5 5]; [-5 5]
              [-10 10]; [-10 10]; [-17 17]]; % concentrating on Rz

    make_axis_sweep('axis_sweep_test.dat', ranges, 0.1, 0.25);
    
    ranges = [[-21 21]; [-33 48]; [-16 16]
	      [-33 25]; [-52 52]; [-20 20]]; % w/o snout

    ranges = [[-21 21]; [-33 48]; [-16 16]
	      [-23 11]; [-31 31]; [-17 17]]; % with snout

    ranges = [[-21 21]; [-33 48]; [-16 16]
	      [-22 11]; [-22 22]; [-12 12]]; % with flat mask
  
    make_axis_sweep('axis_sweep.dat', ranges, 0.1, 0.1);

    %    make_axis_sweep('axis_sweep.dat', ranges, 0.2, 0.5);
    
  end

  % Zero pose at beginning for drift check.  Others at the end of each axis.
  res = zeros(1, 6);

  for ix = 1:3
    res = [res; one_sweep(ranges, xyz_step, ix);];
  end

  for ix = 4:6
    res = [res; one_sweep(ranges, Rxyz_step, ix);];
  end

  %plot the result
  [points,xs,ys,zs] = workspace_volume();

  % Scale to cm
  xs = xs * 1e-4;
  ys = ys * 1e-4;
  zs = zs * 1e-4;

  plot3(res(:,1)/10, res(:,2)/10, res(:,3)/10, 'r-*', ...
	xs, ys, zs, 'b');

  grid on
  xlabel('x axis');
  ylabel('y axis');
  zlabel('z axis');
  daspect([1, 1, 1]);

  fprintf(1, '%d points\n', length(res));
  save(out_file,'res','-ascii','-tabs');
end

function [res] = one_sweep (ranges, step, ix)
  span = ranges(ix, 2) - ranges(ix, 1);
  npoints = fix(round(span/step)) + 1;
  sweep = (0:npoints - 1) * step + ranges(ix, 1);
  % Extra zero pose at end for drift check.
  res = zeros(npoints + 1, 6);
  res(1:npoints, ix) = sweep;
end
