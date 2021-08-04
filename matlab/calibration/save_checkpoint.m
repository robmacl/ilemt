function [cal] = save_checkpoint (options, ofile)
% Save optimization state as a .mat file which can be used as
% base_calibration.  Useful after interrupt.
global state_checkpoint;
global last_calibration;
save_calibration(state2calibration(state_checkpoint, options), ofile);
last_calibration = ofile;



