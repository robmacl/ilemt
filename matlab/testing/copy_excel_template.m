function [fout, fin] = copy_excel_template (fbase)
% Copy an excel template from the source tree into the ./output/ directory.
  in_path = fileparts(which('perr_axis_stats'));
  fin = [in_path filesep 'template_' fbase '.xlsx'];

  % Append output file with data directory name, so Excel doesn't have a fit
  % with files having the same name.
  ds_name = strsplit(pwd, filesep);
  fout = [pwd filesep 'output' filesep fbase '_' ds_name{end} '.xlsx'];
  
  copyfile(fin, fout);
