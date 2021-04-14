function [ctab] = print_calibration (cal)
calibration.d_source_pos = cal.d_source_pos; 
calibration.d_source_moment = cal.d_source_moment; 
calibration.d_sensor_pos = cal.d_sensor_pos; 
calibration.d_sensor_moment = cal.d_sensor_moment; 
calibration.q_source_pos = cal.q_source_pos; 
calibration.q_source_moment = cal.q_source_moment; 
calibration.q_sensor_pos = cal.q_sensor_pos; 
calibration.q_sensor_moment = cal.q_sensor_moment;

% Use a Matlab table for prettier display (and dumping to spreadsheet)
ctab = struct2table(calibration);

% display dipole calibration and quadrupole calibration in two separate rows
disp(ctab(:, 1:4));
disp(ctab(:, 5:8));

%{
fprintf(1, 'Quadrupole source distance: ')
fprintf(1, '%.5f \n', cal.q_source_distance);

fprintf(1, 'Quadrupole sensor distance: ')
fprintf(1, '%.5f \n', cal.q_sensor_distance);
%}
