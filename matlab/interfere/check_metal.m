options = interfere_options('concentric', true, 'cal_directory', '../../ilemt_cal_data/cal_9_15_premo_cmu/output/');
[cal, options] = load_interfere_cal(options);

%options.in_files = {'output_files_x_moving_solid0.dat'}
%options.in_files = {'noise_test_out.dat'}
options.in_files = {'drift_test.dat'}
[motions, couplings] = read_cal_data(options);
[poses, valid, resnorms] = pose_solution(couplings, cal, options);

delta = pose_difference(poses(2:end, :), repmat(poses(1,:), size(poses, 1) - 1, 1));
delta2 = delta.^2;
err_trans = sqrt(sum(sum(delta2(:,1:3)))/size(delta2, 1))
err_rot = sqrt(sum(sum(delta2(:,4:6)))/size(delta2, 1))

%{
% Drift plot
plot(1e6 * sqrt(sum(delta2(:,1:3), 2)))
ylabel('Position drift (\mu m)')
xlabel('Time (minutes)')
ylim([0 100])
xlim([0 200])
%}
