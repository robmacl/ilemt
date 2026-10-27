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

Current setup (2026-10-27): calibrate from ld (`ld_concentric_hr_cal`,
`ld_dipole_hr_cal`, then `ld_oct_hr_cal`) and test on the smol file.
- `ld_oct_hr_cal` adds octupole s, sensor anisotropy t and a free stage Y
  scale (`o_so o_se a_se y_st_scale`, see "Model exploration"). It is the
  `local_check_options` default.
- run_tests has a third variant, 'stage fix' (`optimize_fixtures
  {'stage'}`), which takes out the 1 mm stage home change between the two
  sessions.
- The ld calibration residue is 0.0094 concentric, 0.0048 dipole and 0.0019
  octupole.

Test on smol, position RMS/max mm and rotation RMS mrad:

| Calibration | default | nocorrect | stage fix |
|---|---|---|---|
| ld concentric | 1.01 / 1.33, 11.7 | 1.04 / 1.32, 11.7 | 0.233 / 0.621, 11.4 |
| ld dipole | 1.02 / 1.33, 6.5 | 1.03 / 1.29, 6.5 | 0.164 / 0.431, 6.5 |
| ld oct | 1.01 / 1.10, 2.6 | 1.02 / 1.09, 2.6 | 0.066 / 0.145, 2.5 (max 4.3) |

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

Model exploration (2026-10-26), see the plan in the conversation. Steps 1-3
are done:
1. The forward model and objective are vectorized over points
   (`forward_kinematics`, `fk_coupling` and `vector2tr` accept stacks; the
   parfor is gone). Results are identical to rounding. One objective
   evaluation on 632 points takes 0.1 s (was 2.4 s serial), and a full ld
   dipole calibration takes 3 s with no pool.
2. Diagnostics on the ld dipole residue:
   - It is banded by stage Y level: high at 35-50 mm, lowest at 50-70 mm,
     up again at 75 mm, with no Ry dependence.
   - It is largest in the source-Z row, especially ZZ (coaxial).
   - The LR carrier fit has the same residue, correlated 0.90 point by
     point, and the quadrature part barely varies with pose. So it is not
     eddy currents; it is geometric or model error.
3. Ry axis alignment: `axis_fixture` (state 83:85, part `ax_fix`; freeze
   `y_ax_fix` for Ry) in `motion_transforms`. It fits to 0.02 deg and
   changes nothing. It stays in the model for future use.

Stage scale scan (rescaling one stage axis of the ld data and
recalibrating): Y +0.5% lowers the residue 0.00476 -> 0.00364, and X and Z
each prefer about -0.4%. That is either a real ~0.5% stage scale error
(0.1 mm at +/-20 mm, the size of the test errors), or scale standing in for
the missing finite-size term. Next: the octupole model, fitted with and
without stage scale parameters, plus a physical check of stage scale.

Octupole (finite coil size) model, step 4, in `forward_kinematics`
(`add_octupole`):
- One parameter per coil, s = (axial winding variance) - (transverse
  variance), in mm^2 (state parts `o_so`, `o_se`). It is implemented as
  1/2 s (u.grad)^2 B_dipole by a centered difference over +/-1 mm.
- Brute-force distributed-dipole solenoid/pancake check: 50x closer than the
  dipole model.
- Transverse anisotropy for non-round windings (2026-10-27): one more
  parameter per coil, t = sv^2 - sw^2 in mm^2 (parts `a_so`, `a_se`, state
  95:100, calibration `a_source`/`a_sensor`).
  - The transverse axes v, w are the coil frame axes in cyclic order: coil X
    (Y, Z), coil Y (Z, X), coil Z (X, Y).
  - It adds t/4 ((v.grad)^2 - (w.grad)^2) B by four +/-1 mm dipoles.
  - A rectangle a x b has t = (a^2 - b^2)/12. A flat 9.5 x 3.2 mm sensor
    coil has t = 6.7 mm^2, and that alone is about 0.8% coupling error.
  - Brute-force rectangular coil check: s + t is 20-50x closer than s
    alone. A 16.5 x 14.8 x 11.8 box leaves 1.2e-3 (higher order).

Anisotropy results (`model_compare5/6.m`), calibrated on ld, tested on
ld_deux / smol. Columns are pos RMS/max mm and rot RMS/max deg; Ry-dep is
the Ry-dependent part of the position error:

| Model | Y scale | Residue | ld_deux | smol | Ry-dep |
|---|---|---|---|---|---|
| oct | 2.05 | 2.25e-3 | 0.122/0.252, 0.175/0.424 | 0.126/0.247, 0.181/0.323 | 39 um |
| + a_se | 2.05 | 2.04e-3 | 0.116/0.242, 0.157/0.295 | 0.126/0.234, 0.172/0.302 | 12 um |
| + a_so | 2.05 | 2.16e-3 | 0.117/0.242, 0.164/0.477 | 0.119/0.232, 0.168/0.294 | 40 um |
| + a_so + a_se | 2.05 | 1.99e-3 | 0.108/0.226, 0.151/0.350 | 0.123/0.242, 0.175/0.321 | 12 um |
| + a_se | free 3.49 | 1.91e-3 | 0.089/0.184, 0.136/0.260 | 0.093/0.170, 0.146/0.247 | 12 um |
| + a_so + a_se | free 3.51 | 1.86e-3 | 0.081/0.174, 0.130/0.372 | 0.090/0.162, 0.151/0.341 | 12 um |

