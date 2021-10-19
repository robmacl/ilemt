function [comp_motion] = compensate_stage (motion)
% Apply corrections to the stage motion.  (Stage vector2tr() format, mm/degree
% Euler angles.)

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
% and error_mm is the to-axis error (which should be subtracted from the
% to-axis position).
comp_tables = cell(3, 3);


%%% Lookup tables:

% This pose sequence gives us Z motion which is approximately straight
% in X, according to absolute axis positions.  (So X motion is compensation
% rather than error.)

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

comp_tables{3, 1} = flipud([comp1(:, 3) comp1(:, 1)]);


%%% Compensation:

% The sum of the errors at each axis.  Because Rz is before XY in the stage
% kinematics this error is relative to the rotating stage.  XY will be
% rotated later to get it pointed in the right direction.
errors = zeros(size(motion));

for (ix = 1:size(comp_tables, 1))
  for (jx = 1:size(comp_tables, 2))
    tab = comp_tables{ix, jx};
    if (~isempty(tab))
      err1 = interp1(tab(:, 1), tab(:, 2), motion(:, ix), 'linear', 'extrap');
      errors(:, jx) = errors(:, jx) + err1;
    end
  end
end

% Now subtract error, rotating the XY error for Rz
r_errors = errors;
for (ix = 1:size(motion, 1))
  rotxy = rotz(motion(ix, 6) / 180 * pi);
  rotxy = rotxy(1:2, 1:2);
  % Multiply on right for row vector
  r_errors(ix, 1:2) = r_errors(ix, 1:2) * rotxy';
end

comp_motion = motion - r_errors;



