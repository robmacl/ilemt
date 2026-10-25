function claude_bridge_stop (quiet)
% Stop the Claude bridge timer (see claude_bridge_start) and close its diary.
if (nargin < 1)
  quiet = false;
end
t = timerfindall('Tag', 'ClaudeBridge');
if (~isempty(t))
  st = t(1).UserData;
  stop(t);
  delete(t);
  if (strcmp(get(0, 'DiaryFile'), st.session))
    diary off;
  end
  if (~quiet)
    fprintf(1, 'Claude bridge stopped.\n');
  end
end
end
