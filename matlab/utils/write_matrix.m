% This function provides a way to export >=2D matrices as ASCII data that can
% be read into Labview.  Size information is explicitly passed so the reader
% needn't know what size is expected, and multiple named arrays can be written
% to a single file.  For what it's worth, the file format also has a syntactic
% hook for adding other types of entries.
%
function [] = write_matrix(fid, name, m)

m_dims = size(m);
ndims = length(m_dims);
lines = m_dims(1) * prod(m_dims(3:end));
cols = m_dims(2);

% This is the the dimension permutation of the row-major result w.r.t. the
% Matlab array.  The dimensions are reversed because of the
% column-major/row_major switch, but the first two dimensions (in Matlab)
% become the last two dimensions in Labview (without switching) because
% everyone agrees on the text layout of rows and columns (just not on which
% index is considered first or last.)  This keeps the planes looking the same.
dims_perm = [ndims:-1:3 1 2];

fprintf(fid, '%s %d matrix', name, lines);
fprintf(fid, ' %d', m_dims(dims_perm));
fprintf(fid, '\n');

% In order to convert to 2D array of rows in row-major order we need to
% permute the dimension order, reversing them, *except* for the row, which
% stays last.
if (ndims > 2)
  dims_perm2 = [dims_perm((ndims-1):-1:1) 2];
  m = permute(m, dims_perm2);
  m = reshape(m, lines, cols);
end

for (ix = 1:lines)
  fprintf(fid, '%.16g\t', m(ix, 1:(cols-1)));
  fprintf(fid, '%.16g\n', m(ix, cols));
end
