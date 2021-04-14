function [real_data] = getreal( filename )
% This is called to read the output of stage_calibration.vi.
%
% We return signed magnitude of the coupling data.  Sign is taken from the
% real part, but magnitude is the complex magnitude (including contribution
% from the imag part).  This makes the result insensitive to the phase
% shift.  
% 
% If the expected phase is calibrated correctly in ilemt_ui.vi (by
% "Calibraton/"Ref cal"), then we expect that all coupling elements which are
% not too small will have a phase angle of nearly 0 or nearly 180 degrees (+/-
% perhaps 10 degrees, depending on how you define "too small").  So there is
% no ambiguity in determining the sign from the real part.  As values become
% small the phase becomes ill-defined, but getting the sign right also becomes
% unimportant.
% 
% Each line in the file contains both the stage pose and the measured
% couplings.  Since the pose is real (!) it does no harm also process the pose
% the same way.

    raw_data = dlmread(filename);
    signs = ones(size(raw_data));
    signs(real(raw_data) < 0) = -1;
    real_data = signs .* abs(raw_data);
end

