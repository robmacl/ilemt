function [real_data] = getreal( filename )
% Return signed magnitude of coupling data.  Sign is taken from the real
% part, but magnitude is the complex magnitude (including contribution from
% the imag part).  This makes the result insensitive to the phase shift.

    raw_data = dlmread(filename);
    signs = ones(size(raw_data));
    signs(real(raw_data) < 0) = -1;
    real_data = signs .* abs(raw_data);

end

