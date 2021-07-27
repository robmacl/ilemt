% Update naming convention for calibration output data in the current
% directory.

sizes = {'sd', 'md', 'ld'};
fixtures = {'Z_rot', 'so+X+Y+Z_se+X+Y+Z'
            'X_rot', 'so+X+Y+Z_se+X-Z+Y'
            'Y_rot', 'so+X+Y+Z_se-Y-Z+X'
            };

for (size_ix = 1:length(sizes))
  for (fix_ix = 1:size(fixtures, 1))
    oldfile = sprintf('%s_%s.dat', fixtures{fix_ix, 1}, sizes{size_ix});
    newfile = sprintf('%s_%s.dat', fixtures{fix_ix, 2}, sizes{size_ix});
    if (exist(oldfile, 'file'))
      fprintf(1, 'Moving %s to %s\n', oldfile, newfile);
      movefile(oldfile, newfile);
    end
  end
end