function [smooth, deriv, x_out] = sg_filt (x, y, N, F)
  % Use Savitzky-Golay filter to smooth data and first derivitive.  X must be
  % regularly spaced.  If Y is 2D, then the signals are in the columns.  N is
  % the order of polynomial fit and F is the window length.  See sgolay.
  if (size(y, 1) == 1)
    y = y';
  end
  [b,g] = sgolay(N,F);   % Calculate S-G coefficients
  dx = mean(diff(x));

if (1)
  HalfWin  = ((F+1)/2) -1;
  
  % This is ripped from the doc for "sgolay", but "length(x) - N" was a
  % hard-wired 996.  I don't see why we need to subtract N, but there you
  % are.
  x_ix_out = ((F+1)/2):(length(x)-N-(F+1)/2);
  for (col = 1:size(y, 2))
    for (n = x_ix_out)
      % Zero-th derivative (smoothing only)
      smooth(n, col) = dot(g(:,1), y(n - HalfWin: n + HalfWin, col));
  
      % 1st differential
      deriv(n, col) = dot(g(:,2), y(n - HalfWin: n + HalfWin, col));
    end
  end
else
  % This should be pretty equivalent, and more efficient.  Not sure the
  % end conditions and alignment of X are correct.
  smooth = filter(flipud(g(:,1)), 1, y);
  deriv = filter(flipud(g(:,2)), 1, y);
  x_ix_out = ((F+1)/2):(length(x)-(F+1)/2);
end
% Drop data points that weren't computed due to boundary.
  smooth = smooth(x_ix_out, :);
  deriv = deriv(x_ix_out, :);
  x_out = x(x_ix_out);

  deriv = deriv./dx;         % Turn differential into derivative

end
