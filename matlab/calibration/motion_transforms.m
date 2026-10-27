function [so_motion, se_motion] = motion_transforms (motion_poses, ax_fix, st_scale)
% Convert the known motions from read_cal_data() into transform stacks
% (4x4xN): so_motion is the source fixture motion, and se_motion is the
% sensor-side motion (stage plus sensor fixture).  See calibrate_objective()
% for the kinematic chain.
%
% ax_fix:
%     Optional rotation vector (rad) for the alignment of the stage rotation
%     axes with respect to the stage translation axes (calibration
%     .axis_fixture).  The stage rotation becomes A * R_stage * A', where A
%     is the ax_fix rotation, so this tilts the rotation axis without moving
%     the translations.  If empty or zero we use the original chain exactly.
%
% st_scale:
%     Optional stage translation scale errors for stage X Y Z, per mille
%     (calibration.stage_scale).  The stage translation is multiplied by
%     (1 + st_scale/1000) before the motion is used.

  so_motion = vector2tr(motion_poses(:, 1:6));

  if (nargin >= 3 && ~isempty(st_scale) && any(st_scale ~= 0))
    % Columns 7:9 and 13:15 are both the stage translation (the sensor
    % fixture motion is a pure rotation applied after the stage motion).
    k = 1 + st_scale(:)' / 1e3;
    motion_poses(:, 7:9) = motion_poses(:, 7:9) .* k;
    motion_poses(:, 13:15) = motion_poses(:, 13:15) .* k;
  end

  if (nargin < 2 || isempty(ax_fix) || all(ax_fix == 0))
    se_motion = vector2tr(motion_poses(:, 7:12));
    return;
  end

  n = size(motion_poses, 1);
  % Columns 13:18 are the stage motion alone, and 7:12 is the stage motion
  % composed with the sensor fixture motion (see read_cal_data), so we can
  % recover the sensor fixture motion F.
  stage = motion_poses(:, 13:18);
  stage_tr = vector2tr(stage);
  F = pagemldivide(stage_tr, vector2tr(motion_poses(:, 7:12)));

  % Split the stage motion into translation and rotation.
  T_xyz = repmat(eye(4), 1, 1, n);
  T_xyz(1:3, 4, :) = stage_tr(1:3, 4, :);
  R_stage = stage_tr;
  R_stage(1:3, 4, :) = 0;

  A = pose2trans([0 0 0 ax_fix]);
  se_motion = pagemtimes(pagemtimes(pagemtimes(pagemtimes(T_xyz, A), R_stage), A'), F);
end
