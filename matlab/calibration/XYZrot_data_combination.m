function data = XYZrot_data_combination( filename1, filename2, x_rot, filename3, y_rot)
%filename1 is the file with only Z rotation, filename2 is the file with
%only X rotation, filename3 is the file with only Y rotation

data1 = [];
data2 = [];
data3 = [];

%dat1 = dlmread(filename1);
dat1 = getreal(filename1);
n1 = size(dat1);
for i = 1:n1
  data1 = [data1; dat1(i,:)];
end


%dat2 = dlmread(filename2);
dat2 = getreal(filename2);
n2 = size(dat2);

%rotation along the X axis of the stage reference system
  for i = 1:n2
    dat2(i,4) = x_rot;
    data2 = [data2; dat2(i,:)];
  end

%dat3 = dlmread(filename3);
dat3 = getreal(filename3);
n3 = size(dat3);
%rotation along the X axis and along the Y axis of the stage reference system
  for i = 1:n3
    dat3(i,4) = x_rot;
    dat3(i,5) = y_rot;
    data3 = [data3; dat3(i,:)];
  end

data = [data1; data2; data3];
end