function [options] = check_poses_defaults ()
% end_tf_offset: A pose vector of the "End transform offset" or other
%   orientation offset.
%
% pose_ix: which pose to check: 2=high rate (only option currently).
% 
% do_optimize: whether to do optimization of fixture transform to try to
%   reduce error.  Default false.
%    
% moment: moment used in optimization to trade angular vs. translation
%   error (m).
% 
% axis_limits(6, 2): for each axis, the [min, max] range of data to
%   analyze (mm, degrees).  Outside this range is discarded.
%
% sg_filt_{N,F}: parameters to Savitzky-Golay filter used in axis sweep
%   analysis.
%
% xyz_exaggerate: exaggeration to use in 3D error views.
    
  options = struct('end_tf_offset', [0 0 0 0 0 0], ... 
                   'pose_ix', 2, ...
                   'do_optimize', false, ...
                   'moment', 0.05, ...
                   'axis_limits', repmat([-inf, inf], 6, 1), ...
                   'sg_filt_N', 2, ... % S-G polynomial order (< F)
                   'sg_filt_F', 17, ... % S-G window width (odd)
                   'onax_ignore_Rz_coupling', true, ...
                   'xyz_exaggerate', 5);
end
