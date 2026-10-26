This repository contains code for the ILEMT electromagnetic position tracker. Our current activity is resurrecting the calibration chain for a new source and sensor working over a much smaller workspace. The calibration stage has been reconfigured and doesn't have the same DOF. I wrote all this code, but that was years ago, so I only vaguely recall what was going on.

We'll be working primarily with the Matlab code in matlab/ which does calibration and pose solution. This parallel trees are also relevant:
- ../ilemt_cal_data: calibration data for the calibration paper. Note the local\_\*\_options.m files in the later dataset directories mentioned in README.
- ../ilemt_papers: some published papers
- ../ilemt_cal_hw: work related to the calibration stage setup (Trio MC508 motion controller, homing, wiring; see its claude.md)

See particularly ../ilemt_papers/calibration/
- FINAL VERSION.pdf
- ilemt_calibration_supplemental_FINAL.pdf

In this repo, see especially ilemt/matlab/testing/run_tests.m

Other docs: docs/doc.txt (data collection checklist, input/coupling signs,
debugging calibration convergence), docs/todo.txt. The LabVIEW code in
labview/ (binary .vi) does acquisition, `stage_calibration.vi` writes the
calibration .dat files.

# Matlab calibration code map

Everything runs with the cwd set to a data directory (e.g.
../ilemt_cal_data/cal_9_24_premo_rotated_dipole/), which holds the .dat files,
the `local_*_options.m` scripts, and an `output/` dir for results. Put
`matlab/` on the path with `addpath(genpath(...))`.

- `testing/run_tests.m` - top-level: runs the sequence of `calibrate_main()`
  and `check_poses()` calls listed in `local_test_options.m` (`cal_runs`,
  `cp_runs`, `cp_variants`).
- `calibration/calibrate_main.m` - one calibration optimization (lsqnonlin).
  `calibrate_main(cal_mode, key, value, ...)`.
- `calibration/calibrate_options.m` - option defaults, runs
  `./local_cal_options.m`, then cal_mode presets, then key/value overrides,
  then generates `in_files` from `so<fix>_se<fix>_<pattern>.dat` names unless
  `in_files` was given.
- `calibration/state_defs.m` - layout of the 82-element state vector and the
  named `state_parts` ('d_so_mo', 'st_fix', 'y_se_fix', ...) used by the
  `optimize`/`freeze` options. `state_bounds.m` turns these into lsqnonlin
  bounds (frozen = lower==upper).
- `calibration/calibrate_objective.m` - residue: for each point,
  `P = so_fix * so_motion * st_fix * se_motion * se_fix`, predicted coupling
  from `forward_kinematics()` (dipole + optional quadrupole, `fk_coupling.m`),
  residue normalized by measured coupling norm. Contains the `parfor`.
- `calibration/read_cal_data.m` - reads .dat; fixture rotations from the file
  name; `source_signs`/`sensor_signs` fixups; optional `compensate_stage()`.
- `calibration/output_correction.m` - post-calibration linear correction via
  the check_poses machinery (`correct_mode`, 'none' to skip).
- `testing/check_poses.m`, `check_poses_options.m` - pose-solve test data with
  a calibration and report errors.
- `initial_state.m` is obsolete for current hardware: the initial state is
  really the `base_calibration` .mat (a saved calibration struct).

Conventions:
- Coupling matrix `C(i,j)`: row i = source coil, column j = sensor coil.
- Calibration moments/positions are 3x3, columns are coils X Y Z. Z moment is
  `[0 0 gain]` (defines the coil frame Z); `d_*_y_co` freezes the Y component
  of the X moment (removes the rotation-about-Z redundancy with fixtures).
- Fixture transforms are `[x y z rotvec]` in m / rad (`pose2trans`). Stage
  poses in .dat files are `[X Y Z Rx Ry Rz]` in mm / degrees, Euler
  `rotz*roty*rotx`, translation applied first (`vector2tr`).
- .dat columns: 1:6 stage pose, 7:15 high-rate complex coupling (column-major
  3x3), 16:24 low-rate, 25:28 timestamps.
- Global `last_calibration` is the default base for the next run; it does not
  survive across `matlab -batch` invocations, so pass `base_calibration`
  explicitly when scripting.

# New setup (EMOTO / "smol" stage), status as of 2026-10-21

Data: ../ilemt_cal_data/cal_10_17_26_smol/soZoutYup_seZoutYup_smol.dat
(originally out.dat; 86 points). Pattern 'smol' is a 3x3x3 grid of +/-20 mm
XYZ times Ry in {-45, 0, 45} degrees, with home points at start/middle/end.
Rz is always 0. Sensor is Premo 3DV09.

Geometry at home (Ry = 0), as stated by the user and confirmed by the fit:
- The source mover is in ZoutYup, so the source is aligned with the sensor
  but not with the stage. The `soZoutYup` code supplies that rotation, so
  `st_fix` comes out near identity: (2.7, 54.7, 1.9) mm and 2.9 degrees,
  mostly about stage X.
