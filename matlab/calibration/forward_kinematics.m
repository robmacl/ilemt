function [coupling] = forward_kinematics (P, calibration)
% Return the coupling matrix that we predict we would measure when the 
% sensor is in the specified pose w.r.t the source. P is a 4x4
% linear homogenous transform matrix.
  
  state_defs;
  
  % Since we are representing the quadrupole as two close (but finite
  % spaced) dipoles, we make the code regular by building matrices of the
  % positions and moments for each component dipole, source and sensor.
  % 
  % These four matrices that stack in coloums the source and sensor
  % positions and moment of the dipole, positive quadrupole and negative
  % quadrupole 
  % 
  % ### these are built inside the loop that uses them.  So I guess they don't
  % actually need to be matrices, but do serve to save away the iteration
  % results for inspection.
  so_pos = zeros(9,3);
  se_pos = zeros(9,3);
  
  %source and sensor moments matricies. It includes all dipole and quadrupole moments
  % 
  % ### should one qpole moment be negated?  I think so.  In which case we
  % sort of had another floating dipole in the optimization.
  %{
  so_mo = [calibration.d_source_moment; calibration.q_source_moment; calibration.q_source_moment];
  se_mo = [calibration.d_sensor_moment; calibration.q_sensor_moment; calibration.q_sensor_moment];
  %}
  so_mo = [calibration.d_source_moment; calibration.q_source_moment; -calibration.q_source_moment];
  se_mo = [calibration.d_sensor_moment; calibration.q_sensor_moment; -calibration.q_sensor_moment];
  
  coupling = zeros(3,3);
  
  %consider all 9 possible combination of source/sensor dipole with source/sensor quadrupole 

  % over source component dipoles
  % ### so_pos and se_pos are flattened on the first dimension, hence 
  % [1 4 7].  Would be clearer with a 3D array.
  for so_comp = [1 4 7] 
    % over sensor component dipoles
    for se_comp = [1 4 7] 
      % Count of qpole moments which are zero.  If any of the XYZ moments (source or
      % sensor) are zero, then we drop out the quadrupole terms.  
      % ### except that this doesn't actually happen
      a = 0;
      b = 0;
      
      %adjust source and sensor position for the quadrupole 
      % ### this loop is invariant wrt. the outer loops.  It should give
      % the same result if it were moved to before the so_comp, se_comp
      % loops.  Except it is computing a, b, for the zero test.  Except we
      % are not actually using those.
      for axis = 1:3
        %source 
        so_pos(1:3,axis) = calibration.d_source_pos(:,axis);

        m_so_mag = norm(calibration.q_source_moment(:,axis));

        if (m_so_mag < 1e-9)
          a = a+axis;
        else
          m_so_off = (calibration.q_source_moment(:,axis)/m_so_mag)*(calibration.q_source_distance/2);
          p_so_pos = calibration.q_source_pos(:,axis) + m_so_off;
          n_so_pos = calibration.q_source_pos(:,axis) - m_so_off;
          so_pos(4:end,axis) = [p_so_pos; n_so_pos];
        end
        
        
        %sensor
        se_pos(1:3,axis) = calibration.d_sensor_pos(:,axis);

        m_se_mag = norm(calibration.q_sensor_moment(:,axis));

        if (m_se_mag < 1e-9)
          b = b+axis; 
        else
          m_se_off = (calibration.q_sensor_moment(:,axis)/m_se_mag)*(calibration.q_sensor_distance/2);
          p_se_pos = calibration.q_sensor_pos(:,axis) + m_se_off;
          n_se_pos = calibration.q_sensor_pos(:,axis) - m_se_off;
          se_pos(4:end,axis) = [p_se_pos; n_se_pos]; 
        end
      end
      
      %when we are considering source quadrupole and its magnitude is very
      %small the coupling will be 0
      % ### 4, 7 are the quadrupole components
      if ((so_comp == 4) || (so_comp == 7))
        if (a ~= 0)
          i_coupling = zeros(3,3);
        end
      end
      
      %when we are considering sensor quadrupole and its magnitude is very
      %small the coupling will be 0
      if ((se_comp == 4) || (se_comp == 7))
        if (b ~= 0)
          i_coupling = zeros(3,3);
        end
      end
      
      % ### oops, we just clobbered the zero special case.  I guess this is OK?  In
      % fk_coupling we only normalize the source-sensor displacement, which is
      % not going to be zero.  Perhaps all to the good, because zeroing the
      % coupling would likely be a problem for optimization, since it would
      % have no idea which way to move away from zero.  Seems what happens is
      % that the qpole component positions are left at the origin, both at the
      % same position?  This would cancel now that signs are correctly
      % opposite.  This does not seem to defeat optimization, though.  I guess
      % it picks a step larger than our threshold.
      i_coupling = fk_coupling(P, so_pos(so_comp:so_comp+2,:), so_mo(so_comp:so_comp+2,:), ...
                               se_pos(se_comp:se_comp+2,:), se_mo(se_comp:se_comp+2,:));
      
      % The final coupling is the sum of all the couplings obtained with all the
      % possible dipole-quadrupole combinations
      coupling = coupling + i_coupling;
      
    end
  end
  
  coupling = coupling./250;

end
