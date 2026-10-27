function [coupling] = forward_kinematics (P, calibration)
% Return the coupling matrix that we predict we would measure when the sensor
% is in the specified pose w.r.t the source. P is a 4x4 linear homogenous
% transform matrix, or a 4x4xN stack of them, in which case coupling is
% 3x3xN.

  % Quadrupole source and sensor moments.  Axes are forced to zero if they are
  % very small.  Because of our efficiency special case for near-zero
  % quadrupole you need to give a nonzero initial value to the quadrupole
  % moment order for any quadrupole optimization to happen.
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
      if (calibration.pin_quadrupole)
        o_q_pos = calibration.d_source_pos(:, axis);
      else
        o_q_pos = calibration.q_source_pos(:, axis);
      end
      so_pos(:, axis, 2) = o_q_pos + m_so_off;
      so_pos(:, axis, 3) = o_q_pos - m_so_off;
    end
    
    %sensor
    % Copy main dipole
    se_pos(:, axis, 1) = calibration.d_sensor_pos(:, axis);

    m_se_mag = norm(q_se_mo(:, axis));
    if (m_se_mag < 1e-9)
      q_se_mo(:, axis) = 0;
    else
      m_se_off = (q_se_mo(:, axis)/m_se_mag)*(calibration.q_sensor_distance/2);
      if (calibration.pin_quadrupole)
        e_q_pos = calibration.d_sensor_pos(:, axis);
      else
        e_q_pos = calibration.q_sensor_pos(:, axis);
      end
      se_pos(:, axis, 2) = e_q_pos + m_se_off;
      se_pos(:, axis, 3) = e_q_pos - m_se_off;
    end
  end

  % Moments for source and sensor component dipoles: dipole, +q, -q 
  so_mo = cat(3, calibration.d_source_moment, q_so_mo, -q_so_mo);
  se_mo = cat(3, calibration.d_sensor_moment, q_se_mo, -q_se_mo);

  % Octupole (finite coil size) components, pages 4 and 5, and the transverse
  % anisotropy, pages 6 to 9.
  if (isfield(calibration, 'o_source'))
    if (isfield(calibration, 'a_source'))
      a_so = calibration.a_source; a_se = calibration.a_sensor;
    else
      a_so = [0 0 0]; a_se = [0 0 0];
    end
    [so_pos, so_mo] = add_octupole(so_pos, so_mo, calibration.d_source_pos, ...
                                   calibration.d_source_moment, ...
                                   calibration.o_source, a_so);
    [se_pos, se_mo] = add_octupole(se_pos, se_mo, calibration.d_sensor_pos, ...
                                   calibration.d_sensor_moment, ...
                                   calibration.o_sensor, a_se);
  end

  coupling = zeros(3, 3, size(P, 3));

  % Sum all possible combinations of source/sensor component dipoles,
  % skipping combinations where either source or sensor moments are all
  % zeros.  The zero case is an optimization for when we are not including
  % quadrupole or octupole in the source or sensor models.
  for (so_comp = 1:size(so_mo, 3))
    % over source component dipoles
    so_mo1 = so_mo(:, :, so_comp);
    if (any(any(so_mo1 ~= 0)))
      for (se_comp = 1:size(se_mo, 3))
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
  % would be this much smaller to get the right coupling w/o this scaling.
  % This makes the source and sensor moments more similar in magnitude (closer
  % to 1), which may help optimization, and is also convenient for printout.
  coupling = coupling./250;
end


function [pos, mo] = add_octupole (pos, mo, d_pos, d_mo, o_s, o_t)
% Add the octupole (finite coil size) term for each coil as component dipole
% pages 4 and 5, and its transverse anisotropy as pages 6 to 9.
%
% A coil whose windings are spread out with axial variance sa^2 and
% transverse variance (per transverse axis) st^2 has, to leading order, the
% field of a dipole plus 1/2 * s * (u . grad)^2 B_dipole, where u is the coil
% axis and s = sa^2 - st^2.  (The trace of the spread has no effect because
% div grad B = 0 outside the coil.)  For a solenoid of length L and loop
% radius a, s = L^2/12 - a^2/4, which is zero at L/D = 0.866 (Paperno &
% Plotkin's dipole-like coil).  A square pancake of half-side c has s about
% -c^2/3.  By reciprocity the same form applies to the sensor coils.
%
% We evaluate the derivative with a centered difference over +/- delta along
% the coil axis, which is a center dipole with moment (1 - w) m plus two with
% moment w/2 m at +/- delta, where w = s / delta^2.  The O(delta^2/r^2)
% truncation error is negligible at our ranges.
%
% A winding that is not round has different variances sv^2 and sw^2 along
% the two transverse axes v and w.  This adds
% t/4 * ((v . grad)^2 - (w . grad)^2) B_dipole, where t = sv^2 - sw^2 (s then
% uses the mean transverse variance).  A rectangular loop a (along v) by b
% (along w) has t = (a^2 - b^2)/12.  The transverse axes are the coil frame
% axes in cyclic order, made orthogonal to u: for coil X, v ~ Y and w ~ Z;
% coil Y, v ~ Z, w ~ X; coil Z, v ~ X, w ~ Y.  The centered differences
% along v and w give four dipoles of moment +/- t / (4 delta^2) m; their
% center terms cancel.
%
% o_s: s for coils X Y Z, in mm^2.
% o_t: t for coils X Y Z, in mm^2.
  delta = 1e-3;
  w = o_s(:)' * 1e-6 / delta^2;
  wt = o_t(:)' * 1e-6 / (4 * delta^2);
  if (all(w == 0) && all(wt == 0))
    return;
  end
  u = d_mo ./ vecnorm(d_mo);
  mo(:, :, 1) = mo(:, :, 1) .* (1 - w);
  pos(:, :, 4) = d_pos + delta * u;
  pos(:, :, 5) = d_pos - delta * u;
  mo(:, :, 4) = d_mo .* (w / 2);
  mo(:, :, 5) = d_mo .* (w / 2);
  if (all(wt == 0))
    return;
  end
  I3 = eye(3);
  v = I3(:, [2 3 1]);
  v = v - u .* sum(v .* u);
  v = v ./ vecnorm(v);
  ww = cross(u, v);
  pos(:, :, 6) = d_pos + delta * v;
  pos(:, :, 7) = d_pos - delta * v;
  pos(:, :, 8) = d_pos + delta * ww;
  pos(:, :, 9) = d_pos - delta * ww;
  mo(:, :, 6) = d_mo .* wt;
  mo(:, :, 7) = d_mo .* wt;
  mo(:, :, 8) = -d_mo .* wt;
  mo(:, :, 9) = -d_mo .* wt;
end
