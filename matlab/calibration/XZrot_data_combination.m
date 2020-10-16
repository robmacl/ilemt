%combine two data files adding X rotation of the stage
function data = XZrot_data_combination( filename1, filename2, x_rot)
%filename1 is the file with only Z rotation
%filename2 is the file with only X rotation
%x_rot is the degree angle rotation to add into the file

data1 = [];
data2 = [];

dat1 = getreal(filename1);
n1 = size(dat1);
for i = 1:n1
  data1 = [data1; dat1(i,:)];
end



dat2 = getreal(filename2);
n2 = size(dat2);
 %rotation along X axis of the stage reference system
  for i = 1:n2
    dat2(i,4) = x_rot;
    data2 = [data2; dat2(i,:)];
  end

data = [data1; data2];

end
