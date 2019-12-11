% Add 1 to the end of each row
function [res] = pad_ones(x)
res = [x ones(size(x, 1), 1)];

