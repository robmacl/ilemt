function [coupling] = forward_kinematics (P, calibration)
% Return the coupling matrix that we predict we would measure when the 
% sensor is in the specified pose w.r.t the source. P is a 4x4
% linear homogenous transform matrix.
    
  state_defs;
  
  %inizialize four matrices that stack in coloums the source and sensor
  %positions and moment of the dipole, positive quadrupole and negative
  %quadrupole 
  so_pos = zeros(9,3);
  se_pos = zeros(9,3);
  
  %source and sensor moments matricies. It includes all dipole and quadrupole moments
  so_mo = [calibration.d_source_moment; calibration.q_source_moment; calibration.q_source_moment];
  se_mo = [calibration.d_sensor_moment; calibration.q_sensor_moment; calibration.q_sensor_moment];
  
  coupling = zeros(3,3);
  
  
  %consider all 9 possible combination of source/sensor dipole with source/sensor quadrupole 
  for j = [1 4 7] %source index
    for k = [1 4 7] %sensor index
      a = 0;
      b = 0;
      
        %adjust source and sensor position for the quadrupole 
        for i = 1:3
          %source 
          so_pos(1:3,i) = calibration.d_source_pos(:,i);

          m_so_mag = norm(calibration.q_source_moment(:,i));

          if (m_so_mag < 1e-9)
           a = a+i;
          else
            m_so_off = (calibration.q_source_moment(:,i)/m_so_mag)*(calibration.q_source_distance/2);
            p_so_pos = calibration.q_source_pos(:,i) + m_so_off;
            n_so_pos = calibration.q_source_pos(:,i) - m_so_off;
            so_pos(4:end,i) = [p_so_pos; n_so_pos];
          end
          
          
          %sensor
          se_pos(1:3,i) = calibration.d_sensor_pos(:,i);

          m_se_mag = norm(calibration.q_sensor_moment(:,i));

          if (m_se_mag < 1e-9)
            b = b+i; 
          else
            m_se_off = (calibration.q_sensor_moment(:,i)/m_se_mag)*(calibration.q_sensor_distance/2);
            p_se_pos = calibration.q_sensor_pos(:,i) + m_se_off;
            n_se_pos = calibration.q_sensor_pos(:,i) - m_se_off;
            se_pos(4:end,i) = [p_se_pos; n_se_pos]; 
          end
        end
  
     %when we are considering source quadrupole and it's magnitude is very
     %small the coupling will be 0
     if ((j == 4) || (j == 7))
       if (a ~= 0)
       i_coupling = zeros(3,3);
       end
     end
     
     %when we are considering sensor quadrupole and it's magnitude is very
     %small the coupling will be 0
     if ((k == 4) || (k == 7))
       if (b ~= 0)
        i_coupling = zeros(3,3);
       end
     end
     
        
     i_coupling = fk_coupling(P, so_pos(j:j+2,:), so_mo(j:j+2,:), se_pos(k:k+2,:), se_mo(k:k+2,:));
      
     %the final coupling will be the sum of all the couplings obtained with
     %all the possible dipole-quadrupole combination
     coupling = coupling + i_coupling;
      
    end
  end
  
  coupling = coupling./250;

end
