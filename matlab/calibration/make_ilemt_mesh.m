function make_ilemt_mesh (out_file, planes, spacing, rot_steps, rot_spacing, rot_axis)
% Mesh a rectangular XYZ volume.  Spacing is in mm, while planes are the number of
% planes in each direction.  Total size is then (planes - 1) * spacing.  The
% volume is centered on the origin.  An additional point is added midway
% between the first and second points, making the pattern asymmetrical to
% "key" the rotation.
%
% Optionally, the entire mesh may be repeated at several rotational
% steps.  rot_steps (default 1), rot_spacing (degrees, default 45),
% rot_axis 1..3 for Rx Ry Rx, default 3.
%
% for example:
%    make_ilemt_mesh('foo.dat', 5, 20)
%    make_ilemt_mesh('foo.dat', 5, 20, 3)
%    make_ilemt_mesh('source_pattern.dat', [5 3 5], [35 70 25])

if (nargin < 4)
  rot_steps = 1;
end

if (nargin < 5)
  rot_spacing = 45;
end

if (nargin < 6)
  rot_axis = 3;
end

if (isscalar(planes))
  planes = repmat(planes, 1, 3);
end

res = make_mesh(planes(1), planes(2), planes(3), spacing);
res = [res(1,:); (res(1,:) + res(2,:))*0.5; res(2:end,:)];
res=horzcat(res, zeros(length(res),3));

%plot the mesh grid
plot3(res(:,1), res(:,2), res(:,3), 'r-*');

grid on
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');

if (rot_steps > 1)
  rot_span = (rot_steps - 1) * rot_spacing;
  rots = linspace(-rot_span/2, rot_span/2, rot_steps);
  res_all = [];
  for (ix = 1:length(rots))
    res1 = res;
    res1(:, 3 + rot_axis) = rots(ix);
    res_all = [res_all; res1];
  end
  res = res_all;
end

% Start and end with null pose.  Leaves stage parked, and also possible
% drift check.
res = vertcat(zeros(1, 6), res, zeros(1, 6));

res

fprintf(1, '%d points\n', length(res));
save(out_file,'res','-ascii','-tabs');
