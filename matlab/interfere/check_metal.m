options = interfere_options('concentric', true);
[cal, options] = load_interfere_cal(options);

options.in_files = {'output_files_x_moving_solid0.dat'}
[motions, couplings] = read_cal_data(options);
[poses, valid, resnorms] = pose_solution(couplings, cal, options);

delta = pose_difference(poses(2:end, :), repmat(poses(1,:), size(poses, 1) - 1, 1));
delta2 = delta.^2;
err_trans = sqrt(sum(sum(delta2(:,1:3)))/size(delta2, 1))
err_rot = sqrt(sum(sum(delta2(:,4:6)))/size(delta2, 1))
