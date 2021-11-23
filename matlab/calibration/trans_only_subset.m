function [] = trans_only_subset (infile, outfile)
% Strip all rotated points out of a calibration data file.

data1 = dlmread(infile);
mask = all(data1(:, 4:6) == 0, 2);
dlmwrite(outfile, data1(mask, :));

