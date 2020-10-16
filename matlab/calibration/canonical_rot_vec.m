%Convert rotation vector of pose solition into canonical rotation vectors
function [poses] = canonical_rot_vec(opt_poses)
poses = [];
n = size(opt_poses,1);

for i = 1:n
  poses(i,:) = opt_poses(i,:);
  mag_r = norm(opt_poses(i,4:6));
  unit_r = opt_poses(i,4:6)/mag_r;
  %Subtract pi until the magnitude of the rotatin vector is more than pi
  while (mag_r >= pi)
    mag_r = mag_r - 2*pi;
  end
  %set direction of rotation vector 
    if (mag_r < 0)
      can_r = -mag_r * (-unit_r);
      poses(i,:) = [opt_poses(i,1:3), can_r];
    else
      can_r = mag_r * unit_r;
      poses(i,:) = [opt_poses(i,1:3), can_r];
    end
  end
end 
  