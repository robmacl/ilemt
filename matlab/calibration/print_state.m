% This function prints the optimizer state.  It has this interface so that
% it can be passed to lsqnonlin as the print function.
function [do_stop] = print_state(state, ~, ~)
  print_calibration(state2calibration(state));
  do_stop = false;
end
