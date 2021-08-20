function [cal] = save_calibration (cal, ofile)
% Save a calibration struct in a .mat file.

if (~isempty(ofile))
  save(ofile, '-struct', 'cal');
  fprintf(1, 'Wrote %s\n', ofile);
end
