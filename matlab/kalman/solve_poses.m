trackfile = 'free_slide';
data = read_track_file([trackfile '.trace']);
options = track_options('cal_file_base', '../cal_9_1_premo_rotated_dipole/output/XYZ');
track = track_pose_solution(data, options);
save([trackfile '_poses'], '-struct', 'track');
