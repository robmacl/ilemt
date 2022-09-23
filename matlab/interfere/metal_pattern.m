% Generate test points for metal interference testing.  Since positioning
% is manual we don't want to overdo the point count.

% We expect metal interference to vary as r^6, so this is a reasonable
% basis for spacing.  [This is not going to force us to see the r^6
% pattern, but will show it with least number of points.]

% Positions in whole centimeters, over range of x=0..100, y=+/- 25

max_x = 100
x = round(linspace(1,max_x^(1/6),10).^6);
x = [0 x];
% Similar, rounder, values
x = [0     1     2     4     7    12    20    30    50    70   100]
dx = diff(x)

% There is no particular reason to expect r^6 relation to hold for Y values.
% When X is 0 it will increase at Y near source or sensor.  When X is large, Y
% does not matter much.  Probably choose specific Y values which do not land
% on the source or sensor.  It is easier for manual positioning if we stick
% to a grid.
max_y = 25;
y = round(linspace(0, max_y, 4));
y_sub = y(2:end-1) % abs value w/o 0 or 25

xy = zeros(0, 2);
xy_ix = 1;
for (ix = 1:length(x))
  x1 = x(ix);
  y = [y_sub(y_sub >= x1) 25];
  y = [fliplr(-y) 0 y];
  for (iy = 1:length(y))
    xy(xy_ix, :) = [x1, y(iy)];
    xy_ix = xy_ix + 1;
  end
end

plot(xy(:,1), xy(:,2), 'o')
