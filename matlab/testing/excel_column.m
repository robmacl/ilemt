function [wot] = excel_column (column, offset)
% Add an offset to an excel column name.
cnum = upper(column) - 'A' + offset;
q = floor(cnum/26);
r = cnum - q*26;
if (q > 0)
  wot = char([q - 1, r] + 'A');
else
  wot = char('A' + r);
end
