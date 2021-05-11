function [res] = real_coupling (raw_data)
% We return signed magnitude of the coupling data.  Sign is taken from the
% real part, but magnitude is the complex magnitude (including contribution
% from the imag part).  This makes the result insensitive to the phase shift.
% This can actually be used on any numeric array.  Elements that are real are
% unaffected.
% 
% If the expected phase is calibrated correctly in ilemt_ui.vi (by
% "Calibraton/"Ref cal"), then we expect that all coupling elements which are
% not too small will have a phase angle of nearly 0 or nearly 180 degrees (+/-
% perhaps 10 degrees, depending on how you define "too small").  That is, the
% imaginary component should be small.  So there is no ambiguity in
% determining the sign from the real part.  As values become small the phase
% becomes ill-defined, but getting the sign right also becomes unimportant.

    signs = ones(size(raw_data));
    signs(real(raw_data) < 0) = -1;
    res = signs .* abs(raw_data);
end
