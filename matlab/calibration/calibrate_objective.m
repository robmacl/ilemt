function [residue, pred_coupling] = calibrate_objective ...
      (state, motion_poses, couplings, options)
% The guts of the objective function for the calibration optimization.  
% state:
%    The current optimization state, passed in from the optimizer.
%
% motion_poses:
%     A 2D array, where each row is two "pose" vectors:
%         [source_motion sensor_motion]
%     The format is the one used in the calibrator output data file:
%         [X Y Z Rx Ry Rz]
%     where the translation is in mm and rotation is Z Y X Euler angles, 
%     not a rotation vector.  See vector2tr().
%
% couplings:
%     A 3D array of measured complex couplings, where the third dimension is
%     parallel to stage poses.  That is, the pose for the N'th coupling
%     couplings(:, :, N) is motion_poses(N, :).
% 
% options:
%     Struct with options.
% 
% Results:
% 
% residue: the weighted residue (prediction error)
% 
% pred_coupling: 
%     The coupling matrices predicted from the calibration state and the
%     forward kinematics.

  state_defs;
  
  % number of stage poses 
  npoints = size(motion_poses, 1);
  
  % verify that the number of coupling matrices is equal to the number of the
  % stage poses we have
  assert(size(couplings, 3) == npoints);
  
  % Extract XXX_fixture from state vector and convert to transform matrices
  % 
  % so_fixture is the pose of the source within the actual mechanical source
  % fixture (the offset from the fixture center of rotation).
  so_fixture = pose2trans([state(source_fixture_pos_slice), ...
                      state(source_fixture_orientation_slice)]);
  %
  % st_fixture is the pose of the motion stage wrt. the source fixture.
  % This is the largest and most variable thing in the calibration setup,
  % since it has to do with how we place the (actual mechanical) source
  % fixture wrt. the stage coordinates.
  st_fixture = pose2trans([state(stage_fixture_pos_slice), ...
                      state(stage_fixture_orientation_slice)]);
  %
  % se_fixture is the pose of the sensor with respect to the output coordinates
  % of the sensor-side motion (the stage plus the actual mechanical sensor
  % fixture).
  se_fixture = pose2trans([state(sensor_fixture_pos_slice), ...
                      state(sensor_fixture_orientation_slice)]);

  % Calibration struct for the forward model, and the stage rotation axis
  % alignment (see motion_transforms()).
  calibration = state2calibration(state, options);

  % Convert motion_poses to transform matrices.  Some of the motion is from
  % manually positioned mechanical "fixtures".  This is part of the known
  % motion, and must not be confused with our unknown "fixture transforms".
  % For clarity, I am using "motion" to describe the known motion, regardless
  % of how it is mechanically created.  so_motion is the motion of the source
  % via manual rotation, and se_motion is the motion of the sensor via the
  % stage and manual rotation.
  [so_motion, se_motion] = ...
      motion_transforms(motion_poses, calibration.axis_fixture, ...
                        calibration.stage_scale);

  % P is the desired pose measurement of the tracker at each datapoint,
  % expressed as the linear homogenous transform from the source to sensor
  % coordinates:
  %     P = so_fixture * so_motion * st_fixture * se_motion * se_fixture
  % 
  % so_motion and se_motion are known from the input data, while the
  % optimization solves for the three XXX_fixture poses.
  % 
  % From the viewpoint of robotic manipulation, this is a sequential
  % kinematic chain where some links (so_motion and se_motion) vary
  % during calibration, but have known values, while the fixture poses are
  % links with unknown kinematic transforms, but that are held constant
  % across the input data.
  P = pagemtimes(pagemtimes(pagemtimes(pagemtimes( ...
      so_fixture, so_motion), st_fixture), se_motion), se_fixture);

  % Coupling matrices predicted by state and pose.
  pred_coupling = forward_kinematics(P, calibration);

  % Mismatch between measured coupling and predicted coupling
  r_couplings = real_coupling(couplings);
  if (options.normalize)
    da_norm = pagenorm(r_couplings);
  else
    da_norm = 1;
  end
  residue = (r_couplings - pred_coupling) ./ da_norm;
end
