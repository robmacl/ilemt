function [options] = check_poses_defaults ()
% ishigh: if true, check high rate, otherwise low rate.
% 
% valid_threshold: if pose solution residue is greater than this, then
%   discard the point as "invalid".
% 
% do_optimize: whether to do optimization of fixture transform to try to
%   reduce error.  Default false.
%    
% moment: moment used in optimization to trade angular vs. translation
%   error (m).
% 
% axis_limits(6, 2): for each axis, the [min, max] range of data to
%   analyze (mm, degrees).  Outside this range is discarded.  
%   ### This was an Euler angles style stage pose, now placeholder
%
% sg_filt_{N,F}: parameters to Savitzky-Golay filter used in axis sweep
%   analysis.
%
% xyz_exaggerate: exaggeration to use in 3D error views.
    
  options = struct('ishigh', true, ...
                   'valid_threshold', 1e-4, ...
                   'do_optimize', false, ...
                   'moment', 0.05, ...
                   'axis_limits', repmat([-inf, inf], 6, 1), ...
                   'sg_filt_N', 2, ... % S-G polynomial order (< F)
                   'sg_filt_F', 17, ... % S-G window width (odd)
                   'onax_ignore_Rz_coupling', true, ...
                   'xyz_exaggerate', 5);
end
