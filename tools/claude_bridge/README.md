# Claude bridge for MATLAB

Lets Claude run commands in your desktop MATLAB session. You both share the
Command Window, the base workspace, figures, the parallel pool, and the
command history.

## Start / stop (in MATLAB)

```matlab
addpath('C:\Users\robertm2\Documents\Work\ilemt\tools\claude_bridge')
claude_bridge_start
...
claude_bridge_stop
```

While it's running:
- Claude's commands show up in your Command Window as `[claude] >> ...`,
  followed by their output and `[claude] done (ok|error, N s)`. They are also
  added to your command history, so you can recall and edit them.
- Commands only run while MATLAB is idle (at the prompt, or inside
  `pause`/`drawnow`), never in the middle of something you're running.
  They queue in order.
- Ctrl-C interrupts a Claude command like any other.
- Everything in the Command Window is logged to `exchange/session.log` via
  `diary`. That includes your own commands and output, so Claude can see what
  you've been doing. Note that `diary` is taken over by the bridge.
  `run_tests` (which sets its own diary) still works, and the bridge takes the
  diary back afterwards.

Cosmetic: when a Claude command finishes, MATLAB doesn't redraw the `>>`
prompt, so the cursor sits after the output. Just type as usual.

## Claude's side (bash)

```bash
mlrun 'x = magic(3)'            # run, wait, print output (exit 1 on error)
mlrun -t 3600 - <<'EOF'         # multi-line from stdin, longer wait
bootstrap_smol();
EOF
mlrun -r cmd_20261025_115101_02049   # keep waiting for a timed-out command
mlrun -l 60                     # tail the session log
```

Use single-quoted MATLAB strings: older code assumes char arrays.

The exchange directory is `exchange/` next to these files (gitignored). Set
`CLAUDE_BRIDGE_EX` for `mlrun`, and pass the same directory to
`claude_bridge_start`, to use another one. This directory is deliberately
outside `matlab/`, so `genpath` on the calibration code doesn't pick up
`exchange/`.

## How it works

`mlrun` writes `exchange/inbox/cmd_<timestamp>_<rand>.m`. A timer in MATLAB
(0.5 s) picks up the oldest one and echoes it. It closes and reopens the diary
to mark a start offset in `session.log`, runs the text with
`evalin('base', ...)`, then marks the end offset. Finally it writes
`exchange/done/<id>.txt` containing `status start end seconds`. `mlrun` waits
for that file and prints that byte range of the log.
