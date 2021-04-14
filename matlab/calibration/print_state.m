% This function prints the optimizer state.  It has this interface so that
% it can be passed to lsqnonlin as the print function.
function [do_stop] = print_state(state, ~, ~)
  state_defs;
  cal = state2calibration(state);
  print_calibration(cal);
  
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
