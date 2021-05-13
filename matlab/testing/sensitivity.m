function [diff] = sensitivity (c1, c2, cal)
cpl = cat(3, c1, c2);
poses = pose_calculation(cpl, cal);
diff = poses(1,:) - poses(2,:);
trans = norm(diff(1:3));
rot = norm(diff(4:6));
fprintf(1, '%.3f mm %.1f mrad (%.3f mm moment)\n', trans*1e3, rot*1e3, ...
        (trans + rot * 0.05) * 1e3);
