function [] = print_calibration (cal)
% Print a calibration result struct in human readable format

dipole.d_source_pos = cal.d_source_pos; 
dipole.d_source_moment = cal.d_source_moment; 
dipole.d_sensor_pos = cal.d_sensor_pos; 
dipole.d_sensor_moment = cal.d_sensor_moment; 
qpole.q_source_pos = cal.q_source_pos; 
qpole.q_source_moment = cal.q_source_moment; 
qpole.q_sensor_pos = cal.q_sensor_pos; 
qpole.q_sensor_moment = cal.q_sensor_moment;

% display dipole calibration and quadrupole calibration in two separate rows
disp(struct2table(dipole));
qpole_t = struct2table(qpole);
if (~all(all(table2array(qpole_t) == 0)))
  disp(qpole_t);
end

fprintf(1, 'Source fix: [');
sf = cal.source_fixture;
for ix = 1:length(sf)
  fprintf(1, '%.5f ', sf(ix));
end
fprintf(1, ']\n');

fprintf(1, 'Sensor fix: [');
sf = cal.sensor_fixture;
for ix = 1:length(sf)
  fprintf(1, '%.5f ', sf(ix));
end
fprintf(1, ']\n');

%{
fprintf(1, 'Quadrupole source distance: ')
fprintf(1, '%.5f \n', cal.q_source_distance);

fprintf(1, 'Quadrupole sensor distance: ')
fprintf(1, '%.5f \n', cal.q_sensor_distance);
%}