- Sensor anisotropy is real:
  - t sensor = [4.2 -3.6 -1.6] mm^2, the same within 0.2 for ld and ld_deux.
    The signs fit a flat sensor (thin along sensor z): t_x > 0, t_y < 0,
    t_z ~ 0. The magnitude is under the 6.7 mm^2 envelope bound.
  - It takes the Ry-dependent error from 39 to 12-16 um, flat with range.
    That is the noise floor, so the Ry effect was the sensor shape, not
    mechanics.
  - Rotation max drops from 0.42 to 0.30 deg.
- Source anisotropy alone is weak: t = [0.8 -5.2 -0.2]. The source Z coil
  shows no anisotropy.
- With both, the source and sensor terms trade off. Source Z s goes to 0
  and sensor Z s to -10, and sensor t reaches +/-11, past the physical
  bound. With no source rotations in the data they are near-degenerate, so
  leave a_so out until source fixture rotation data exists.
- The free Y scale stays at 3.5 per mille with or without anisotropy. The
  lateral X error (80-100 um RMS) is still the largest term.
- Stage translation scale: `stage_scale` (per mille, parts `st_scale`,
  `x/y/z_st_scale`) in `motion_transforms`, also used for the check_poses
  ground truth.
- A uniform scale of all three axes is nearly degenerate with
  gains/offsets/octupole (it wandered to -2% and -11%), so free only
  `y_st_scale`.

Results, calibrated on ld and tested on ld_deux / smol (stage fixture refit,
no linear correction), position RMS/max mm and rotation RMS/max deg:

| Model | Residue | ld_deux | smol |
|---|---|---|---|
| dipole | 0.00476 | 0.147/0.448, 0.280/0.993 | 0.182/0.442, 0.374/0.959 |
| + Y scale (+5.5 per mille) | 0.00363 | 0.136/0.443, 0.276/1.033 | 0.194/0.437, 0.400/1.007 |
| + octupole | 0.00273 | 0.165/0.364, 0.211/0.417 | 0.183/0.372, 0.226/0.428 |
| + octupole + Y scale (+3.5) | 0.00213 | 0.099/0.212, 0.158/0.428 | 0.097/0.172, 0.159/0.344 |

The fitted octupole s agrees between ld and ld_deux calibrations to about
0.3 mm^2: source about [-3.0 -2.8 -8.2], sensor [-7.1 -4.8 -1.9] with Y
scale. Both source and sensor terms are needed. The remaining +0.35% Y scale
is consistent across datasets. It is either a real stage Y error (the
datasheet says 24 um / 150 mm, so that would be surprising) or a remaining
model term that looks like range falloff.

Stage Y indicator check (2026-10-27), about 60 mm off the carriage:
10.021 mm for 10 mm (digital) and 1.002 in for 25.4 mm (dial), so +2.0 to
+2.1 per mille. At the carriage: 10.015 then 10.020 mm (digital). But a Keyence
LK-G152 laser reads 24.994 mm for 25 mm (-0.24 per mille); its linearity spec
is +/-0.05% of F.S. (+/-40 mm), on Keyence's ceramic target. Unresolved: check
the instruments against gauge blocks. Alignment error can go either way: the
reading is d (m.n)/(b.n), where m is the motion, b the sensing axis and n the
target face normal. A ball tip on a face square to the motion over-reads by
1/cos(theta); 3.6 deg gives +2 per mille. The Parker
accuracy spec is "measured over centerline of drive screw", so it excludes
Abbe error, and there is no pitch/yaw spec. X and Z are not measured yet;
only Y relative to X/Z is identifiable magnetically.

With Y scale fixed at +2.05 (base calibration with `stage_scale` set,
`st_scale` not optimized), ld -> ld_deux / smol:

| Model | Residue | ld_deux | smol |
|---|---|---|---|
| dipole + Y 2.05 | 0.00411 | 0.133/0.444, 0.274/1.004 | 0.176/0.438, 0.380/0.977 |
| + octupole + Y 2.05 | 0.00225 | 0.122/0.252, 0.175/0.424 | 0.126/0.247, 0.181/0.323 |

Calibrated on ld_deux instead it is the same within 0.01 mm, and the
octupole s agrees within 0.3 mm^2. Source Z s trades off against Y scale:
-10.8 / -9.3 / -8.2 mm^2 at Y scale 0 / 2.05 / 3.5. The source Z coil points
along the line of sight, so its octupole also changes the range falloff.

Careful: `perr.errors` from `pose_difference` is inv(measured)*desired. That
is desired - measured, expressed in the measured sensor frame, which turns
with Ry. For spatial analysis, difference `perr.measured`/`perr.desired` in
source coordinates and rotate into stage axes. The stage -> source mapping
here is X -> -x, Y -> z, Z -> y, with a 2.8 deg source tilt about X.

