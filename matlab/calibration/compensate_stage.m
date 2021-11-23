function [comp_motion] = compensate_stage (motion)
% Apply corrections to the stage motion.  (Stage vector2tr() format, mm/degree
% Euler angles.)  We adust the commanded position to better reflect reality by
% adding in measured errors.

% We support interaction from any XYZ axis to any XYZ axis, but currently only
% implement some of the interactions.  Might need some work to generalize to
% rotation axes.
% 
% A lookup table is stored at:
%     comp_tables(from_axis, to_axis)
% 
% If the entry is [], then that compensation is not implemented.  Having
% seperate tables for each interaction lets us have different axis measurement
% positions per interaction.  When from_axis == to_axis then this corrects
% the on-axis error.
% 
% The entry
% is an array with rows:
%     [axis_pos_mm, error_mm]
% 
% axis_pos_mm are the from-axis position at which measurements were made,
% and error_mm is the to-axis error (which should be added to the
% to-axis position to get the compensated position including error).
% 
% For convenience in the measurement setup we allow the zero-error reference
% point to be arbitrary.  When compensating, we shift the reference so that
% the to-axis error is 0 when the from-axis position is 0.  This preserves the
% zeroness of the zero position.  This is especially important for XY, since
% we need the position [0, 0] to be on the Rz axis.  During Rz alignment we
% force this alignment based on (uncompensated) absolute axis positions; we
% don't want to go and say that this XY position is *not* zero.
comp_tables = cell(3, 3);


%%% Lookup tables:

% Z->X
% This is the pose sequence which gives us Z motion which is
% approximately straight in X (so is negated error).
comp1 = [
    -0.1	0	50	0	0	0
    -0.088	0	40	0	0	0
    -0.085	0	30	0	0	0
    -0.085	0	20	0	0	0
    -0.07	0	10	0	0	0
    -0.05	0	0	0	0	0
    -0.025	0	-10	0	0	0
    0.01	0	-20	0	0	0
    0.05	0	-30	0	0	0
    0.108	0	-40	0	0	0
    0.14	0	-46	0	0	0
];
comp_tables{3, 1} = [comp1(:, 3) -comp1(:, 1)];


% Z on-axis
comp1 = [
    49		0.130
    29		0.115
    4		0.090
    -21		0.050
    -46		0
    ];
comp1(:, 2) = -comp1(:, 2);
comp_tables{3, 3} = comp1;


% X on-axis
comp1 = [
    50		0
    25		0.040
    0		0.040
    -25		0.050
    -50		0.155
    ];
%comp1(:, 2) = -comp1(:, 2);
comp_tables{1, 1} = comp1;


% Y on-axis
comp1 = [
    50		0
    25		-0.130
    0		-0.200
    -5		-0.230
    -10		-0.135
    -15		-0.155
    -20		-0.257
    -25		-0.310
    -50		-0.350
    ];
comp_tables{2, 2} = comp1;


%%% Compensation:

% The sum of the errors at each axis.  Because Rz is before XY in the stage
% kinematics this error is relative to the rotating stage.  XY will be rotated
% later to get it pointed in the right direction.
errors = zeros(size(motion));

% You might say: "Well, the X error depends on Z, and Z error also depends on
% Z, so don't we have to correct Z before we find the X error?"
% 
% No.  No we don't.  
% 
% Any such effect would be very small, so we are assuming independence between
% the interactions, and we just sum them.
for (ix = 1:size(comp_tables, 1))
  % from axis
  for (jx = 1:size(comp_tables, 2))
    % to axis
    tab = comp_tables{ix, jx};
    if (~isempty(tab))
      % Interpolate, making the error zero at from-axis zero position.
      err1 = interp1(tab(:, 1), tab(:, 2), [0; motion(:, ix)], 'linear', 'extrap');
      err1 = err1(2:end) - err1(1);
      errors(:, jx) = errors(:, jx) + err1;
    end
  end
end

% Now add the error to the commanded position, rotating the XY error for Rz
r_errors = errors;
for (ix = 1:size(motion, 1))
  rotxy = rotz(motion(ix, 6) / 180 * pi);
  rotxy = rotxy(1:2, 1:2);
  % Multiply on right for row vector
  r_errors(ix, 1:2) = r_errors(ix, 1:2) * rotxy';
end

comp_motion = motion + r_errors;
