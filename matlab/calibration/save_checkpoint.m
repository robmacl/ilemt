function [cal] = save_checkpoint (ofile)
% Save optimization state as a .mat file which can be used as
% base_calibration.  Useful after interrupt.
global state_checkpoint;
global last_calibration;
global current_calibrate_options;
cal = state2calibration(state_checkpoint, current_calibrate_options);
save_calibration(cal, ofile);
last_calibration = ofile;
