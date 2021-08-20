function [kim_cal] = cal2kim18 (calibration)
% Convert our calibration model into the one expected by the algorithm.  The
% biggest limitation is that it expects concentric source/sensor coils, so
% will not work well with highly non-concentric arrangements.  The concentric
% calibration forces all of the coils to be located at the origin.
% 
% For our stage testing, we (elsewhere) use the source/sensor fixture
% transforms to the absorb the offset from the assumed center to the our
% calibrated origin (currently forced to the Z dipole position).
% 
% Also, the way the system gain is distributed is different.  They notionally
% assume that the source moments are in physical units, that the sensor coils
% measure physical units, and that the gain us rolled into the 'mu'.  But this
% scaling, while physically pleasing, seems purely notational.  We can use any
% unit, including an arbitrary one we made up for this particular calibration.
% Mu appears only in the radial distance.
% 
% However, we do have the problem that with their fixed scaling, the sensor
% moments can be represented as unit vectors, rather than a vector of
% arbitrary magnitude.  So we have to normalize the sensor axes, prescale the
% coupling matrix to compensate for the difference in sensor axis gains, and
% then compute mu from the existing source/sensor gains in the calibration.
%
% The algorithm does support non-orthogonal coils, but only supports dipole
% source/sensor models.  

% Notation: variables ending in '_' are from the paper

se_moment = calibration.d_sensor_moment;
se_gains = sqrt(sum(se_moment.^2, 1));

% Gains of our coupling matrix, before converting to unit vector N_.  Their S_
% matrix is our coupling matrix, divided by coupling_gains, then
% transposed.  This normalizes the measurement in the same way that we have
% normalized the sensor moments.
%    S_ = (coupling ./ kim_cal.coupling_gains)'
%
kim_cal.coupling_gains = repmat(se_gains, 3, 1);

kim_cal.N_ = se_moment ./ kim_cal.coupling_gains;
kim_cal.M_ = calibration.d_source_moment;

% Where they have mu_/(4*pi) as the leading constant factor, we have an
% arbitrary 1/250 in forward_kinematics.  So:
%    mu_/(4*pi) = 1/250
kim_cal.mu_ = (4*pi)/250;
