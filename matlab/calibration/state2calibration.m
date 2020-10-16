 function [calibration] = state2calibration (state, ishigh)
% Given calibration optimizer state vector, return calibration struct for 
% high or low carrier.  If ishigh is true, then this is the calibration
% for the high carrier.
%
% Source and sensor parameters are represented as a 3x3 matrix, where
% columns are the coils (X, Y, Z), and rows are the vector/point XYZ
% coordinates in the source or sensor coordinate system.
% 
% calibration.source_pos:
%     2D matrix of source coil positions (in source coordinates, in meters).
%
% calibration.source_moment:
%     Source moment vectors matrix.  The direction of the vector is the
%     coil axis, and the magnitude is the coil gain.
%
% calibration.sensor_pos
% calibration.sensor_moment:
%     Offset and moment of sensor coils, in sensor coordinates.
% 
 state_defs;
    assert(ishigh);
    
   %DIPOLE
     % position and moment of X Y Z source coils in source coordinates
    calibration.d_source_pos = [...
        state(source_x_pos_slice)' ...
        state(source_y_pos_slice)' ...  
        [0 0 0]'];
    
     calibration.d_source_moment = [...
        state(source_x_moment_slice)' ...
        state(source_y_moment_slice)' ...  
        [0 0 1]'];
    
    % position and orientation of X Y Z sensor coils in sensor coordinates
     calibration.d_sensor_pos = [...
        state(sensor_x_pos_slice)' ...
        state(sensor_y_pos_slice)' ...  
        [0 0 0]'];
    
     calibration.d_sensor_moment = [...
        state(sensor_x_moment_slice)' ...
        state(sensor_y_moment_slice)' ...  
        [0 0 state(sensor_z_gain)]'];
      
      
    %QUADRUPOLE  
     calibration.q_source_pos = [...
        state(qp_source_x_pos_slice)' ...
        state(qp_source_y_pos_slice)' ...  
        state(qp_source_z_pos_slice)'];
    
     calibration.q_source_moment = [...
        state(qp_source_x_moment_slice)' ...
        state(qp_source_y_moment_slice)' ...  
        state(qp_source_z_moment_slice)'];
    
    % position and orientation of X Y Z sensor coils in sensor coordinates
     calibration.q_sensor_pos = [...
        state(qp_sensor_x_pos_slice)' ...
        state(qp_sensor_y_pos_slice)' ...  
        state(qp_sensor_z_pos_slice)'];
    
     calibration.q_sensor_moment = [...
        state(qp_sensor_x_moment_slice)' ...
        state(qp_sensor_y_moment_slice)' ...  
        state(qp_sensor_z_moment_slice)'];
     
     %quadrupole source distance
     calibration.q_source_distance = state(qp_so_dist); 
     
     %quadrupole sensor distance
     calibration.q_sensor_distance = state(qp_se_dist); 
end