- Sensor Z -> stage +Y, sensor Y -> stage +Z (so sensor X -> stage -X). The
  sensor is mounted on the boom that way, coded as `seZoutYup`, so `se_fix`
  also comes out near identity: 2.1 degrees, mostly about sensor -Y (stage Z).
- The sensor is in the source +Z hemisphere. Stage +Y is the source -> sensor
  direction, ~54.7 mm at home (very close: about 35-75 mm over the grid).
- Ry rotates about stage Y, i.e. it rolls the sensor about the line of sight.
  The sensor is nearly on the Ry axis.

Sensor fixture codes: `read_cal_data` used to add the sensor fixture's Euler
angles to the stage Euler angles, which only works when the stage rotation is
Rz (the outermost Euler angle). It now composes them as transforms,
`vector2tr(stage) * vector2tr(fixture)`. On old datasets the transforms are
identical to 1e-16, though some Euler vectors in columns 7:12 are written
differently. `perr_on_axis` was updated to match.

The frozen sensor fixture translation must be whichever `se_fix` axis lies
along the Ry axis (stage Y) for the sensor fixture code in use. That is
`z_se_fix` for `seZoutYup` and `y_se_fix` for `seYoutZup`. Freezing the wrong
one made the dipole fit run away along the redundant direction (`st_fix` Y
at 275 mm against `se_fix` Z at -222 mm).

Stage kinematics: mechanically Rz, then XYZ, then Ry. In pose mode, LabVIEW's
`ideal_inverse_kinematics.vi` rotates the XY axis command by -Rz, so the
logged pose behaves as translation first, then `rotz*roty*rotx` (matching
`vector2tr`). The model assumes the Ry axis is exactly along stage Y. A
tilted Ry axis can't be represented and would show up as residue. Rz has a
~40 cm lever arm to the sensor and probably won't be used.

Workflow in the data dir:
1. `bootstrap_smol()` writes `base_smol.mat` in the data dir (not in output/,
   so `run_tests('clean')` keeps it) from the nominal geometry.
2. `run_tests('clean')` runs `local_test_options.m`: a concentric
   calibration from base_smol, then a dipole calibration from that. Each is
   checked with the default and 'nocorrect' variants, writing
   `output/overall_stats_cal_10_17_26_smol.xlsx`. Its log is
   `output/test_output.txt`, because run_tests takes over the diary, so
   mlrun only shows output from before that.
3. `local_test_script.m` warns if any coil gain is negative.

`check_poses()` uses `local_check_options.m`: source coordinates, and checks
against the calibration data itself because there is no separate test data
yet (so these results are optimistic). The `'check_poses'` cal_mode's file
defaults (soYoutZup, 'ld') are for the old setup. If nothing matches,
`options.in_files` must be set in local_check_options.m.

run_tests results (2026-10-25), position RMS/max mm and rotation RMS/max deg:

| Calibration | default | nocorrect |
|---|---|---|
| concentric | 0.52 / 2.70, 0.85 / 3.46 | same (correction skipped) |
| dipole | 0.155 / 0.476, 0.37 / 0.87 | 0.203 / 0.498, 0.37 / 0.87 |

Independent test data: `soZoutYup_seZoutYup_ld.dat` (2026-10-25) is a 5x5x5
grid at +/-20 mm in 10 mm steps, times Ry in {-90, -45, 0, 45, 90}, for 632
points. Checked against `smol_dipole_hr_cal`:
- Without optimizing fixtures: about 1 mm RMS, because the user moved the
  stage home position up 1 mm (stage Z) between the 10-17 and 10-25 sessions.
- With `optimize_fixtures {'stage'}` and Kim18 initialization
  (`concentric_cal_file`, now in local_check_options): 0.115 mm RMS,
  0.36 mm max, 0.35 deg RMS. Ry +/-90, outside the calibration range of +/-45,
  is no worse.
- With the default initialization, a few far-corner Ry=0 poses converge to
  wrong local minima (about 3.5 mm and 3.5 deg off) with residuals just under
  `valid_threshold`.

Current setup (2026-10-25): calibrate from ld (`ld_concentric_hr_cal`,
`ld_dipole_hr_cal`) and test on the smol file. run_tests has a third
variant, 'stage fix' (`optimize_fixtures {'stage'}`), which takes out the
1 mm stage home change between the two sessions. The ld calibration residue is
0.0094 concentric and 0.0048 dipole. Test on smol, position RMS/max mm and
rotation RMS mrad:

| Calibration | default | nocorrect | stage fix |
|---|---|---|---|
| ld concentric | 1.01 / 1.33, 11.7 | 1.04 / 1.32, 11.7 | 0.233 / 0.621, 11.4 |
| ld dipole | 1.02 / 1.33, 6.5 | 1.03 / 1.29, 6.5 | 0.164 / 0.431, 6.5 |