Linear trend of the test error vs stage Y, in stage axes (oct + Y 2.05,
ld_deux / smol):
- Rotation: pitch -2/-6, roll -8/-5, yaw +15/+16 urad/mm. The dipole model
  gives pitch +20/+35 and yaw -15/-14, so these are model error, not a stage
  measurement.
- Position along the line of sight: +1.7/+2.4 um/mm (measured - desired). The
  tracker range is expanded relative to the ground truth, as if Y scale were
  about 4 per mille.
- Abbe tilt was ruled out separately: the indicator read the same at the
  carriage as at 60 mm offset.

Freeing X and Z stage scale with Y fixed at 2.05 gives X = Z = -1.5 (oct) or
-3.6/-3.3 (dipole). That is the same solution as a free Y, so the coupling
data shows no X-specific stage scale.

Test error distribution (oct + Y 2.05, ld -> ld_deux; `err_dist.m` in the
2026-10-27 session scratchpad):
- Systematic, not noise:
  - At the same commanded pose, ld and ld_deux errors correlate 0.98-1.00
    per axis.
  - Run-to-run noise is about 15 um per run; the 3 home repeats spread 10 um.
- No outliers. Two screens:
  - Run-to-run difference: robust z > 5 for no points.
  - Deviation from same-Ry grid neighbors: no points in ld_deux. In ld it
    flags one contiguous block (X -20, Y +20, Ry -90), which is the extreme
    of the smooth pattern.
- Shape of the distribution:
  - Components are close to Gaussian with light tails: max/RMS 2.1-2.3 vs
    2.9 for a Gaussian.
  - The dipole model had heavy Y/Z tails (kurtosis about 6); the octupole
    removed them.
- Size: RMS by axis X 105, Y 39, Z 47 um.
  - The position-dependent part (mean over Ry) is 115 um RMS. The
    Ry-dependent part is 39 um, larger at near range.
  - The position-dependent part is smooth: a degree 1/2/3 polynomial in XYZ
    leaves 69/47/29 um.
- RMS vs range is U-shaped: 104, 88, 106, 134, 162 um at 39-76 mm.
  - In-sample on ld, the normalized coupling residue by range is 3.3, 2.2,
    1.8, 1.7, 1.8e-3 (oct) vs 8.3, 3.8, 2.1, 2.7, 4.2e-3 (dipole, a U with
    its minimum in mid range).
  - Position error / range is about 2e-3 beyond 48 mm, 2.7e-3 at 39 mm. So
    for the octupole the far-range rise is just position error growing
    roughly in proportion to r for a fixed relative coupling error.
  - The remaining excess is at short range.
- Dominant pattern is lateral X pulled toward the axis:
  - dex/dX goes from -1.6 to -10 per mille with range (oct). The dipole
    model gives a flat -6.
  - At the X edges there is also +50-100 um along the line of sight, i.e.
    the direction is pulled toward the axis at nearly constant range.
- eX is locked to yaw: correlation with rotation about Z is -0.95, with a
  lever of 39 mm. Likewise eZ with pitch: 0.82, 32 mm.
  - That lever matches the dipole ambiguity. A lateral shift x tilts the
    on-axis field by 1.5 x/r, so a sideways shift and a sensor rotation give
    nearly the same coupling at lever 2r/3 (38 mm at r = 57).
  - So this is the pose solution's poorly observed direction, and it
    amplifies small coupling-model errors.
  - X > Z suggests a source x/y asymmetry the model lacks, e.g. the
    transverse anisotropy of the rectangular Z winding:
    (16.5^2 - 14.8^2)/12 = 4.4 mm^2, vs fitted s_z = -8.
- The Ry-dependent part (error minus its mean over the 5 Ry at each XYZ)
  looks magnetic, not mechanical:
  - Bearing runout times the sensor moment would be the same rigid offset
    at every XYZ for a given Ry. That rigid part is only 8 um RMS (10 um for
    the dipole), repeatable between ld and ld_deux.
  - The rest, 38-41 um oct (92 um dipole), varies with position and falls
    with range: 52 -> 28 um, about 1/r, as expected for a remaining
    octupole-order (1/r^2 relative) term. Dipole: 167 -> 32 um.
  - It is X/Z, but so is any magnetic error in the poorly observed
    lateral+rotation direction, so X/Z alone doesn't point to mechanics.
  - The mechanical Ry signal that is there is a roll (Ry angle) error per Ry
    level: +0.17, +0.37, +0.27, -0.20, -0.60 mrad at Ry -90..+90. It is
    repeatable across runs and nearly model-independent.
  - Rigid pitch/yaw per Ry is about +/-0.2 mrad, partly model-dependent.

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
  calibrate_options, and with the local_check_options.m script. Bridge
  commands run from a timer callback, and MATLAB seems to notice changed files
  only once it is back at the prompt. So the first bridge command after an
  external edit can silently run old code: 2026-10-27, a whole calibration
  ran on the pre-octupole state2calibration. Put explicit `clear`s of
  every edited function at the top of a script run that way.
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
