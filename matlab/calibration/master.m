%Master script that calibrate, test and create plots all at once
function master(cal_data, cal_steps, cal_name, test_data)
%cal_data: data filename with which perform the calibration

%cal_steps: number of calibration steps. 1 calibrate only dipole, 
%2 calibrate only quadrupole and 3 calibrate dipole and quadrupole together

%cal_name: name to give to save the calibration

%test_data: data filename on which test the calibration 

  for i = 1:cal_steps
    %initial state 
    if(i == 1)
      state0 = initial_state();
    else
      state0 = calibration2state(hr_cal, hr_so_fix, hr_se_fix);
    end
    
    %freeze elements that allow only dipole calibration
    if (i == 1)
      freeze = {'q_so_pos' 'q_so_mo' 'q_se_pos' 'q_se_mo' 'd_so_y_co' 'd_se_y_co' 'q_so_dist' 'q_se_dist'}; 
    end
    %freeze elements that allow only source quadrupole calibration
    if (i == 2)
      freeze = {'d_so_pos' 'd_so_mo' 'd_se_pos' 'd_se_mo' 'q_se_pos' 'q_se_mo' 'd_so_y_co' 'd_se_y_co' 'q_so_dist' 'q_se_dist'};
    end
    %freeze elements that allow dipole and source quadrupole calibration
    if (i == 3)
      freeze = {'q_se_pos' 'q_se_mo' 'd_so_y_co' 'd_se_y_co' 'q_so_dist' 'q_se_dist'}; 
    end
    %set upper and lower bounds with initial state and freeze cell as input arguments
    bounds = state_bounds(state0, freeze); 
    
    %set the options for the optimization, including the "print_state" function
    %created to dispaly at each iteration positions, moments and fixture poses
    option = optimoptions(@lsqnonlin, 'Display', 'iter-detailed', ...
      'PlotFcns', @optimplotresnorm, 'OutputFcn', @print_state, 'MaxFunctionEvaluations', 60000, 'MaxIterations', 1000, 'FunctionTolerance', 1e-06, 'OptimalityTolerance', 1e-06);

    %extract the stage poses from data file (first 6 columns of the file)
    stage_poses = cal_data(:, 1:6); 

    %from the data file extracts the high rate values (from 7th to 15th column) and reshape them into 3x3
    %matrices, the output of the for cycle is a 3D matrix of dimension
    %3x3xnumber of rows in the data file
        for j = 1:size(cal_data,1)
            cd = reshape(cal_data(j,7:15),3,3);
            c_des(:,:,j) = cd;
        end

     %optimization of the state solving non linear least-square problem         
     state_new = lsqnonlin(@(state)calibrate_objective(state, stage_poses, c_des),...
                            state0,bounds(1,:),bounds(2,:),option); %1 and 2 row of bounds are respectively lower and upper bounds

     %create a calibration struct using the optimazed state_new                     
     hr_cal = state2calibration (state_new, true);

     %extract from the state optimized source fixture and sensor fixture poses 
     hr_so_fix = state_new(26:31);
     hr_se_fix = state_new(32:37);
  end
 
 %save in a .mat file all the optimazed values
 save(cal_name, 'hr_cal', 'hr_so_fix', 'hr_se_fix');
 
 %calculate statistical value and create error plots
 statistics(test_data, hr_cal, hr_so_fix, hr_se_fix);
end