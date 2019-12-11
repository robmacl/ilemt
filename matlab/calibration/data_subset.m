%create a subset of calibration data
dat = getreal('reptest2_out.dat');
%dat = XZrot_data_combination('new_fixture_calibrate_out.dat', 'new_fixture_X90_calibrate_out.dat', 90);
%dat = XYZrot_data_combination('new_fixture_calibrate_out.dat','new_fixture_X90_calibrate_out.dat', 90, 'new_fixture_XY90_calibrate_out.dat', 90);
%dat = XZrot_data_combination('zcoilalignment_5_50_calibrate.dat', 'new_fixture_X90_calibrate_5_50_out.dat',90);
%dat = XYZrot_data_combination('zcoilalignment_5_50_calibrate.dat', 'new_fixture_X90_calibrate_5_50_out.dat',90, 'new_fixture_XY90_calibrate_5_50_out.dat',90);
n = size(dat);
data = [];

%{
for i = 1:n
  if((all(dat(i,1:5) == 0)) && ((dat(i,6) == 90) || (dat(i,6) == -90)))
    data = [data; dat(i,:)];
  end
   if(all(dat(i,1:5) == 0))
    data = [data; dat(i,:)];
  end
end
%}

%{
for i = 1:388
  data = [data; dat(i,:)];
end
%}

%{
for i = 3:n 
  if((dat(i,6) == 90)
    data = data;
  else
    data = [data; dat(i,:)];
  end
end
%}


for i = 1:n
  dat(i,4) = 90;
  %dat(i,5) = 90;
  if(i == 225)
    data = data;
  else
    data = [data; dat(i,:)];
  end
end


%{
for i = 1:n 
  if(i == 631 || i == 1488) %|| i == 1639 || i == 1640)
    data = data;
  else
    data = [data; dat(i,:)];
  end
end
%}
