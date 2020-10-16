%This function print the calibration struct, source and sensor fixtures of
%which is composed the state vector
function [do_stop] = print_state(state,~,~)
state_defs;
        cal = state2calibration(state, true);
        calibration.d_source_pos = cal.d_source_pos; 
        calibration.d_source_moment = cal.d_source_moment; 
        calibration.d_sensor_pos = cal.d_sensor_pos; 
        calibration.d_sensor_moment = cal.d_sensor_moment; 
        calibration.q_source_pos = cal.q_source_pos; 
        calibration.q_source_moment = cal.q_source_moment; 
        calibration.q_sensor_pos = cal.q_sensor_pos; 
        calibration.q_sensor_moment = cal.q_sensor_moment;
        ctab = struct2table(calibration);
        %display in two separate rows dipole calibration and quadrupole
        %calibration
        disp(ctab(:, 1:4));
        disp(ctab(:, 5:8));
        
        
        fprintf(1, 'Quadrupole source distance: ')
        fprintf(1, '%.5f \n', cal.q_source_distance);
        
        fprintf(1, 'Quadrupole sensor distance: ')
        fprintf(1, '%.5f \n', cal.q_sensor_distance);
        
        fprintf(1, 'Source fix: [');
        sf = [state(source_fixture_pos_slice), state(source_fixture_orientation_slice)];
        for ix = 1:length(sf)
          fprintf(1, '%.5f ', sf(ix));
        end
        fprintf(1, ']\n');

        fprintf(1, 'Sensor fix: [');
        sf = [state(sensor_fixture_pos_slice), state(sensor_fixture_orientation_slice)];
        for ix = 1:length(sf)
          fprintf(1, '%.5f ', sf(ix));
        end
        fprintf(1, ']\n');
       
        do_stop = false;
end

