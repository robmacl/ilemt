function [cal] = save_text_calibration (cal, ofile)
% Save a calibration data for a text .cal file for use in online pose
% solution.
fid = fopen(ofile, 'w');
if (fid < 0)
  error('Failed to open %s for writing', ofile);
end

write_matrix(fid, 'd_source_pos', cal.d_source_pos);
write_matrix(fid, 'd_source_moment', cal.d_source_moment);
write_matrix(fid, 'd_sensor_pos', cal.d_sensor_pos);
write_matrix(fid, 'd_sensor_moment', cal.d_sensor_moment);
% Not dumping the fixtures and quadrupole stuff, which we are unlikely to use.
write_matrix(fid, 'linear_correction', cal.linear_correction);

fclose(fid);
