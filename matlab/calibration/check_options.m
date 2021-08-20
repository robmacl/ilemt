function [] = check_options(structs, key_value)
% structs: cell vector of structs
% key_value: vector of key/value pairs
% 
% Check that all the options in key/value pairs appear as fields in one of
% the structs.

if (mod(length(key_value), 2) ~= 0)
  error('Key/value are not in pairs');
end

fnames = fieldnames(structs{1});
for (f_ix = 2:length(structs))
  fnames = cat(1, fnames, fieldnames(structs{f_ix}));
end

keys = key_value(1:2:length(key_value)-1);
badkeys = setdiff(keys, fnames);
if (~isempty(badkeys))
  error('Unrecognized option: %s', badkeys{1});
end
