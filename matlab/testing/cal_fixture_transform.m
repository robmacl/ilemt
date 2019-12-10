% Apply calibration, find fixture transform, and return calibrated points
% in fixture coordinates [x y z 1], and the match error.  The light number
% is the third index.

function [F, calibrated, match_err] = ...
  cal_fixture_transform(T, K, measured, desired, light_num)

  % get_ray/find_intersection
  calibrated_asap = apply_calibration(T, K, measured);
  match_err = calibrated_asap(:, 4, :);
  calibrated_asap(:, 4, :) = 1;

  [F, calibrated] = fixture_transform(calibrated_asap, desired, light_num);
