function [pose0] = p_s_o_pose0 (coupling, calibration, con_cal, hemi)
% Find initial pose for pose_solve_optimize.  Use kim18 concentric solution if
% available.
if (~isempty(con_cal))
  pose0 = pose_solve_kim18(coupling, con_cal, hemi);
else
  % We use the fixture poses to construct the sensor pose at the stage null
  % pose.
  % ### doesn't include source motion, so probably useless
  pose0 = trans2pose(pose2trans(calibration.source_fixture) ... 
                     * pose2trans(calibration.stage_fixture) ...
                     * pose2trans(calibration.sensor_fixture));
end
