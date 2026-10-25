function claude_bridge_start (ex_dir)
% Start the Claude bridge: lets Claude (via the mlrun shell script) run
% commands in this MATLAB session, sharing the base workspace and the Command
% Window.
%
% A timer polls <ex_dir>/inbox for cmd_*.m files.  Each one is echoed as
% "[claude] >> ...", added to the command history, and evaluated in the base
% workspace.  Commands only run when MATLAB is idle (at the prompt, or
% during pause/drawnow), so they never interrupt what you are doing.
%
% All Command Window output, yours and Claude's, goes to the diary
% <ex_dir>/session.log, which is how Claude sees the output.  If something
% else takes over the diary (eg. run_tests), the bridge takes it back the
% next time it runs a command.
%
% ex_dir defaults to the exchange/ directory next to this file.
% Stop with claude_bridge_stop.

if (nargin < 1)
  ex_dir = fullfile(fileparts(mfilename('fullpath')), 'exchange');
end

claude_bridge_stop(true);

sub = {'inbox', 'running', 'done'};
for ix = 1:length(sub)
  d = fullfile(ex_dir, sub{ix});
  if (~exist(d, 'dir'))
    mkdir(d);
  end
end

st.ex = ex_dir;
st.session = fullfile(ex_dir, 'session.log');
st.ticks = 0;
take_diary(st.session);

t = timer('Name', 'ClaudeBridge', 'Tag', 'ClaudeBridge', ...
          'Period', 0.5, 'ExecutionMode', 'fixedSpacing', 'BusyMode', 'drop', ...
          'TimerFcn', @tick, 'UserData', st);
start(t);
fprintf(1, 'Claude bridge running, exchange dir %s\n', ex_dir);
end


function tick (t, ~)
  st = t.UserData;
  files = dir(fullfile(st.ex, 'inbox', 'cmd_*.m'));
  if (isempty(files))
    % Periodically flush the diary so Claude can see your recent output, but
    % don't steal the diary if something else is using it.
    st.ticks = st.ticks + 1;
    t.UserData = st;
    if (mod(st.ticks, 4) == 0 && ...
        (strcmp(get(0, 'Diary'), 'off') || strcmp(get(0, 'DiaryFile'), st.session)))
      take_diary(st.session);
    end
    return;
  end

  % Oldest first (names are timestamped).
  names = sort({files.name});
  name = names{1};
  id = name(1:end-2);
  run_file = fullfile(st.ex, 'running', name);
  movefile(fullfile(st.ex, 'inbox', name), run_file);
  cmd = strtrim(fileread(run_file));

  lines = regexp(cmd, '\r?\n', 'split');
  fprintf(1, '\n[claude] >> %s\n', lines{1});
  for ix = 2:length(lines)
    fprintf(1, '[claude]    %s\n', lines{ix});
  end
  try
    com.mathworks.mlservices.MLCommandHistoryServices.add(cmd);
  catch
  end

  start_byte = take_diary(st.session);
  t0 = tic;
  status = 'ok';
  try
    % Not run(), which would cd to the command file's directory.
    evalin('base', cmd);
  catch err
    status = 'error';
    % Drop the bridge and timer frames from the end of the stack trace.
    report = getReport(err, 'extended', 'hyperlinks', 'off');
    report = regexprep(report, '^Error using claude_bridge_start>tick \(line \d+\)', 'Error');
    cut = [strfind(report, sprintf('\nError in claude_bridge_start>tick')) ...
           strfind(report, sprintf('\nError in timer/timercb'))];
    if (~isempty(cut))
      report = report(1:min(cut));
    end
    fprintf(2, '%s\n', strtrim(report));
  end
  elapsed = toc(t0);
  fprintf(1, '[claude] done (%s, %.1f s)\n', status, elapsed);
  end_byte = take_diary(st.session);

  movefile(run_file, fullfile(st.ex, 'done', name));
  % Written last: mlrun waits for this file.
  fid = fopen(fullfile(st.ex, 'done', [id '.txt']), 'w');
  fprintf(fid, '%s %d %d %.3f\n', status, start_byte, end_byte, elapsed);
  fclose(fid);
end


function [nbytes] = take_diary (session)
% Flush the diary by closing it, then reopen it on the session log.  Returns
% the session log size after the flush.
  diary off;
  d = dir(session);
  if (isempty(d))
    nbytes = 0;
  else
    nbytes = d.bytes;
  end
  diary(session);
end
