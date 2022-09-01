% Outputs the couplings from the trace file below to a .mat file that the
% C++ implementation can read. Use this to use new data with C++
trace_file = 'noise_still_30s';

% read couplings
[path,name,ext] = fileparts(strcat(trace_file, '.trace'));
data = read_track_file([path name ext]);
couplings_hi_at_lo = data.coupling_high_at_low;
couplings_lo = data.coupling_low;
couplings_hi = data.coupling_high;

% reshape to nx9 matrix
couplings_hi_at_lo = reshape(couplings_hi_at_lo, 9, [])';
couplings_lo = reshape(couplings_lo, 9, [])';
couplings_hi = reshape(couplings_hi, 9, [])';

% transpose each row
couplings_hi_at_lo = couplings_hi_at_lo(:,[1 4 7 2 5 8 3 6 9]);
couplings_lo = couplings_lo(:,[1 4 7 2 5 8 3 6 9]);
couplings_hi = couplings_hi(:,[1 4 7 2 5 8 3 6 9]);

% save
save(strcat(trace_file, "_couplings.mat"), ...
    "couplings_hi_at_lo", "couplings_lo", "couplings_hi");