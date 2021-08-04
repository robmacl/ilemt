function [do_stop] = print_state(state, options)
% This function is called as the optimizer output function. It prints the
% optimizer state and also checkpoints it in state_checkpoint.  The ncheckpoint
% lets us interrupt the optimization and save with save_checkpoint()

  global state_checkpoint;
  state_checkpoint = state;
  print_calibration(state2calibration(state, options));
  fprintf(1, '\n');

  do_stop = false;
end
