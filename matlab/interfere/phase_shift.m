options = interfere_options('concentric', true, 'ishigh', true);
[cal, options] = load_interfere_cal(options);

%options.in_files = {'output_files_x_moving_hollow1.dat'}
%options.in_files = {'noise_test_out.dat'}
%options.in_files = {'drift_test.dat'}
options.in_files = {'soXinYup_seYoutZup_ld.dat'}
[motions, couplings] = read_cal_data(options);

% Couplings for the reference no-metal case (mean of first and last)
ref = (couplings(:,:,1) + couplings(:,:,end)) / 2;

% Weighting for couplings based on amplitudes in ref.  Multiply by this to
% weight the phase shift.  Possibly this isn't optimal, but we need to
% weight by amplitude somehow since the phase becomes ill-defined at low
% amplitudes.  This weight should preserve the nominal units on the
% coupling elements (eg. radians).
weight = abs(ref) / sum(sum(abs(ref))) * 9;

data_mask = motions(:,7) ~= 0;

xval = motions(data_mask, 7);
yval = zeros(size(xval));
data = couplings(:,:,data_mask);

phases = {};

for (ix = 1:size(data, 3))
  coupling = data(:,:,ix);
  % Although the input couplings should be near zero phase angle, we are looking
  % for small shifts, so we divide by ref to find the phase difference between
  % this point and ref. This also reduces problems with the phase being
  % flipped 180 degrees.
  phase = angle(coupling ./ ref);
  flip_mask = abs(phase) > pi/2;
  phase(flip_mask) = phase(flip_mask) - pi*sign(phase(flip_mask));
  phases{end+1} = phase;
  w1 = abs(coupling) / sum(sum(abs(coupling))) * 9;
  %w1(abs(coupling) < 5e-3) = 0; 
  % geometric mean
  w_angles = phase .* sqrt(w1 .* weight);
  yval(ix) = sqrt(sum(sum(w_angles.^2))) / 9;
end

semilogy(xval, yval);
ylabel('Phase shift (rad)');
xlabel('Distance (cm)');
