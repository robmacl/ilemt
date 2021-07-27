function [pose] = kim18 (coupling, calibration)
% Method from "Closed-Form Position and Orientation Estimation for a
% Three-Axis Electromagnetic Tracking System", Wooyoung Kim, Jihoon Song,
% Frank Park, 2018.  IEEE Transactions on Industrial Electronics
%
% Notation: variable ending in '_' are from the paper
% 

kim_cal = cal2kim18(calibration);

% S_ is the scaled transpose of our coupling.
S_ = (real_coupling(coupling) ./ kim_cal.coupling_gains)';

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

% From step 3, gamma_ is used to compute the translation, pstar_.
gamma1 = 3*kim_cal.mu_ / (2*pi*(2*sigma_(1) + sigma_(2) + sigma_(3)));
gamma_ = gamma1^(1/3);

% pstar_ (pose translation, two symmetric solutions)
pstar_ = zeros(3, 2);
pstar_(:, 1) = gamma_ * V_(:, 1);
pstar_(:, 2) = -gamma_ * V_(:, 1);

% Construct pose.
pose = eye(4);
pose(1:3, 1:3) = Rstar_;

% We choose this hemisphere as positive
plus_hemisphere = 1;

if (pstar_(plus_hemisphere, 1) >= 0)
  pose(1:3, 4) = pstar_(:, 1);
else
  pose(1:3, 4) = pstar_(:, 2);
end
