function [residue, pred_coupling] = calibrate_objective (state, stage_poses, couplings)
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
%     A 3D array, where the third dimension is parallel to stage poses.  
%     That is, the pose for the N'th coupling couplings(:, :, N) is
%     stage_poses(N, :).

    state_defs;
    
    %number of stage poses 
    npoints = size(stage_poses, 1);
    
    %verify that the number of coupling matrices is equal to the number of
    %the stage poses we have
    assert(size(couplings, 3) == npoints);
    
    %initialize residue to a matrix of zeros with double dimention of the couplings
    %matrix
    residue = zeros(size(couplings));
    pred_coupling = zeros(size(couplings));
    
    
    for i = 1:npoints
        %Extract source_fixture and sensor_fixture from state vector and
        %convert to transform matrices
        source_fixture = pose2trans([state(source_fixture_pos_slice), state(source_fixture_orientation_slice)]);
        sensor_fixture = pose2trans([state(sensor_fixture_pos_slice), state(sensor_fixture_orientation_slice)]);
        
        %Convert stage_poses(i, :) to transform matrix st
        st = vector2tr(stage_poses(i,:)); 
        
        %transform matrix, sensor with respect to the source, of i pose
        %forward kinematics 
        P = source_fixture * st * sensor_fixture;
        
        %calculattion of predicted coupling matrix with the forward kinematic approach
        pred_coupling(:,:,i) = forward_kinematics(P, state2calibration(state));
        
        %mismatch between measured coupling and predicted coupling
        residue(:,:,i) = (couplings(:,:,i) - pred_coupling(:,:,i))/norm(couplings(:,:,i));

    end

end