`soZoutYup_seZoutYup_ld_deux.dat` (2026-10-26) repeats the ld pattern.
`read_cal_data` now parses file names non-greedily, so the pattern part can
contain `_`.
- Home drift was 21 µm over 89 min.
- Point by point it matches ld to 21 µm RMS, after a constant 0.20 mm shift
  along the line of sight.
- Tested with `ld_dipole_hr_cal`: 0.215 mm RMS without the stage refit (linear
  correction slightly hurts), 0.106 mm RMS / 0.42 max / 0.28 deg RMS with it.
- Position error is about twice as large at Ry +/-45 (0.14 mm) as at 0 and
  +/-90 (0.07 mm), a 4-fold pattern that points at model error.
- The middle or last home point is rotated ~0.45 mrad about Ry, depending on
  how Ry was left before the run. That is Ry backlash: Ry has no
  same-direction approach yet.
- At ~100 µm RMS this is not much better than the calibration paper at
  200-300 mm range. The likely cause is dipole model error at this close range
  with this coil pair (see ../ilemt_hw/coils/emoto/components: 3dvcc08
  source, 3dv09 sensor, both air-core concentric cubes; the sensor is nearly
  as big as the source and squashed flat). Next step: more general models.

On the ld calibration data itself, before/after linear correction: dipole
0.153 / 0.105 mm, concentric 0.263 / 0.116 mm (133 of 632 points invalid,
just under the 25% limit).

`perr_overall_stats` fails if the spreadsheet is open in Excel: run_tests
can't delete or overwrite it.

The earlier smol-file calibration's concentric linear correction was skipped because 29 of 86 pose solutions
had residue above `valid_threshold` (1e-5). The concentric model fits this
close-range data much worse.

DOF for this setup (single source fixture, single sensor fixture, Ry only):
- Don't optimize `so_fix`: with one source fixture it's redundant with `st_fix`.
- Freeze `z_se_fix` (with `seZoutYup`): sensor fixture translation along the
  Ry axis is redundant with the stage fixture. This is the analog of
  `z_se_fix` in 'Z_only' for the old Rz stage.
- Keep the usual freezes `d_so_z_gain`, `d_so_y_co`, `d_se_y_co`.
- `compensate_stage` must be false: its tables are for the old 200 mm
  XYZRz stage.
- Bootstrap concentric (`concentric`, true) first, then add `d_so_pos` and
  `d_se_pos`. First results: RMS normalized residue 0.012 concentric and
  0.0054 dipole.

Open issue: taken as-is, the data only fits with mirrored coil frames. In the
user's frames, the source and sensor Y moments both come out negative. Single
flips of stage X or Ry in the data don't fix it (residue goes from 0.012 to
39). The likely cause is an odd number of sensor input-sign flips, which
"Ref cal" turns into `D*C*D`, a mirror; see doc.txt "With new source or
sensor hardware". The other possibility is a stage handedness error (both a
translation sign and the Ry sign). This data can't tell which sensor channel
is wrong, so use the freehand sign test. For now, local_cal_options.m sets
`source_signs` and `sensor_signs` to `[1 -1 1]` for `_smol.dat`. That undoes the
mirror: all coil gains come out positive, with an identical residue.

# Shared MATLAB session (preferred)

When the user has run `claude_bridge_start` in their desktop MATLAB (see
tools/claude_bridge/README.md), use `tools/claude_bridge/mlrun` to run commands in
that session. Output is shared both ways, and so are the workspace, pool,
figures and history. Use `mlrun -l` to see what the user has been doing.
Check with `mlrun -t 5 '1;'`. Exit 2 with "still queued" means the bridge
isn't running or MATLAB is busy.
- Commands run in the user's base workspace and current directory: don't
  `clear`, `cd`, or close their figures without saying so.
- Use single-quoted strings (old code assumes char arrays).
- For long runs use `-t` and run_in_background, or resume with `mlrun -r <id>`.
- After editing a .m file from outside MATLAB, the session may keep running
  the cached old version. `clear <name>` before rerunning. This happened with
  calibrate_options, and with the local_check_options.m script.
- The user normally has `dbstop if error` on. An error in a bridge command
  then stops their MATLAB at `K>>`, and mlrun times out until they continue.

# Running Matlab from the shell

MATLAB R2024a: `"/c/Program Files/MATLAB/R2024a/bin/matlab.exe" -batch "..."`
(~9 s startup). Write a script and `run()` it rather than long inline
commands. Use `verbose` 1 in batch (verbose 2 adds a plot function). Each
batch run is a fresh session: no `last_calibration` and no parallel pool.

Machine: Threadripper PRO 7955WX, 16 cores / 32 threads, 32 GB RAM (~13 GB
available to MATLAB with the usual stuff open), RTX A2000. Parallel Computing
Toolbox present. The default local profile is 16 workers, which is
memory-heavy; 8 process workers is a good default (`parpool('Processes', 8)`,
~15 s startup). On the smol dataset: calibrate_main 78 s serial, 20 s with 8
workers. The objective is per-point overhead dominated (`state_defs` script
and `state2calibration` run per point inside the parfor), so there is room for
speedup if it matters.
