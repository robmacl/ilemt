function [residue, pred_coupling, bias] = calibrate_objective ...
      (state, stage_poses, couplings, options)
% The guts of the objective function for the calibration optimization.  
% state:
%    The current optimization state, passed in from the optimizer.
%
% stage_poses:
%     A 2D array, where each row is a "pose" vector of the format used in the
%     calibrator output data file, [Y Y Z Rx Ry Rz], where the rotation
%     is Z Y X Euler angles, not a rotation vector.  See pvec2tr().
%
% couplings:
%     A 3D array of measured complex couplings, where the third dimension is
%     parallel to stage poses.  That is, the pose for the N'th coupling
%     couplings(:, :, N) is stage_poses(N, :).
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
% 
% bias:
%     Bias estimate for coupling measurements (complex 3x3)

  state_defs;
  
  %number of stage poses 
  npoints = size(stage_poses, 1);
  
  %verify that the number of coupling matrices is equal to the number of
  %the stage poses we have
  assert(size(couplings, 3) == npoints);
  
  %Extract source_fixture and sensor_fixture from state vector and
  %convert to transform matrices
  source_fixture = pose2trans([state(source_fixture_pos_slice), ...
                      state(source_fixture_orientation_slice)]);
  sensor_fixture = pose2trans([state(sensor_fixture_pos_slice), ...
                      state(sensor_fixture_orientation_slice)]);

  % Preallocate results
  residue = zeros(size(couplings));
  pred_coupling = zeros(size(couplings));
  
  for ix = 1:npoints
    %Convert stage_poses(ix, :) to transform matrix st
    st = vector2tr(stage_poses(ix,:)); 
    
    %transform matrix, sensor with respect to the source, of ix pose
    %forward kinematics 
    P = source_fixture * st * sensor_fixture;
    
    % calculation of predicted coupling matrix with the forward kinematic approach
    pred_coupling(:,:,ix) = forward_kinematics(P, state2calibration(state));
  end


  if (options.debias)
    % Find the nominal phase of each coupling.  Ideally the complex coupling
    % has been corrected for phase in ilemt_ui so that the magnitude is
    % entirely real, but this is imperfect.  In order to extract the small
    % bias as complex we have to project the predicted coupling back to the
    % expected phase.  This is done by multiplying the predicted real
    % coupling by the phasor, giving it a rotation in the complex plane.
    %  
    % How do we find this phasor?  We want the real part positive (right half
    % plane) so that we don't cause any extra sign flips.  So each coupling
    % is sign flipped (180 degree rotation) if it has a negative real part.
    % Then we take a weighted mean of each 3x3 coupling position and scale it
    % into a unit vector.
    % ### this is a constant function of the couplings, so does not change
    % during optimization, and does not need to be in here.
    csum = sum(couplings .* sign(real(couplings)),3);
    nom_phasor = csum ./ abs(csum);
    p_c_complex = repmat(nom_phasor, 1, 1, npoints) .* pred_coupling;
    
    % Estimate bias in the complex couplings (a fixed additive offset) and
    % subtract this.  This has to be done in the objective function because our
    % bias estimate is based on the residue.  The bias becomes part of the
    % calibration.  We operate on the complex coupling because the bias may not
    % be in-phase with the desired signal.  The debiased coupling is then
    % converted to real for computing the residue.
    bias = mean(couplings - p_c_complex, 3);
    couplings_debias = real_coupling(couplings - repmat(bias, 1, 1, npoints));
  else
    couplings_debias = real_coupling(couplings);
    bias = zeros(3);
  end

  for (ix = 1:npoints)
    %mismatch between measured coupling and predicted coupling
    coupling1 = couplings_debias(:, :, ix);
    if (options.normalize)
      da_norm = norm(coupling1);
    else
      da_norm = 1;
    end
    residue(:, :, ix) = (coupling1 - pred_coupling(:, :, ix)) / da_norm;
  end
end
