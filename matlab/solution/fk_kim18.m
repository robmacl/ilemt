function [coupling] = fk_kim18 (P, calibration)
% Forward kinematics from kim18 paper.  The mismatch between this and the
% measured coupling is what kim18 is supposed to be minimizing.  If
% calibration is concentric dipole then this should give same result as
% calibration/forward_kinematics.m (to within numeric error).

kim_cal = cal2kim18(calibration);
p_ = P(1:3, 4);
phat_ = p_/norm(p_);
R_ = P(1:3, 1:3);

% Equation (5)
S_ = kim_cal.mu_/(4*pi * norm(p_)^3) ...
     * kim_cal.N_' * R_' ...
     * (3 * phat_ * phat_' - eye(3)) ...
     * kim_cal.M_;

coupling = S_' .* kim_cal.coupling_gains;
