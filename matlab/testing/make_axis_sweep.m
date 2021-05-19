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
    ranges = [[-50 50]; [-50 50]; [-50 50]; 
	      [0 0]; [0 0]; [-90 90]];
  
    make_axis_sweep('axis_sweep_1_1.dat', ranges, 1, 1);
  end

  % Zero pose at beginning for drift check.  Others at the end of each axis.
  res = zeros(1, 6);

  for ix = 1:3
    res = [res; one_sweep(ranges, xyz_step, ix);];
  end

  for ix = 4:6
    res = [res; one_sweep(ranges, Rxyz_step, ix);];
  end

  plot3(res(:,1)/10, res(:,2)/10, res(:,3)/10, 'r-*');

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
