function [coupling] = forward_kinematics (P, calibration)
% Return the coupling matrix that we predict we would measure when the sensor
% is in the specified pose w.r.t the source. P is a 4x4 linear homogenous
% transform matrix.
  
  state_defs;
  
  % Quadrupole source and sensor moments.  Axes are forced to zero if they are
  % very small.
  q_so_mo = calibration.q_source_moment;
  q_se_mo = calibration.q_sensor_moment;

  % Since we are representing the quadrupole as two close (but finite spaced)
  % dipoles, we make the code regular by building matrices of the positions
  % and moments for each component dipole (source and sensor).  These are
  % computed from the calibration only (not affected by the pose).  The
  % positions and moments are in the source or sensor coordinates, just as
  % for the calibration.  We have simply added new entries for the
  % quadrupole component dipoles.
  % 
  % The first two dimensions are the component dipole positions or moments,
  % where axes are columns (as in the calibration).  The third dimension is
  % the "component", where 1 is dipole, 2 is +quadrupole and 3 is -quadrupole.
  
  % Component dipole positions.  If moment is effectively zero, then the
  % position is placed at the origin, with moment 0.
  so_pos = zeros(3, 3, 3);
  se_pos = zeros(3, 3, 3);

  for (axis = 1:3)
    % ### The code is basically the same for source and sensor, could be factored
    % into a function.

    %source 
    % Copy main dipole
    so_pos(:, axis, 1) = calibration.d_source_pos(:, axis);

    m_so_mag = norm(q_so_mo(:, axis));
    if (m_so_mag < 1e-9)
      q_so_mo(:, axis) = 0;
    else
      m_so_off = (q_so_mo(:, axis)/m_so_mag)*(calibration.q_source_distance/2);
      so_pos(:, axis, 2) = calibration.q_source_pos(:, axis) + m_so_off;
      so_pos(:, axis, 3) = calibration.q_source_pos(:, axis) - m_so_off;
    end
    
    %sensor
    % Copy main dipole
    se_pos(:, axis, 1) = calibration.d_sensor_pos(:, axis);

    m_se_mag = norm(q_se_mo(:, axis));
    if (m_se_mag < 1e-9)
      q_se_mo(:, axis) = 0;
    else
      m_se_off = (q_se_mo(:, axis)/m_se_mag)*(calibration.q_sensor_distance/2);
      se_pos(:, axis, 2) = calibration.q_sensor_pos(:, axis) + m_se_off;
      se_pos(:, axis, 3) = calibration.q_sensor_pos(:, axis) - m_se_off;
    end
  end

  % Component dipole moments
  so_mo = cat(3, calibration.d_source_moment, q_so_mo, -q_so_mo);
  se_mo = cat(3, calibration.d_sensor_moment, q_se_mo, -q_se_mo);

  coupling = zeros(3,3);

  % Sum all 9 possible combinations of source/sensor dipole with source/sensor
  % quadrupole, skipping combinations where either source or sensor moments
  % are all zeros.  The zero case is an optimization for when we are not
  % including quadrupole in the source or sensor models.
  for (so_comp = 1:3)
    % over source component dipoles
    so_mo1 = so_mo(:, :, so_comp);
    if (any(any(so_mo1 ~= 0)))
      for (se_comp = 1:3)
        se_mo1 = se_mo(:, :, se_comp);
        if (any(any(se_mo1 ~= 0)))
          % over sensor component dipoles
          i_coupling = fk_coupling(P, so_pos(:,:, so_comp), so_mo1, ...
                                   se_pos(:, :, se_comp), se_mo1);
          
          % The final coupling is the sum of all the couplings obtained with all the
          % possible dipole-quadrupole combinations
          coupling = coupling + i_coupling;
        end
      end
    end
  end

  % This scaling is traditional.  Was once necessary?  IDK.  Sensor moments
  % would presumably be this much bigger to get the right coupling w/o this
  % scaling.
  coupling = coupling./250;
end
