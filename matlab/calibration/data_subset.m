%Create a subset of calibration data in different ways
%dat = getreal('bigdata_Zrot.dat');
%dat = XZrot_data_combination('bigdata_Zrot.dat','bigdata_XZrot.dat', 90);
dat = XYZrot_data_combination('bigdata_Zrot.dat','bigdata_XZrot.dat', 90, 'bigdata_XYZrot.dat', 90);

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


for i = 1:n 
  if((dat(i,2)) == -50)
    data = data;
  else
    data = [data; dat(i,:)];
  end
end

%{
for i = 1:n
  dat(i,4) = 90;
  %dat(i,5) = 90;
  if(i == 225)
    data = data;
  else
    data = [data; dat(i,:)];
  end
end
%}

%{
for i = 1:n 
  if(i == 161 || i == 188 || i == 293) % || i == 1640)
    data = data;
  else
    data = [data; dat(i,:)];
  end
end
%}

