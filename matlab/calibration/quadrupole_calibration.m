%Combine the old calibration and source/sensor fixtures of the dipole with the initial state of the
%quadrupole

load('XZrot_hr_cal.mat')
hr_so_fixture = hr_so_fix;
hr_se_fixture = hr_se_fix;
state = initial_state();
hr_calibration = state2calibration(state, true);
hr_calibration.d_source_pos = hr_cal.d_source_pos; 
hr_calibration.d_source_moment = hr_cal.d_source_moment; 
hr_calibration.d_sensor_pos = hr_cal.d_sensor_pos; 
hr_calibration.d_sensor_moment = hr_cal.d_sensor_moment; 
