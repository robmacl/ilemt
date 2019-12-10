data_point = [];
for i = 1:n
if(resnorms(i,1) > 3.4e-07)
data_point = [data_point; i];
end
end