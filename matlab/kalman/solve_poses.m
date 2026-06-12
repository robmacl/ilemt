function [outfile] = solve_poses (trackfile)
% Read ilemt_ui .trace data and convert to poses in .mat file
  [path,name,ext] = fileparts(trackfile);
  if (isempty(ext))
    ext = '.trace';
  end
  disp([path name ext])
  data = read_track_file([path name ext]);
  options = track_options();
  options.cal_file_base = 'C:/Users/robertm2/Documents/Work/ilemt_cal_data/cal_9_15_premo_cmu/output/XYZ';
  options.hemisphere = 3;

  track = track_pose_solution(data, options);
  outfile = [path name '_poses'];
  save(outfile, '-struct', 'track');
end
