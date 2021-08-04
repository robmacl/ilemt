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

  % Preallocate results
  residue = zeros(size(couplings));
  pred_coupling = zeros(size(couplings));

  clear pc_cell;
  parfor (ix = 1:npoints)
    % Convert motion_poses(ix, :) to transform matrices.  Some of the
    % motion is from manually positioned mechanical "fixtures".  This is
    % part of the known motion, and must not be confused with our unknown
    % "fixture transforms".  For clarity, I am using "motion" to describe
    % the known motion, regardless of how it is mechanically created.
    %
    % Motion of the source via manual rotation
    so_motion = vector2tr(motion_poses(ix, 1:6)); 
    % Motion of the sensor via the stage and manual rotation.
    se_motion = vector2tr(motion_poses(ix, 7:12)); 

    % P is the desired pose measurement of the tracker at this datapoint,
    % expressed as the linear homogenous transform from the source to sensor
    % coordinates.
    % 
    % so_motion and se_motion are known from the input data, while the
    % optimization solves for the three XXX_fixture poses.
    % 
    % From the viewpoint of robotic manipulation, this is a sequential
    % kinematic chain where some links (so_motion and se_motion) vary
    % during calibration, but have known values, while the fixture poses are
    % links with unknown kinematic transforms, but that are held constant
    % across the input data.
    P = so_fixture * so_motion * st_fixture * se_motion * se_fixture;
    
    % Calculation of coupling matrix predicted by state and pose.
    calibration = state2calibration(state, options);
    pc_cell{ix} = forward_kinematics(P, calibration);
  end
  
  for (ix = 1:npoints)
    pred_coupling(:,:,ix) = pc_cell{ix};
  end

  r_couplings = real_coupling(couplings);
  for (ix = 1:npoints)
    % Mismatch between measured coupling and predicted coupling
    coupling1 = r_couplings(:, :, ix);
    if (options.normalize)
      da_norm = norm(coupling1);
    else
      da_norm = 1;
    end
    residue(:, :, ix) = (coupling1 - pred_coupling(:, :, ix)) / da_norm;
  end
end
