function [out] = print_calibration (cal)
% Print a calibration result struct in human readable format

dipole.d_source_pos = cal.d_source_pos; 
dipole.d_source_moment = cal.d_source_moment; 
dipole.d_sensor_pos = cal.d_sensor_pos; 
dipole.d_sensor_moment = cal.d_sensor_moment; 
qpole.q_source_pos = cal.q_source_pos; 
qpole.q_source_moment = cal.q_source_moment; 
qpole.q_sensor_pos = cal.q_sensor_pos; 
qpole.q_sensor_moment = cal.q_sensor_moment;

% display dipole calibration and quadrupole calibration in two separate
% rows
dipole_t = struct2table(dipole);
disp(dipole_t);
qpole_t = struct2table(qpole);
if (~all(all(table2array(qpole_t) == 0)))
  disp(qpole_t);
end

if (nargout > 0)
  out = dipole_t;
end

print_fix('Source', cal.source_fixture);
print_fix('Stage', cal.stage_fixture);
print_fix('Sensor', cal.sensor_fixture);

%{
fprintf(1, 'Quadrupole source distance: ')
fprintf(1, '%.5f \n', cal.q_source_distance);

fprintf(1, 'Quadrupole sensor distance: ')
fprintf(1, '%.5f \n', cal.q_sensor_distance);
%}

end

function [] = print_fix (wot, sf)
% Print a fixture transform [x y z rotvec] as translation (mm) and rotation
% angle (degrees) about a unit axis.  The rotation vector is canonicalized so
% that the angle is in [0, 180].
  if (any(sf))
    angle = norm(sf(4:6));
    if (angle < 1e-12)
      axis = [0 0 0];
    else
      axis = sf(4:6) / angle;
    end
    angle = mod(angle, 2*pi);
    % Tolerance so that an exact 180 degree rotation keeps its axis sign.
    if (angle > pi + 1e-9)
      angle = 2*pi - angle;
      axis = -axis;
    end
    fprintf(1, '%-6s fix: trans [%8.3f %8.3f %8.3f] mm, rot %8.3f deg about [%7.4f %7.4f %7.4f]\n', ...
            wot, sf(1:3) * 1e3, angle * 180/pi, axis);
  end
end
