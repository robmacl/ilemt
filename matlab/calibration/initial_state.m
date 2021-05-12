function [state] = initial_state (~)
% Return an initial state for the calibration optimization.

%dipole gains
%d_source_gains = [1 1 1];
%d_sensor_gains = [0.1, 0.1, 0.1]; 

% sensor X seems to have a hardware sign flip, wires crossed in the sensor I
% guess.  This causes the X phase calibration to be flipped also, negating
% the X source moment.
%d_source_gains = [-0.45 0.6 1];
%d_sensor_gains = [-0.45 0.45 0.45];
d_source_gains = [0.9 0.9 1];
d_sensor_gains = [0.2 0.2 0.2];


% Coil approximate measured positions for dipole approximating cube-corner
% configuration source fixture.  The z coil is ~2mm closer in than it was
% supposed to be.
cal.d_source_pos = [
    0.044 0 0
    0 0.044 0
    -0.044 -0.044 0];

% Source positions for old cubical concentric source.  This just expresses the
% concentricity.  If we use these (old) coil locations and the old
% source/sensor gains, then the new forward_kinematics() should give the same
% results as the old fk2() with the old calibration.  
 %cal.source_pos = zeros(3, 3);

% We can start using the source gains from the old source, through the new
% source is weaker.  It would be possible to calibrate the new source using
% the old procedure, using data from just the three orthogonal positions.
cal.d_source_moment = diag(d_source_gains);

cal.d_sensor_pos = [
    0.015 0 0
    0 0.015 0
    -0.015 -0.015 0];
  
cal.d_sensor_moment = diag(d_sensor_gains); 


%we start from quadrupole initial values of 0
cal.q_source_pos = zeros(3, 3);

cal.q_source_moment = zeros(3,3);

cal.q_sensor_pos = zeros(3, 3);

cal.q_sensor_moment = zeros(3,3);

cal.q_source_distance = 0.004;

cal.q_sensor_distance = 0.0005;


% This expresses that we expect the stage null pose to be +200mm wrt. the
% source, but angularly aligned with the source.  This places us solidly in
% the +x hemisphere.

cal.source_fixture = [0.22, 0, -0.025, 0, 0, -pi/2];


% We expect the sensor to be angularly aligned with the stage, when in the
% null pose.
cal.sensor_fixture = [zeros(1, 5), pi/2];

state = calibration2state(cal);

