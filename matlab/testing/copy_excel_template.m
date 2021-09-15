function [fout, fin] = copy_excel_template (fbase)
% Copy an excel template from the source tree into the ~/output/ directory.
  in_path = fileparts(which('perr_axis_stats'));
  fout = [pwd filesep 'output' filesep fbase];
  fin = [in_path filesep 'template_' fbase];
  copyfile(fin, fout);
