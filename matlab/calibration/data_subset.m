%create a subset of calibration data
dat = getreal('new_fixture_calibrate_X90_out.dat');
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
  data = [data; dat(i,:)];
end
