function [res] = read_track_file (fname, start_ix, end_ix)
% Read track data output from ilemt_ui.  This data is returned both split
% by measurment type (high, low, high_at_low), and also combined in time order.
% "res" is a struct:
% 
% timestamp_high(n_hi, 1): 
%   timestamps of high rate data (seconds from start of file)
% 
% coupling_high(3, 3, n_hi): 
%   coupling matrices for high rate data.
% 
% timestamp_low(n_lo, 1): 
%   timestamps of low rate data (in common for both coupling_low and
%   coupling_high_at_low). 
% 
% coupling_low(3, 3, n_lo):
%   Low carrer output couplings.
% 
% coupling_high_at_low(3, 3, n_lo):
%   High rate couplings measured at the low rate, synchronized with low
%   rate measurement (same bandwidth and latency).
% 
% timestamp_all(n, 1):
%   All measurement record timestamps.
% 
% coupling_all(3, 3, n):
%   All couplings.
% 
% entry_type(n, 1):
%   The type of measurement entry: 0=high rate, 1=low rate, 2=high at low.
% 
data = dlmread(fname);
if (size(data, 2) ~= 11)
  error('This doesn''t look like a track file: %s', fname);
end

if (nargin < 2 || isempty(start_ix))
  start_ix = 1;
end

if (nargin < 3 || isempty(end_ix))
  end_ix = size(data, 1);
end

data = data(start_ix:end_ix, :);

all_coupling = real_coupling(permute(reshape(data(:, 3:end), [], 3, 3), [2 3 1]));
all_ts = data(:, 1);
all_type = data(:, 2);
res.timestamp_all = all_ts;
res.coupling_all = all_coupling;
res.entry_type = all_type;

hr_mask = (all_type == 0);
res.timestamp_high = all_ts(hr_mask);
res.coupling_high = all_coupling(:, :, hr_mask);
lr_mask = (all_type == 1);
res.timestamp_low = all_ts(lr_mask);
res.coupling_low = all_coupling(:, :, lr_mask);
res.coupling_high_at_low = all_coupling(:, :, all_type == 2);
