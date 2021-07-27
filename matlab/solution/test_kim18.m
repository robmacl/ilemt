%function [] = test_kim18 (perr, calibration, ix)
ix=1;

calibration = load(options.cal_file);
coupling = real_coupling(perr.couplings(:,:,ix));
kimpose = kim18(coupling, calibration);
kim_fk = fk_kim18(kimpose, calibration);
opt_pose = pose2trans(perr.measured(ix, :));
opt_fk = forward_kinematics(opt_pose, calibration);
kim_opt = fk_kim18(opt_pose, calibration);
fprintf(1, 'kim=%g opt=%g kim_opt=%g\n', ...
          c_match(coupling, kim_fk), ...
          c_match(coupling, opt_fk), ...
          c_match(coupling, kim_opt));


P = opt_pose;
kim_cal = cal2kim18(calibration);
fk_p_ = P(1:3, 4);
fk_phat_ = fk_p_/norm(fk_p_);
fk_R_ = P(1:3, 1:3);

% Equation (5)
fk_S_ = kim_cal.mu_/(4*pi * norm(fk_p_)^3) ...
     * kim_cal.N_' * fk_R_' ...
     * (3 * fk_phat_ * fk_phat_' - eye(3)) ...
     * kim_cal.M_;

fk_coupling = fk_S_' .* kim_cal.coupling_gains;

solve_S_ = real_coupling(coupling) ./ kim_cal.coupling_gains)';


function [res] = c_match (a, b)
  res = sum(sum(a - b).^2);
end
