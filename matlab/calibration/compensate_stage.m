function [comp_motion] = compensate_stage (motion)
% Apply corrections to the stage motion.  Currently we are only
% correcting the large X deviation due to Z motion.
  
% This pose sequence gives us Z motion which is approximately straight
% in X, according to absoute axis positions.  Because Rz is before X
% the Z off-axis error rotates with Rz.  Rows are stage pose format,
% XYZ in mm, but are absolute axis mode.  Since this is compensated motion,
% the needed X correction is opposite to the X here.

compensated = [
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

dx = -interp1(compensated(:, 3), compensated(:, 1), motion(:, 3), 'linear', 'extrap');

comp_motion = zeros(size(motion));
for (ix = 1:size(motion, 1))
  dp = zeros(1, 6);
  Rz = motion(ix, 6) / 180 * pi;
  dp(1) = cos(Rz) * dx(ix);
  dp(2) = sin(Rz) * dx(ix);
  comp_motion(ix, :) = motion(ix, :) + dp;
end

