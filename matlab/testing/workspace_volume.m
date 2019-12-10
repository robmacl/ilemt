% Return 3D workspace volume (where the sensor fields of view
% intersect.)  Points are the distinct 3D points, while xs, ys, zs
% are coordinates of line segments that can be plotted with plot3.
% If args are omitted, then we use a default calibration, which will have
% little effect on the workspace volume.

function [points, xs, ys, zs] = workspace_volume(Tcam, K)
if (nargin < 2)
  load('../cal_data/SN1/stage_new/transform.mat', 'T', 'K');
  Tcam = T;
end


% Fraction of sensor usable. 
ws_frac = 0.75;

% Corners of the volume in sensor (uv) coordinates.
uv_map = [
    +1 +1 -1 +1
    +1 +1 +1 +1
    -1 +1 +1 +1
    -1 +1 -1 +1
    +1 -1 -1 -1
    +1 -1 +1 -1
    -1 -1 +1 -1
    -1 -1 -1 -1] * ws_frac * nominal_scale;

points = zeros(0, 4);
points_ix = 1;

% Find 3D points by ray intersection.
for (ix = 1:size(uv_map,1))
  [base_s1, dir_s1] = get_ray(Tcam, K, 1, uv_map(ix, 3:4));
  [base_s2, dir_s2] = get_ray(Tcam, K, 2, uv_map(ix, 1:2));
  origin = find_intersection(base_s2, dir_s2, base_s1, dir_s1);
  points(points_ix,:) = find_intersection(base_s2, dir_s2, base_s1, dir_s1);
  points_ix = points_ix+1;
end

% Vertex pairs, where element is index into the 3D points.
edge_map = [1 2
	    2 3
	    3 4
	    4 1
	    5 6
	    6 7
	    7 8
	    8 5
	    1 5
	    2 6
	    3 7
	    4 8];

xs = [points(edge_map(:,1), 1) points(edge_map(:,2), 1)]';
ys = [points(edge_map(:,1), 2) points(edge_map(:,2), 2)]';
zs = [points(edge_map(:,1), 3) points(edge_map(:,2), 3)]';
