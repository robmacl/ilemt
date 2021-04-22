function [bounds] = state_bounds (state0, optimize, freeze)
% Compute state bounds which allow only a subset of the state to be optimized.
% See state_defs.m for the shorthand string names, which map onto the state
% vector.
% 
% state0: 
%     The initial state, used to set bounds for parts that are not to be
%     optimized.
% 
% bounds: 
%     specifies the lower and upper bounds on each state element.  This is a
%     2xN vector, where the first row is the lower bounds, and the second row
%     is the upper bounds.  Each column is either [-Inf; Inf] to optimize, or
%     [state0(n); state0(n)] to not optimize (freeze).
% 
% optimize:
%     Cell vector of string state part names to optimize.
% 
% freeze:
%     Cell vector of string state part names to *not* optimize, even though
%     they may have been enabled by the "optimize" spec.  This is useful to
%     freeze parts of a thing which is otherwise optimized.

if (nargin < 3)
  freeze = {};
end
  
bounds = [state0; state0];

for (ix = 1:length(optimize))
  s_ixs = lookup(optimize{ix});
  for (s_ix = s_ixs)
    bounds(:, s_ix) = [-Inf; Inf];
  end
end

for (ix = 1:length(freeze))
  s_ixs = lookup(freeze{ix});
  for (s_ix = s_ixs)
    bounds(:, s_ix) = [state0(s_ix); state0(s_ix)];
  end
end

end % state_bounds


% non-nested function
function [state_ixs] = lookup (name)
  state_defs;
  p_ix = find(strcmp(name, state_parts(:, 1)));
  if (isempty(p_ix))
    error('Unknown state part: %s', name);
  end
  state_ixs = state_parts{p_ix, 2};
end
