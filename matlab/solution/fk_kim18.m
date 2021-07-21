function [coupling] = fk_kim18 (P, calibration)
% This should return the same as calibration/forward_kinematics.m, after
% correcting P for any non-concentric position of the coils.

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
