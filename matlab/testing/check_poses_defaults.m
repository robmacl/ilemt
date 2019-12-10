function [options] = check_poses_defaults ()
% end_tf_offset: A pose vector of the "End transform offset" or other
%   orientation offset used in asap_stage_calibration.vi.  With grid data,
%   this is used to rotate the points by 45 degrees to make them fit in the
%   workspace better, while the pose isn't correspondingly rotated.  Default
%   is [0 0 0 0 180 0].
%
% pose_ix: which pose in the logged data to check: 2=handle,
%   3=output. Default 3.
% 
% do_optimize: whether to do optimization of fixture transform to try to
%   reduce error.  Default false.
%    
% moment: moment used in optimization to trade angular vs. translation
%   error.  Default 1.
% 
% axis_limits(6, 2): for each axis, the [min, max] range of data to
%   analyze.  Outside this range is discarded. 
%
% sg_filt_{N,F}: parameters to Savitzky-Golay filter used in axis sweep
%   analysis.
%
% xyz_exaggerate: exaggeration to use in 3D error views.  Default 100.
    
  options = struct('data_format', [], ...
                   'end_tf_offset', [0 0 0 0 180 0], ... 
                   'pose_ix', 3, ...
                   'do_optimize', false, ...
                   'moment', 1, ...
                   'axis_limits', repmat([-inf, inf], 6, 1), ...
                   'sg_filt_N', 2, ... % S-G polynomial order (< F)
                   'sg_filt_F', 17, ... % S-G window width (odd)
                   'onax_ignore_Rz_coupling', true, ...
                   'xyz_exaggerate', 100);
end
