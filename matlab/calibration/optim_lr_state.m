%Optimizes the state using low rate coupling matrices extracted from
%LabView output data file 

%load the last low rate calibration values (positions, moments, source and sensor fixtures)
load('n_res_qpole_lr_cal'); 
%{
hr_cal.sensor_moment = [
    0.015 0 0
    0 0.015 0
    0 0 0.015];

hr_cal.sensor_pos = zeros(3, 3);
%}
state0 = calibration2state(lr_cal, lr_so_fix, lr_se_fix); %from the calibration values and old source and sensor fixture create an input state for the optimization
%state0 = initial_state();

freeze = {'d_se_y_co' 'q_so_dist' 'q_se_dist'};
%freeze={};
bounds = state_bounds(state0, freeze); %set upper and lower bounds and which variables we want to exclude from the optimization with initilal state and freeze struct as input arguments

%set the options for the optimization, including the "print_state" function
%created to dispaly at each iteration positions, moments and fixture poses
option = optimoptions(@lsqnonlin, 'Display', 'iter-detailed', ...
  'PlotFcns', @optimplotresnorm, 'OutputFcn', @print_state, 'MaxFunctionEvaluations', 60000, 'MaxIterations', 1000, 'FunctionTolerance', 1e-08);

%Signed magnitude of coupling data.
data = getreal('new_sensor_calibrate_out.dat');

%extract the stage poses from data file (first 6 columns of the file)
stage_poses=data(:, 1:6); 

%from the data file extracts the low rate values (from 16th to 24 column) and reshape them into 3x3
%matrices, the output of the for cycle is a 3D matrix of dimension
%3x3xnumber of rows in the data file
    for i = 1:size(data,1)
        cd=reshape(data(i,16:24),3,3);
        c_des(:,:,i)=cd;
    end
      
 %optimization of the state solving non linear least-square problem    
 state_new = lsqnonlin(@(state)calibrate_objective(state, stage_poses, c_des),...
                        state0,bounds(1,:),bounds(2,:),option); %1 and 2 row of bounds are respectively lower anad upper bounds
 
 %create a calibration struct using the optimazed state_new
 lr_cal = state2calibration (state_new, true);

 %optimized source fixture and sensor fixture poses 
 lr_so_fix = state_new(26:31);
 lr_se_fix = state_new(32:37);
 
 %save in a .mat file named lr_calibration all the optimazed values
 save('n_res_qpole_lr_cal', 'lr_cal', 'lr_so_fix', 'lr_se_fix');
                      
  
                      