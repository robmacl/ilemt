function [werr] = weighted_error (perr, options)
% Weight the rotation error by the moment
npoints = size(perr.desired, 1);
mo_scale = [ones(npoints, 3) ones(npoints, 3) * options.moment];
werr = perr.errors .* mo_scale;
