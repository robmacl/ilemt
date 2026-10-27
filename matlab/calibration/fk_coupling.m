%Coupling matrix calculated using dipole model
function [coupling] = fk_coupling (P, so_pos, so_mo, se_pos, se_mo)
% P is the sensor pose in source coordinates, 4x4 or 4x4xN.  The source and
% sensor positions and moments are 3x3, with coils as columns.  coupling is
% 3x3xN, coupling(i, j, n) is source coil i to sensor coil j at pose n.

  R = P(1:3, 1:3, :);
  t = P(1:3, 4, :);
  n = size(P, 3);

  % Sensor coil positions and moments in source coordinates, 3x3xN with
  % sensor coils as columns.
  sensor_pos = pagemtimes(R, se_pos) + t;
  sensor_moment = pagemtimes(R, se_mo);

  coupling = zeros(3, 3, n);
  for i = 1:3 %source index
    % Vector distance r between source and sensor in source coordinates.
    rSoSe = sensor_pos - so_pos(:, i);
    rSoSeMag = sqrt(sum(rSoSe .^ 2, 1));
    rSoSeUnit = rSoSe ./ rSoSeMag;

    % Field at the sensor locations, using the dipole model
    m = so_mo(:, i);
    B = (3 * sum(m .* rSoSeUnit, 1) .* rSoSeUnit - m) ./ rSoSeMag .^ 3;

    % Coupling matrix using antenna model
    coupling(i, :, :) = sum(B .* sensor_moment, 1);
  end
end
