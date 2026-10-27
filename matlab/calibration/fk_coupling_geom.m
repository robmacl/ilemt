function [coupling] = fk_coupling_geom (P, so_pos, so_mo, so_dims, se_pos, se_mo)
% Coupling with each source coil modeled as a rectangular current sheet
% winding instead of a point dipole (options.source_geometric).  This is the
% exact field of the winding, so it includes all of the finite size terms
% that the octupole (o_so, a_so) only gives to leading order.  The sensor is
% still the component dipoles from forward_kinematics(), including its
% octupole terms.
%
% P is the sensor pose in source coordinates, 4x4xN.  so_pos and so_mo are
% the source coil centers and moments (3x3, coils as columns), as for the
% dipole model: the moment direction is the coil axis u and its magnitude is
% the coil gain.  so_dims is [a; b; L] in mm for each coil: the winding is a
% stack of a x b rectangular loops spread uniformly over axial length L,
% which is the same as a current sheet on the four sides of an a x b x L
% box.  a is along the transverse axis v and b along w, which are the coil
% frame axes in cyclic order made orthogonal to u: coil X (Y, Z), coil Y
% (Z, X), coil Z (X, Y), as in the octupole anisotropy.  To leading order
% this is the octupole with s = L^2/12 - (a^2 + b^2)/24 and
% t = (a^2 - b^2)/12.  Since only the squares matter at that order, signs
% of the dimensions are ignored.
%
% se_pos, se_mo are the sensor component dipole pages (3x3xK).  coupling is
% 3x3xN, coupling(i, j, n) is source coil i to sensor coil j at pose n.

  R = P(1:3, 1:3, :);
  t = P(1:3, 4, :);
  n = size(P, 3);

  segs = cell(1, 3);
  for i = 1:3
    segs{i} = coil_segments(so_pos(:, i), so_mo(:, i), so_dims(:, i), i);
  end

  coupling = zeros(3, 3, n);
  for page = 1:size(se_mo, 3)
    mo1 = se_mo(:, :, page);
    if (~any(mo1(:)))
      continue;
    end
    % Sensor component positions and moments in source coordinates, 3x3xN
    % with sensor coils as columns.
    sensor_pos = pagemtimes(R, se_pos(:, :, page)) + t;
    sensor_moment = pagemtimes(R, mo1);
    q = reshape(sensor_pos, 3, []);
    for i = 1:3
      B = reshape(segment_field(q, segs{i}), 3, 3, n);
      coupling(i, :, :) = coupling(i, :, :) + sum(B .* sensor_moment, 1);
    end
  end
end


function [seg] = coil_segments (c, m, dims, i)
% Straight segments of the loops making up source coil i.  seg.p1, seg.p2
% are the 3xS segment endpoints and seg.cur the 1xS currents.  The loops are
% at 4-point Gauss-Legendre positions along the axis, which is plenty at our
% ranges.  Each loop current is gain * weight / area so that the total moment
% is m.  Corners go counterclockwise about u, which gives moment +u.
  gain = norm(m);
  u = m / gain;
  I3 = eye(3);
  v = I3(:, mod(i, 3) + 1);
  v = v - u * (u' * v);
  v = v / norm(v);
  w = cross(u, v);
  % A loop of zero area would have infinite current, so floor a and b.
  a = max(abs(dims(1)) * 1e-3, 1e-4);
  b = max(abs(dims(2)) * 1e-3, 1e-4);
  L = abs(dims(3)) * 1e-3;
  gx = [-0.861136311594053 -0.339981043584856 0.339981043584856 0.861136311594053];
  gw = [0.347854845137454 0.652145154862546 0.652145154862546 0.347854845137454] / 2;
  corners = v * ([1 -1 -1 1] * a/2) + w * ([1 1 -1 -1] * b/2);
  nxt = [2 3 4 1];
  seg.p1 = zeros(3, 16);
  seg.p2 = zeros(3, 16);
  seg.cur = zeros(1, 16);
  for k = 1:4
    center = c + u * (gx(k) * L/2);
    ix = (k - 1) * 4 + (1:4);
    seg.p1(:, ix) = center + corners;
    seg.p2(:, ix) = center + corners(:, nxt);
    seg.cur(ix) = gain * gw(k) / (a * b);
  end
end


function [B] = segment_field (q, seg)
% Biot-Savart field at points q (3xM) of straight current segments, in the
% same units as the dipole model (mu0/4pi = 1).  For a segment from p1 to p2
% with r1 = q - p1, r2 = q - p2:
%   B = I (|r1| + |r2|) (r1 x r2) / (|r1| |r2| (|r1| |r2| + r1 . r2))
  B = zeros(size(q));
  for s = 1:size(seg.p1, 2)
    r1 = q - seg.p1(:, s);
    r2 = q - seg.p2(:, s);
    n1 = vecnorm(r1);
    n2 = vecnorm(r2);
    f = seg.cur(s) * (n1 + n2) ./ (n1 .* n2 .* (n1 .* n2 + sum(r1 .* r2, 1)));
    B = B + f .* cross(r1, r2);
  end
end
