function [do_stop] = print_state(state, options)
% This function is called as the optimizer output function. It prints the
% optimizer state and also checkpoints it in state_checkpoint.  The ncheckpoint
% lets us interrupt the optimization and save with save_checkpoint()

  global state_checkpoint;
  state_checkpoint = state;
  
  if (options.verbose >= 2)
    print_calibration(state2calibration(state, options));
    fprintf(1, '\n');
  end

  do_stop = false;
end
