
delta = [ones(1, 3) * 1e-3, ones(1, 3) * 20e-3];

x0 = cp.perr.desired(1, :);
cal = cp.calibration;

dp = zeros(3, 3, 6);

for (ix = 1:6)
  d1 = zeros(size(delta));
  d1(ix) = delta(ix);
  dp(:, :, ix) = fk_fun(x0 + d1, cal) - fk_fun(x0, cal);
end

dp

norms = zeros(1, 6);
for (ix = 1:6)
  norms(ix) = norm(dp(:,:,ix));
end
norms

function [coupling] = fk_fun (pose, calibration)
  coupling = forward_kinematics(pose2trans(pose), calibration);
end



%{
function [diff] = sensitivity (c1, c2, cal)
cpl = cat(3, c1, c2);
poses = pose_calculation(cpl, cal);
diff = poses(1,:) - poses(2,:);
trans = norm(diff(1:3));
rot = norm(diff(4:6));
fprintf(1, '%.3f mm %.1f mrad (%.3f mm moment)\n', trans*1e3, rot*1e3, ...
        (trans + rot * 0.05) * 1e3);
%}
