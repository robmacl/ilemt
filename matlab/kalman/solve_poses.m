function [outfile] = solve_poses (trackfile)
% Read ilemt_ui .trace data and convert to poses in .mat file
  [path,name,ext] = fileparts(trackfile);
  if (isempty(ext))
    ext = 'trace';
  end
  data = read_track_file([path filesep name ext]);
  options = track_options();
  options.cal_file_base = '../cal_9_1_premo_rotated_dipole/output/XYZ';
  options.hemisphere = 3;

  track = track_pose_solution(data, options);
  outfile = [path filesep name '_poses'];
  save(outfile, '-struct', 'track');
end
