% Add 0 to the end of each row
function [res] = pad_zeros(x)
res = [x zeros(size(x, 1), 1)];
