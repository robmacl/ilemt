mposes = poses-repmat(mean(poses), size(poses, 1), 1);
wot = sqrt(sum(mposes(:,1:3).^2, 2));
mposes1(wot>1e-4,:) = [];
trans_rms1 = sqrt(sum(mposes1(:,1:3).^2, 2));
trans_rms = sqrt(sum(trans_rms.^2)/size(trans_rms1,1))
