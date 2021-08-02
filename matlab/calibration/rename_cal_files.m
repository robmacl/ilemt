% Update naming convention for calibration output data in the current
% directory.

sizes = {'sd', 'md', 'ld', 'source'};
fixtures = {'Z_rot', 'soYoutZup_seYoutZup'
            'X_rot', 'soYoutZup_seZinYup'
            'Y_rot', 'soYoutZup_seZinXup'
            'so+X+Y+Z_se+X+Y+Z', 'soYoutZup_seYoutZup'
            'so-Y+X+Z_se+X+Y+Z', 'soXoutZup_seYoutZup'
            'so+Z-Y+X_se+X+Y+Z', 'soZoutYup_seYoutZup'
            'so+Y+Z+X_se+X+Y+Z', 'soXinYup_seYoutZup'
            'so+X+Y+Z_se+X-Z+Y', 'soYoutZup_seZinYup'
            'so+X+Y+Z_se-Y-Z+X', 'soYoutZup_seZinXdown'
            
            'soYoutZup_seZinXup', 'soYoutZup_seZinXdown'
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
