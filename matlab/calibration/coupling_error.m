% Calculate the error used to run the pose optimization
function [error] = coupling_error (calibration, pose, coupling)
  % pose converted into a transform matrix
  P = pose2trans(pose);

  % predicted coupling matrix obtained when the sensor is in a
  % specified position with respect to the source 
  pred_coupling = forward_kinematics(P, calibration);
  
  % difference between measured coupling and predicted coupling
  error = abs(coupling(:) - pred_coupling(:));
end
