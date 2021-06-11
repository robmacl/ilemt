function [pose] = kim18 (coupling, calibration)
% Method from "Closed-Form Position and Orientation Estimation for a
% Three-Axis Electromagnetic Tracking System", Wooyoung Kim, Jihoon Song,
% Frank Park, 2018.  IEEE Transactions on Industrial Electronics
%
% Notation: variable ending in '_' are from the paper
% 

kim_cal = cal2kim18(calibration);

% S_ is the scaled transpose of our coupling.
S_ = (real_coupling(coupling) .* kim_cal.coupling_gains)';

% The paper uses superscript of '-T' on N_, which seems to mean the inverse of
% the transpose.  This is equation (6), which is just algebra on equation (5)
% which moves all the knowns into Y_ on the LHS, leaving the unknowns in the
% RHS.  Y_ is a shorthand for the knowns, the coupling and the sensor/source
% moments.

% See bullets 1), 2), 3) below equation (20) on page 4334 for the algorithm
% summary.

% Step 1
Y_ = inv(kim_cal.N_') * S_ * inv(kim_cal.M_);

% Step 2
[U_, svdS, V_] = svd(Y_);
sigma_ = diag(svdS);

% Step 3
% The results

% Rstar_ (pose rotation matrix)
Rstar_ = V_ * diag([1 -1 -1]) * U_';

% Not sure why we need this 1/(2*pi).  May be a conseqence of how we are
% setting _mu?  But the value of _mu works with fk_kim18(), eqn (5).  It seems
% to come from having 1/(4*pi) in eqn(5) and 1/(2*pi) in algorithm step 3.  
% 
% Maybe the physical mu has 2*pi in it?  Note that in the algorithm there is
% no mu or pi anywhere except in the gamma_ equation.  FWIW, the equation I
% have used has 1e-7 constant factor, no mu or pi.  I must be implicitly
% assuming mu = 1, and the 1e-7 comes from a different particular choice of
% units.  There is a lot of diversity of magnetics units which are supposed to
% simplifiy notation.
gamma_fudge = 1 / (2*pi);

% From step 3, gamma_ is used to compute the translation, pstar_.
gamma1 = 3*kim_cal.mu_ / (2*pi*(2*sigma_(1) + sigma_(2) + sigma_(3)));
gamma_ = (gamma1 * gamma_fudge)^(1/3);

% pstar_ (pose translation, two symmetric solutions)
pstar_ = zeros(3, 2);
pstar_(:, 1) = gamma_ * V_(:, 1);
pstar_(:, 2) = -gamma_ * V_(:, 1);

% Construct pose.
pose = eye(4);
pose(1:3, 1:3) = Rstar_;

% We choose +x hemisphere
if (pstar_(1, 1) >= 0)
  pose(1:3, 4) = pstar_(:, 1);
else
  pose(1:3, 4) = pstar_(:, 2);
end
