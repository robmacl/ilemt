% Find 3D rotation and translation (rigid transform) that maps the calibrated
% points to the desired points.

function [F, calibrated] = source_fixture (measured, desired)

  F = (pinv(measured) * desired)';       %pinv--> pseudoinverse
  cpinv = cond(F(1:3, 1:3));  
  if (cpinv > 5) 
    fprintf(1, 'Condition of pinv rotation: %f\n', cpinv);
    fprintf(1, 'Danger Will Robinson!  Poor condition, skipping poldec.\n');
    fprintf(1, 'Result is not a rigid transform.\n');    
  else
    F(1:3, 1:3) = poldec(F(1:3, 1:3));
    F(4, 1:3) = 0;
    F(4, 4) = 1;
  
    % First try.
    xyz_calibrated = measured * F';
    xyz_calibrated = xyz_calibrated(:, 1:3);
    
    % Adjust the transform once more to force the mean error to zero, as
    % the transform step does not precisely accomplish this after we drop out
    % the scale and skew terms using poldec.
    mean_err = mean(xyz_calibrated - desired(:, 1:3));
    F(1:3, 4) = F(1:3, 4) - mean_err'; 

    % This is specific to the fixturing of the probe w.r.t. stage, but is
    % useful to generate comprehensible values of RPY because the
    % actual rotation flirts with gimbal lock.
    nom_rot = [
	1     0     0     0
	0     1     0     0
	0     0     1     0
	0     0     0     1];  
    % Print summary RPY & translation.
    RxRyRz = tr2rpy(nom_rot*F) * 180/pi;
    RxRyRz = RxRyRz(3:-1:1);
    fprintf('Rxyz from nominal (degrees): (%.2f, %.2f, %.2f)\n', RxRyRz);
  end

  fprintf('Translation (microns): (%.0f, %.0f, %.0f)\n', F(1:3, 4)');

  calibrated = measured * F';
