%Optimizes the state using high rate coupling matrices extracted from
%LabView output data file 

%load the last high rate calibration values (positions, moments, source and sensor fixtures)
%load('n_sensor_hr_cal.mat')
load('new_fixture_hr_cal');
%quadrupole_calibration
%{
hr_cal.d_source_moment = [
    1 0 0
    0 1 0
    0 0 1];

hr_cal.d_sensor_moment = [
    0.2 0 0
    0 0.2 0
    0 0 0.2];
 %} 
%hr_cal.q_source_distance = 0.004;

%hr_cal.q_sensor_distance = 0.0005;

%from the calibration values and source and sensor fixtures create an input state for the optimization
state0 = calibration2state(hr_cal, hr_so_fix, hr_se_fix);
%state0 = initial_state();

%cell of elements we want to exclude from the optimization 
freeze = {'d_so_pos' 'd_so_mo' 'd_se_pos' 'd_se_mo' 'z_se_fix' 'd_so_y_co' 'd_se_y_co' 'q_so_dist' 'q_se_dist'};  
%freeze={}; 
%set upper and lower bounds with initial state and freeze cell as input arguments
bounds = state_bounds(state0, freeze); 

%set the options for the optimization, including the "print_state" function
%created to dispaly at each iteration positions, moments and fixture poses
option = optimoptions(@lsqnonlin, 'Display', 'iter-detailed', ...
  'PlotFcns', @optimplotresnorm, 'OutputFcn', @print_state, 'MaxFunctionEvaluations', 60000, 'MaxIterations', 1000, 'FunctionTolerance', 1e-06);

%Signed magnitude of coupling data
data = getreal('new_fixture_calibrate_out.dat');
%data_subset;
%data = data_combination('new_fixture_calibrate_out.dat', 'new_fixture_calibrate_X90_out.dat', 90);

%extract the stage poses from data file (first 6 columns of the file)
stage_poses = data(:, 1:6); 
    
%from the data file extracts the high rate values (from 7th to 15th column) and reshape them into 3x3
%matrices, the output of the for cycle is a 3D matrix of dimension
%3x3xnumber of rows in the data file
    for i = 1:size(data,1)
        cd = reshape(data(i,7:15),3,3);
        c_des(:,:,i) = cd;
    end
   
 %optimization of the state solving non linear least-square problem         
 state_new = lsqnonlin(@(state)calibrate_objective(state, stage_poses, c_des),...
                        state0,bounds(1,:),bounds(2,:),option); %1 and 2 row of bounds are respectively lower and upper bounds
 
 %create a calibration struct using the optimazed state_new                     
 hr_cal = state2calibration (state_new, true);

 %extract from the state optimized source fixture and sensor fixture poses 
 hr_so_fix = state_new(26:31);
 hr_se_fix = state_new(32:37);
 
 %save in a .mat file all the optimazed values
 save('new_fixture_hr_cal', 'hr_cal', 'hr_so_fix', 'hr_se_fix');
                      
  
                      
