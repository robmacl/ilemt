clear all
close all
clc

fileDirectory = pwd

% Input parameters 
[choice, deg, skip_control, ob] = input_param();

% Extract data from file to high and low carriers, do the validity check and print out the summary statistitcs 
[resultArray, data, disArray, num_data] = ExtractData(fileDirectory, true);
[resultArrayLow, data, disArrayLow, num_data] = ExtractData(fileDirectory, false);
% Process high carrier data to translation and rotation components
[transResult, rotResult] = dataProcess(resultArray, data, num_data);
% Process high carrier data to translation and rotation components
[transResultLow, rotResultLow] = dataProcess(resultArrayLow, data, num_data);

% Plot data
axis_moving = dlmread(fileDirectory+"\"+string(data.FileName(1)));
plot_graph(choice, axis_moving, transResult, rotResult, transResultLow, rotResultLow, disArray, disArrayLow, skip_control, data, deg, ob, num_data, fileDirectory)


%% Pass-in parameter Function
function [choice, deg, skip_control, ob] = input_param()
    fprintf('***Please press ctrl+c anytime if you need to terminate***\n')
    disp('Choice of plot:')
    disp('1.High and Low carriers comparison')
    disp('2.Vary x position for hollow and solid metal')
    disp('3.Vary y position for hollow and solid metal')
    disp('4.Sheet metal')
    choice = input('Choose the prefered choice: ');
    switch choice
        case 1
            deg = 0;
            skip_control = 0;
            ob = 2;
            while ob ~= 0 && ob ~= 1
                ob = input('Custom plot(Yes=1 or No=0)?:');
                if ob ~= 1 && ob ~= 0
                    disp('---Error in assigned option in High-Low comparison plot---')
                end
            end

        case {2,3,4}
            deg = 100;
            skip_control = 2;
            ob = 3;
            while deg ~= 0 && deg ~= 90   
                deg = input('Any orientation?(0 or 90): ');
                if deg == 0 || deg == 90  
                    while skip_control ~=1 && skip_control ~=0
                        skip_control = input('Would you like to include the control test in the plot(Yes=1 or No=0)?:');
                        if skip_control == 1 || skip_control == 0
                            while ob ~=1 && ob~=2
                                disp('Which type of parameter you need to observe?')
                                disp('1.Translational/rotational error')
                                disp('2.Coupling magnitude')
                                ob = input('Answer: ');
                                if ob ~= 1 && ob ~= 2
                                    disp('---Error in observed parameter choice---')
                                end 
                            end
                        else
                            disp('---Error in assigned control test in plot---')
                        end
                    end
                else
                    disp('---Error in orientation input---')
                end
            end
    otherwise
        disp('---Sorry, there is no choice you chose---')
    end

end

%% Total Plot Function
function plot_graph(choice, axis_moving, transResult, rotResult, transResultLow, rotResultLow, disArray, disArrayLow, skip_control, data, deg, ob, num_data, fileDirectory)
    switch choice
        case 1
            i=1;
            while i<=size(data,1)
                if string(data.MetalShape(i)) == "solid"
                    pos_rod = round(i);
                elseif string(data.MetalShape(i)) == "sheet"
                    pos_sheet = round(i);
                end
                i=i+1;
            end

            axis_moving_rod = dlmread(fileDirectory+"\"+string(data.FileName(pos_rod)));
            axis_1 = axis_moving_rod(2:end-1,1);
            axis_moving_sheet = dlmread(fileDirectory+"\"+string(data.FileName(pos_sheet)));
            axis_2 = axis_moving_sheet(2:end-1,1);
            
            if ob == 0
                rod_metal = axis_moving_rod(2,1);
                sheet_metal = axis_moving_sheet(2,1);
            else
                rod_metal =0;
                sheet_metal =0;
                while isempty(find(axis_1 == rod_metal,1))
                    fprintf('\nGuidance for hollow and solid metals range>>\n   1-30 with 1 cm spacing\n   30-51 with 3 cm spacing\n   60-100 with 10 cm spacing\n')
                    rod_metal = input('Input position of hollow and solid metal:');
                    if isempty(find(axis_1 == rod_metal, 1))
                        disp('---Out of range in position input of sheet metal---')
                    end
                end
                while isempty(find(axis_2 == sheet_metal,1))
                    fprintf('\nGuidance for sheet metals range>>\n   16-100 with 2 cm spacing\n')
                    sheet_metal = input('Input position of sheet metal:');
                    if isempty(find(axis_2 == sheet_metal,1))
                        disp('---Out of range in position input of sheet metal---')
                    end
                end

            end
            plotHighLow(transResult, rotResult, transResultLow, rotResultLow, rod_metal, sheet_metal, num_data, axis_1, axis_2, data)
        case 2
            axis = axis_moving(2:end-1,1);
            point = axis_moving(2,2);
            plotxmoving(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control, ob, point)
        case 3
            axis = axis_moving(2:end-1,2);
            point = axis_moving(2,1);
            plotymoving(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control, ob, point)
        case 4
            axis = axis_moving(2:end-1,1);
            plotsheet(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control, ob)
    end
end

%% Extract Data from file to high and low carriers Function
function [resultArray, data, disArray, num_data] = ExtractData(fileDirectory, op_ishigh)  
    format longE
    %% Create a table according to the dat files
    % Specify the directory where the DAT file is located
    files = dir(fullfile(fileDirectory, '*.dat'));
    % Create a mapping rule to map numbers to metal names
    metalMap = containers.Map({0,1, 2, 3, 4, 5, 6}, {'Control', 'LC Steel', '416 SS', '304 SS', '6061 Al', 'Ti Grade 5', 'Copper'});
    % Create an empty table
    data = table();
    
    %% Find the first number after a word using regular expression
    pattern = '(hollow|solid|sheet|x5y0)(\d+)';
    
    for i = 1:numel(files)
        fileName = files(i).name;
        
        % Use regular expressions to match
        tokens = regexp(fileName, pattern, 'tokens');
            
        if ~isempty(tokens)
            % Extract matching keywords and numbers
            match = tokens{1};
            keyword = match{1};
            numericPart = str2double(match{2});
    
            % Convert numbers to metal names using mapping rules
            metalName = metalMap(numericPart);
            
            % Add data to table
            newRow = {fileName, keyword, metalName};
            data = [data; newRow];
        end
    end
    
    % Add column names to the table
    data.Properties.VariableNames = {'FileName', 'MetalShape', 'MetalName'};
    % Display table
    if op_ishigh
        fprintf('\n****************************************************\n')
        fprintf('      Detail of data files for high carrier')
        fprintf('\n****************************************************\n')
    else
        fprintf('\n****************************************************\n')
        fprintf('      Detail of data files for low carrier')
        fprintf('\n****************************************************\n')
    end
    disp(data);
    
    %% Define a cell array to accumulate results for each file
    % store poses result
    resultArray = [];
    disArray = [];
    num_data = [];
    
    % check_metal.m
    options = interfere_options('concentric', true);
    options.ishigh = op_ishigh;
    [cal, options] = load_interfere_cal(options);
    
    % Loop through each file
    
    for i = 1:numel(files)
        matrix_couplings = []; 
        % Read data from the file lists
        options.in_files = data{i,1};

        % Read data from the file
        [motion, couplings] = read_cal_data(options);
        matrix_couplings(:,:,:,i) = couplings;
        different = abs(matrix_couplings(:,:,1,i)- matrix_couplings(:,:,:,i));
        distance = squeeze(sqrt(sum(sum(different.^2))));
        disArray = [disArray; distance(2:size(distance,1)-1)];

        % Solve pose for the metal
        [poses, valid] = pose_solution(couplings, cal, options);
        resultArray = [resultArray; poses];
        num_data = [num_data, size(poses,1)];
    end

    %% Validity Check Process
    % store validity check pose_difference result
    diffVMResult = [];
    transVMResult = [];
    rotVMResult = [];
    
    i = 1;
    j = 1;
    step = num_data(1);
    % count of loop
    count = 1;

    % Create an empty table for validity check
    VM = table();
    % Loop through the resultArray to get the pose difference
    while i <= (size(resultArray, 1) - step + 1) 
        step = num_data(j);
        diff = pose_difference(resultArray(i,:), resultArray((i + step - 1),:));
        
        i = i + step;

        transVM = sqrt(sum(diff(1,1:3).^2, 2));
        rotVM = sqrt(sum(diff(1,4:6).^2, 2));
    
        metalShape = data{count, 2};
        metalNum = data{count, 3};

        if count <= num_data(j)
            count = count + 1;
        end
        
        % Add new validity check to table
        newVM = {metalShape, metalNum, transVM, rotVM};
        VM = [VM; newVM];
       
        diffVMResult = [diffVMResult; diff];
        transVMResult = [transVMResult; transVM];
        rotVMResult = [rotVMResult; rotVM];
        j =j+1;
    end

    % Add column names to the table
    VM.Properties.VariableNames = {'MetalShape', 'MetalNumber', 'Validity_Check_Value_of_Translation_Error', 'Validity_Check_Value_of_Rotation_Error'};
    % Display VM table
    disp(VM);

    savefilename = 'example.xlsx';  
    writetable(VM, savefilename);
    disp('Table has been written to Excel successfully.');
    %% Summary
    validityCheckTable = table(data{:, 2}, data{:,3}, transVMResult, rotVMResult, 'VariableNames', {'MetalShape', 'MetalName', 'Validity_Check_Translation_Error_Value', 'Validity_Check_Rotation_Error_Value'});
    
    maxTrans = max(transVMResult);
    medTrans = median(transVMResult);
    
    maxRot = max(rotVMResult);
    medRot = median(rotVMResult);

    fprintf('maximum mismatch of translation error: %.6e\n', maxTrans);
    fprintf('median mismatch of translation error: %.6e\n', medTrans);
    fprintf('maximum mismatch of rotation error: %.6e\n', maxRot);
    fprintf('median mismatch of rotation error: %.6e\n', medRot);    
end
%% Data process for translation Error and rotation error Function
function [transResult, rotResult] = dataProcess(resultArray, data, num_data)

    % Store pose_difference result
    diffResult = [];
    transResult = [];
    rotResult = [];
    
    i = 1;
    j = 1;

    step = num_data(1); 
%     step = size(resultArray, 1) / size(data, 1); 
    
    % Loop through the resultArray to get the result plot
    while j <= (size(resultArray, 1) - step + 1) 
        step = num_data(i);
        nometal = (resultArray(j, :) + resultArray(j + step - 1, :))/2;
        for m = 1:(step-2)
            plotDiff = pose_difference(nometal, resultArray(j+m, :));
            diffResult = [diffResult; plotDiff];
        end

        j = j + step;
        i = i+1;
    end

    for n = 1:numel(diffResult(:,1))
        trans = norm(diffResult(n, 1:3));
        rot = norm(diffResult(n, 4:6));
        transResult = [transResult; trans];
        rotResult = [rotResult; rot];
    end
    
end

%% Calibration Functions
function [motions, couplings, file_map] = read_cal_data (options)
    % Read ILEMT calibration data from stage_calibration.vi.  All the arguments
    % are in the options struct.  For details on the fixture encoding in the
    % file names, see:
    %    ilemt/cal_data/input_patterns/test_plans.txt 
    % 
    % in_files: 
    %     Cell vector of file names.  If the name encodes fixture rotations, then
    %     these are incorporated into the 'motions' output.  Otherwise it is
    %     assumed there are no extra fixture rotations.
    %
    % ishigh: If true, extract high rate couplings, otherwise low rate.
    %
    % Return values:
    % motions(n, 18): 
    %     Each row is:
    %         [source_motion stage_motion XYZRz_motion]
    %
    %     These are source fixture motion, total "stage" motion (including sensor
    %     fixture motion), and motorized XYZRz motion only (less sensor fixture
    %     motion).  The poses are in vector2tr format, units (mm, degree).  We can
    %     roll the sensor fixture motion into stage motion because we force the
    %     null pose of the XYZRz linkage to be identical to the null pose of the
    %     sensor fixture by the Rz alignment procedure in the stage setup.
    %
    % couplings(3, 3, n): 
    %     This is complex so that we can potentially remove hardware
    %     measurement bias, use real_coupling() to get signed real coupling
    %     values.
    % 
    % file_map(n, 1):
    %     Parallel to the result data, the index in options.in_files of the
    %     file that the datapoint came from.

    files = options.in_files;
    if (~iscell(files))
      error('files is not a cell vector');
    end

    % Cell vectors of motions and couplings arrays that are going to get
    % concatenated. 
    motions_c = {};
    couplings_c = {};

    for f_ix = 1:length(files)
      file1 = files{f_ix};
      % Parse fixtures out of the file name
      [tokens, ~] = regexp(file1, 'so(.*)_se(.*)_(.*)\.dat', 'tokens', 'match');
      fix_motions = zeros(1, 12);
      if (~isempty(tokens))
        fix_motions(4:6) = fix_lookup(tokens{1}{1}, false);
        fix_motions(10:12) = fix_lookup(tokens{1}{2}, true);
        %dat_size = tokens{1}{3};
      end

      % Read file data
      data1 = dlmread(file1);
      motions1 = repmat(fix_motions, size(data1, 1), 1);
      stage_mo = data1(:, 1:6);
      if (options.compensate_stage)
        stage_mo = compensate_stage(stage_mo);
      end
      motions1(:, 7:12) = motions1(:, 7:12) + stage_mo;
      motions1(:, 13:18) = stage_mo;
      motions_c{end+1} = motions1;

      couplings1 = zeros(3, 3, size(data1, 1));
      if (options.ishigh)
        slice = 7:15;
      else
        slice = 16:24;
      end

      % Sign flips at each coupling position.
      so_sign = find_sign_pattern(file1, options.source_signs, 'source_signs');
      se_sign = find_sign_pattern(file1, options.sensor_signs, 'sensor_signs');
      signs = so_sign' * se_sign;

      for ix = 1:size(data1, 1)
        couplings1(:, :, ix) = signs.* reshape(data1(ix, slice), 3, 3);
      end
      couplings_c{end+1} = couplings1;

      % Drift check.  Each file should have at least first and last points in the
      % null pose.  These measurements are ideally identical, and if they are too
      % different it suggests a problem, like something moved during the
      % collection.  A more precise check based on the pose change is made by
      % check_poses() 'drift' report.  But this check is useful because it can
      % be done when we don't yet have a calibration.
      if (all(data1(1, 1:6) == data1(end, 1:6), 2))
        cdiff = couplings1(:,:,1) - couplings1(:,:,end);
        maxdiff = max(max(abs(cdiff), [], 2), [], 1);
        %fprintf(1, 'drift: %s %g\n', file1, maxdiff);
        if (maxdiff > 1e-4)
          fprintf(1, 'Warning: drift check failed: %s %g\n', file1, maxdiff);
        end
      else
        fprintf(1, 'First and last points are not home, skipping drift check.\n');
      end
    end

    motions = cat(1, motions_c{:});
    couplings = cat(3, couplings_c{:});

    % Compute file map
    file_map = zeros(size(motions, 1), 1);
    prev_ix = 1;
    for f_ix = 1:length(motions_c)
      new_ix = prev_ix + length(motions_c{f_ix}) - 1;
      file_map(prev_ix:new_ix) = f_ix;
      prev_ix = new_ix + 1;
    end

end % read_cal_data

function [angles] = fix_lookup (wot, fixture_to_mover)
% This maps the fixture codes to the vector2tr Euler angles.  
% 
% wot: 
%    Fixture code.
% 
% fixture_to_mover: 
%    if true, we want the transform from the fixture to the mover, if false
%    the reverse.  The code is defined with respect to the fixture, but for
%    the source we want to go from mover to fixture, whereas for sensor it
%    is the other way around.
%
% I guess there are 24 legit fixture codes, but we only use these, so no point
% in letting people use the wrong ones.

  % With the convention this is more easily interpreted as starting in the
  % mover coordinates, then transposing to take the inverse.
  basis = eye(4);
  X = basis(:, 1);
  Y = basis(:, 2);
  Z = basis(:, 3);
  % [out up] are the mover unit vectors that map onto the fixture Y and
  % Z.
  table = {
      'YoutZup' [+Y +Z]
      'ZinYup'	[-Z +Y]
      'ZinXdown' [-Z -X]
      'XoutZup'	[+X +Z]
      'ZoutYup' [+Z +Y]
      'XinYup'	[-X +Y]
  };
  
  b1 = table(strcmp(wot, table(:,1)), 2);
  if (isempty(b1))
    error('Unknown fixture code: %s', wot);
  end
  % The YZ basis
  rot = zeros(3);
  rot(1:3, 2:3) = b1{1}(1:3, :);
  % Fill in X from right hand rule
  rot(1:3, 1) = cross(rot(:, 2), rot(:, 3));
  if (fixture_to_mover)
    % We want the inverse mapping, so transpose rotation
    rot = rot';
  end
  T = eye(4);
  T(1:3, 1:3) = rot;
  
  angles = tr2vector(T);
  angles = angles(4:6);
end % non-nested fix_lookup

function [res] = find_sign_pattern (file, patterns, what)
% Find the sign pattern in options.source_signs or options.sensor_signs
  for ix = 1:size(patterns, 1)
    if (~isempty(regexp(file, patterns{ix, 1})))
      res = patterns{ix, 2};
      fprintf(1, '%s: %s [%d %d %d]\n', file, what, res(1), res(2), res(3));
      return
    end
  end
  res = [1 1 1];
end % non-nested find_sign_pattern

function [options] = interfere_options (varargin)
    % Return options struct for interference testing (metal, EMI)

    % Where to find calibration files
    options.cal_directory = 'd:/ilemt_cal_data/cal_9_15_premo_cmu/output/';

    % Prefix of the calibration file, less _lr_cal, _hr_cal, etc.
    options.cal_file_base = 'XYZ';

    % This controls whether we use the concetric calibration and kim18 solution.
    options.concentric = false;

    % These options are passed to pose_solution(), see check_poses_options()
    % for description.
    options.valid_threshold = 1e-5;
    options.hemisphere = 1;
    options.linear_correction = true;

    options.compensate_stage = false;
    options.source_signs = {};
    options.sensor_signs = {};
    options.ishigh = true;

    optfile = './local_interfere_options.m';
    if (exist(optfile, 'file'))
      run(optfile);
    end

    for (key_ix = 1:2:(length(varargin) - 1))
      key = varargin{key_ix};
      if (isfield(options, key))
        options.(key) = varargin{key_ix + 1};
      else
        error('Unknown option: %s', key);
      end
    end
end

function [cal, options] = load_interfere_cal (options)
    % Load suitable calibration for interfere_options, selecting according 
    % to options.concentric and options.ishigh.  options is updated with pose
    % solution options and needs to be used by the caller.

    prefix = [options.cal_directory options.cal_file_base];

    if (options.concentric)
      prefix = [prefix '_concentric'];
      options.pose_solution = 'kim18';
    else
      if (options.ishigh)
        options.concentric_cal_file = [prefix '_concentric_hr_cal'];
      else
        options.concentric_cal_file = [prefix '_concentric_lr_cal'];
      end
      options.pose_solution = 'optimize';
    end

    if (options.ishigh)
      cal = load_cal_file([prefix '_hr_cal']);
    else
      cal = load_cal_file([prefix '_lr_cal']);
    end
end

%% Plot High-Low Comparison Function
function plotHighLow(transResult, rotResult, transResultLow, rotResultLow, rod_metal, sheet_metal, num_data, axis_1, axis_2, data)
    name ={'High = Low', 'Hollow LC Steel', 'Hollow 416 SS', 'Hollow 304 SS', 'Hollow 6061 Al', 'Hollow Ti Gr 5', 'Hollow Copper', ...
        'Sheet LC Steel', 'Sheet 304 SS', 'Sheet 6061 Al', 'Sheet Copper', ...
         'Solid LC Steel', 'Solid 416 SS', 'Solid 304 SS', 'Solid 6061 Al', 'Solid Ti Gr 5', 'Solid Copper'};
    true_transResult_hollow = [];
    true_transResultLow_hollow = [];
    true_transResult_solid = [];
    true_transResultLow_solid = [];
    true_transResult_sheet = [];
    true_transResultLow_sheet = [];
    
    true_rotResult_hollow = [];
    true_rotResultLow_hollow = [];
    true_rotResult_solid = [];
    true_rotResultLow_solid = [];
    true_rotResult_sheet = [];
    true_rotResultLow_sheet = [];
    
    i = 1;
    start = 1;
    while i<=size(data,1)
        if string(data.MetalShape(i)) == "hollow"
            position = find(axis_1 == rod_metal);
            true_transResult_hollow = [true_transResult_hollow; transResult(start+position-1)];
            true_transResultLow_hollow = [true_transResultLow_hollow; transResultLow(start+position-1)];
            true_rotResult_hollow = [true_rotResult_hollow; rotResult(start+position-1)];
            true_rotResultLow_hollow = [true_rotResultLow_hollow; rotResultLow(start+position-1)];                    
            start = start+num_data(i)-2;
        elseif string(data.MetalShape(i)) == "solid"
            position = find(axis_1 == rod_metal);
            true_transResult_solid = [true_transResult_solid; transResult(start+position-1)];
            true_transResultLow_solid = [true_transResultLow_solid; transResultLow(start+position-1)];
            true_rotResult_solid = [true_rotResult_solid; rotResult(start+position-1)];
            true_rotResultLow_solid = [true_rotResultLow_solid; rotResultLow(start+position-1)];                    
            start = start+num_data(i)-2;
        else
            position = find(axis_2 == sheet_metal);
            true_transResult_sheet = [true_transResult_sheet; transResult(start+position-1)];
            true_transResultLow_sheet = [true_transResultLow_sheet; transResultLow(start+position-1)];
            true_rotResult_sheet = [true_rotResult_sheet; rotResult(start+position-1)];
            true_rotResultLow_sheet = [true_rotResultLow_sheet; rotResultLow(start+position-1)];                    
            start = start+num_data(i)-2;
        end
        i=i+1;
    end
            
            true_transResult = cat(1,true_transResult_hollow,true_transResult_sheet,true_transResult_solid);
            true_rotResult = cat(1,true_rotResult_hollow,true_rotResult_sheet,true_rotResult_solid);
            true_transResultLow = cat(1,true_transResultLow_hollow,true_transResultLow_sheet,true_transResultLow_solid);
            true_rotResultLow = cat(1,true_rotResultLow_hollow,true_rotResultLow_sheet,true_rotResultLow_solid);
            
            % Translational Error plot
            subplot(1,2,1)

            x = true_transResult;
            y = x;
            loglog(x, y);
            axis equal;
            S = 100;
            hold on 

            scatter(true_transResult_hollow(1), true_transResultLow_hollow(1), S, 'red', 'filled')
            scatter(true_transResult_hollow(2), true_transResultLow_hollow(2), S, 'green', 'filled')
            scatter(true_transResult_hollow(3), true_transResultLow_hollow(3), S, 'magenta', 'filled')
            scatter(true_transResult_hollow(4), true_transResultLow_hollow(4), S, 'b', 'filled')
            scatter(true_transResult_hollow(5), true_transResultLow_hollow(5), S, 'black', 'filled')
            scatter(true_transResult_hollow(6), true_transResultLow_hollow(6), S, 'cyan', 'filled')
            scatter(true_transResult_sheet(1), true_transResultLow_sheet(1), S, 'red^')
            scatter(true_transResult_sheet(2), true_transResultLow_sheet(2), S, 'magenta^')
            scatter(true_transResult_sheet(3), true_transResultLow_sheet(3), S, 'b^')
            scatter(true_transResult_sheet(4), true_transResultLow_sheet(4), S, 'cyan^')
            scatter(true_transResult_solid(1), true_transResultLow_solid(1), S, 'r*')
            scatter(true_transResult_solid(2), true_transResultLow_solid(2), S, 'g*')
            scatter(true_transResult_solid(3), true_transResultLow_solid(3), S, 'm*')
            scatter(true_transResult_solid(4), true_transResultLow_solid(4), S, 'b*')
            scatter(true_transResult_solid(5), true_transResultLow_solid(5), S, 'black*')
            scatter(true_transResult_solid(6), true_transResultLow_solid(6), S, 'cyan*')

            daspect([1 1 1])
            hold off

            xlabel("High Carrier Effects (log scale)")
            ylabel("Low Carrier Effects (log scale)")
            title({'12 Metals High Carrier versus Low Carrier Translation Error Comparison on',['(' num2str(rod_metal) ',0) for Hollow and Solid Metals, (' num2str(sheet_metal) ',0) for Sheet Metal']})
            legend(name ,'Location','northwest')

            % Rotation Error plot
            subplot(1,2,2)

            x1 = true_rotResult;
            y1 = x1;
            loglog(x1, y1);
            axis equal;
            hold on 
            scatter(true_rotResult_hollow(1), true_rotResultLow_hollow(1), S, 'red', 'filled')
            scatter(true_rotResult_hollow(2), true_rotResultLow_hollow(2), S, 'green', 'filled')
            scatter(true_rotResult_hollow(3), true_rotResultLow_hollow(3), S, 'magenta', 'filled')
            scatter(true_rotResult_hollow(4), true_rotResultLow_hollow(4), S, 'b', 'filled')
            scatter(true_rotResult_hollow(5), true_rotResultLow_hollow(5), S, 'black', 'filled')
            scatter(true_rotResult_hollow(6), true_rotResultLow_hollow(6), S, 'cyan', 'filled')
            scatter(true_rotResult_sheet(1), true_rotResultLow_sheet(1), S, 'red^')
            scatter(true_rotResult_sheet(2), true_rotResultLow_sheet(2), S, 'magenta^')
            scatter(true_rotResult_sheet(3), true_rotResultLow_sheet(3), S, 'b^')
            scatter(true_rotResult_sheet(4), true_rotResultLow_sheet(4), S, 'cyan^')
            scatter(true_rotResult_solid(1), true_rotResultLow_solid(1), S, 'r*')
            scatter(true_rotResult_solid(2), true_rotResultLow_solid(2), S, 'g*')
            scatter(true_rotResult_solid(3), true_rotResultLow_solid(3), S, 'm*')
            scatter(true_rotResult_solid(4), true_rotResultLow_solid(4), S, 'b*')
            scatter(true_rotResult_solid(5), true_rotResultLow_solid(5), S, 'black*')
            scatter(true_rotResult_solid(6), true_rotResultLow_solid(6), S, 'cyan*')

            daspect([1 1 1])
            hold off

            xlabel("High Carrier Effects (log scale)")
            ylabel("Low Carrier Effects (log scale)")
            title({'12 Metals High Carrier versus Low Carrier Rotation Error Comparison on',['(' num2str(rod_metal) ',0) for Hollow and Solid Metals, (' num2str(sheet_metal) ',0) for Sheet Metal']})      
            legend(name,'Location','northwest')

            % Write error ratio (Low carrier/High carrier)
            HLtrans = table();
            HLrot = table();
            ratio_trans = true_transResultLow./true_transResult; 
            ratio_rot = true_rotResultLow./true_rotResult;
            for i = 1:numel(true_transResult)
                HLtrans_new = {name(i+1), true_transResult(i), true_transResultLow(i), ratio_trans(i)};
                HLrot_new = {name(i+1), true_rotResult(i), true_rotResultLow(i), ratio_rot(i)};

                HLtrans = [HLtrans; HLtrans_new];
                HLrot = [HLrot; HLrot_new];
            end
            HLtrans.Properties.VariableNames = {'MetalShape', 'High_Carrier', 'Low_Carrier','LowHigh_Ratio'};
            HLrot.Properties.VariableNames = {'MetalShape', 'High_Carrier', 'Low_Carrier','LowHigh_Ratio'};

            savefilename = 'transResult_Ratio.xlsx';
            fprintf('\nTranslational Table has been written to Excel successfully.\n')
            writetable(HLtrans, savefilename);

            savefilename = 'rotResult_Ratio.xlsx';
            fprintf('Rotational Table has been written to Excel successfully.\n')
            writetable(HLrot, savefilename);            
end 

%% Plot x-moving Function for Hollow and Solid metal
function plotxmoving(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control, ob, point)
    % x axis
    x0=axis;
    
    % Axis limit for translational error plot
    x_trans = [0 50];
    y_trans = [1e-6 2e-2];
    
    % Axis limit for rotational error plot
    x_rot = [0 50];
    y_rot = [1e-5 2e-1];
    
    %% Parameter for Translation - High carrier
    step = numel(transResult) / size(data, 1);
    
    % Initialize an array of cells to store the split subset
    num_subsets = floor(length(transResult) / step);
    subsets = cell(1, num_subsets);
    
    % Split data and convert to row vectors using for loops
    for i = 1:num_subsets
        start_idx = (i - 1) * step + 1;
        end_idx = i * step;
        subset = transResult(start_idx:end_idx);
        subset_row_vector = subset'; 
        subsets{i} = subset_row_vector;
    end
    %% Parameter for Rotation - high carrier
    % Initialize an array of cells to store the split subset
    num_subsetsRot = floor(length(rotResult) / step);
    subsetsRot = cell(1, num_subsetsRot);
    
    % Split data and convert to row vectors using for loops
    for i = 1:num_subsetsRot
        start_idx = (i - 1) * step + 1;
        end_idx = i * step;
        subsetRot = rotResult(start_idx:end_idx);
        subset_row_vector_rot = subsetRot'; 
        subsetsRot{i} = subset_row_vector_rot;
    end
    
    %% Axis Legend assign
    if skip_control ==1
        hollow = 1:numel(subsets)/2;
        solid = numel(subsets)/2 + 1:numel(subsets);
        name = (data.MetalName(1:numel(subsets)/2));
    else
        hollow = 2:numel(subsets)/2;
        solid = numel(subsets)/2 + 2:numel(subsets);
        name = (data.MetalName(2:numel(subsets)/2));
    end
    
    switch ob
        case 1
            %% High carrier - Hollow metal
            % Plot translation error 
            figure;
            subplot(2,1,1)
            for j = hollow 
                semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Hollow Metals High Carrier Effects Translation Error on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Translation Error(m)') 
            xlabel('X Position(cm)') 
            legend(name)
            xlim(x_trans)
            ylim(y_trans)

            % Plot rotation error
            subplot(2,1,2)
            for j = hollow 
                semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Hollow Metals High Carrier Effects Rotation Error on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Rotation Error(rad)') 
            xlabel('X Position(cm)') 
            legend(name)
            xlim(x_rot)
            ylim(y_rot)   
            %% High carrier - Solid Metal
            % Plot translation error 
            figure;
            subplot(2,1,1)

            for j = solid
                semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Solid Metals High Carrier Effects Translation Error on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Translation Error(m)') 
            xlabel('X Position(cm)') 
            legend(name)
            xlim(x_trans)
            ylim(y_trans)

            % Plot rotation error
            subplot(2,1,2)    
            for j = solid  
                semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Solid Metals High Carrier Effects Rotation Error on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Rotation Error(rad)') 
            xlabel('X Position(cm)') 
            legend(name)
            xlim(x_rot)
            ylim(y_rot) 

            %% Parameter for translation - low caarrier
            step = numel(transResultLow) / size(data, 1);

            % Initialize an array of cells to store the split subset
            num_subsets = floor(length(transResultLow) / step);
            subsets = cell(1, num_subsets);

            % Split data and convert to row vectors using for loops
            for i = 1:num_subsets
                start_idx = (i - 1) * step + 1;
                end_idx = i * step;
                subset = transResultLow(start_idx:end_idx);
                subset_row_vector = subset'; 
                subsets{i} = subset_row_vector;
            end

            %% Parameter for rotation - low carrier
            % Initialize an array of cells to store the split subset
            num_subsetsRot = floor(length(rotResultLow) / step);
            subsetsRot = cell(1, num_subsetsRot);

            % Split data and convert to row vectors using for loops
            for i = 1:num_subsetsRot
                start_idx = (i - 1) * step + 1;
                end_idx = i * step;
                subsetRot = rotResultLow(start_idx:end_idx);
                subset_row_vector_rot = subsetRot'; 
                subsetsRot{i} = subset_row_vector_rot;
            end

            %% Low carrier - Hollow metal
            %Plot translation error 
            figure;
            subplot(2,1,1)
            for j = hollow 
                semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Hollow Metals Low Carrier Effects Translation Error on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Translation Error(m)') 
            xlabel('X Position(cm)') 
            legend(name)
            xlim(x_trans)
            ylim(y_trans)

            % Plot rotation error
            subplot(2,1,2)  
            for j = hollow
                semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Hollow Metals Low Carrier Effects Rotation Error on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Rotation Error(rad)') 
            xlabel('X Position(cm)') 
            legend(name)
            xlim(x_rot)
            ylim(y_rot)  

            %% Low carrier - Solid metal
            %Plot translation error 
            figure;
            subplot(2,1,1)

            for j = solid
                semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Solid Metals Low Carrier Effects Translation Error on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Translation Error(m)') 
            xlabel('X Position(cm)') 
            legend(name)
            xlim(x_trans)
            ylim(y_trans)

            % Plot rotation error
            subplot(2,1,2)   
            for j = solid  
                semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Solid Metals Low Carrier Effects Rotation Error on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Rotation Error(rad)') 
            xlabel('X Position(cm)') 
            legend(name)
            xlim(x_rot)
            ylim(y_rot)
        case 2
            %% Coupling magnitude plot
            % High carrier
            figure;
            for j = hollow
                semilogy(x0, disArray((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Hollow Metals High Carrier Effects Coupling Magnitude on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Coupling Magnitude') 
            xlabel('X Position(cm)') 
            legend(name)

            figure;
            for j = solid
                semilogy(x0, disArray((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Solid Metals High Carrier Effects Coupling Magnitude on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Coupling Magnitude') 
            xlabel('X Position(cm)') 
            legend(name)

            % Low carrier
            figure;
            for j = hollow
                semilogy(x0, disArrayLow((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Hollow Metals Low Carrier Effects Coupling Magnitude on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Coupling Magnitude') 
            xlabel('X Position(cm)') 
            legend(name)

            figure;
            for j = solid
                semilogy(x0, disArrayLow((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Solid Metals Low Carrier Effects Coupling Magnitude on y = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Coupling Magnitude') 
            xlabel('X Position(cm)') 
            legend(name)
    end
end

%% Plot y-moving Function for Hollow and Solid metal
function plotymoving(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control, ob, point)
    %% y axis
    x0=axis;
    %% Parameter for translation - HIGH CARRIER
    step = numel(transResult) / size(data, 1);
    
    % Initialize an array of cells to store the split subset
    num_subsets = floor(length(transResult) / step);
    subsets = cell(1, num_subsets);

    % Split data and convert to row vectors using for loops
    for i = 1:num_subsets
        start_idx = (i - 1) * step + 1;
        end_idx = i * step;
        subset = transResult(start_idx:end_idx);
        subset_row_vector = subset'; 
        subsets{i} = subset_row_vector;
    end
    %% Parameter for rotation  - HIGH CARRIER
    % Initialize an array of cells to store the split subset
    num_subsetsRot = floor(length(rotResult) / step);
    subsetsRot = cell(1, num_subsetsRot);
    
    % Split data and convert to row vectors using for loops
    for i = 1:num_subsetsRot
        start_idx = (i - 1) * step + 1;
        end_idx = i * step;
        subsetRot = rotResult(start_idx:end_idx);
        subset_row_vector_rot = subsetRot'; 
        subsetsRot{i} = subset_row_vector_rot;
    end
    %% 
    if skip_control ==1
        solid = 1:numel(subsets);
        name = data.MetalName((1:numel(subsets)));
    else
        solid = 2:numel(subsets);
        name = data.MetalName((2:numel(subsets)));
    end

    switch ob
        case 1
        %% HIGH CARRIER SOLID METAL
        % Plot translation error 
            figure;
            subplot(2,1,1)  
            for j = solid
                semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
                hold on
            end

            grid on
        %     title("Solid LC Steel and 6061 Al High Carrier Effects Translation Error on x = 5 and Rotate "+string(deg)+" Degree")
            title("Solid Metals High Carrier Effects Translation Error on x = "+string(point)+" and Rotate "+string(deg)+" Degree") 
            ylabel('Translation Error(m)') 
            xlabel('Y Position(cm)') 
        %     legend('High Carrier '+string(data.MetalName(1)), 'High Carrier '+string(data.MetalName(2)))
            legend(name)    

            % Save the translation error plot
        %     saveas(gcf, savePath1, 'fig');

            % Plot rotation error
            subplot(2,1,2)
            for j = solid
                semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
                hold on
            end

            grid on

        %     title("Solid LC Steel and 6061 Al High Carrier Effects Rotation Error on x = 5 and Rotate "+string(deg)+" Degree")
            title("Solid Metals High Carrier Effects Rotation Error on x = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Rotation Error(rad)') 
            xlabel('Y Position(cm)') 
        %     legend('High Carrier '+string(data.MetalName(numel(subsetsRot)/2+1)), 'High Carrier '+string(data.MetalName(numel(subsetsRot)/2+2)))
            legend(name)  

             %% Parameter for translation - LOW CARRIER
            step = numel(transResultLow) / size(data, 1);

            % Initialize an array of cells to store the split subset
            num_subsets = floor(length(transResultLow) / step);
            subsets = cell(1, num_subsets);

            % Split data and convert to row vectors using for loops
            for i = 1:num_subsets
                start_idx = (i - 1) * step + 1;
                end_idx = i * step;
                subset = transResultLow(start_idx:end_idx);
                subset_row_vector = subset'; 
                subsets{i} = subset_row_vector;
            end

            %% Parameter for rotation  - LOW CARRIER
            % Initialize an array of cells to store the split subset
            num_subsetsRot = floor(length(rotResultLow) / step);
            subsetsRot = cell(1, num_subsetsRot);

            % Split data and convert to row vectors using for loops
            for i = 1:num_subsetsRot
                start_idx = (i - 1) * step + 1;
                end_idx = i * step;
                subsetRot = rotResultLow(start_idx:end_idx);
                subset_row_vector_rot = subsetRot'; 
                subsetsRot{i} = subset_row_vector_rot;
            end

            %% LOW CARRIER SOLID METAL
            % Plot translation error 
            figure;
            subplot(2,1,1)  
            for j = solid
                semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
                hold on
            end

            grid on
        %     title("Solid LC Steel and 6061 Al Low Carrier Effects Translation Error on x = 5 and Rotate "+string(deg)+" Degree")
            title("Solid Metals Low Carrier Effects Translation Error on x = "+string(point)+" and Rotate "+string(deg)+" Degree")

            ylabel('Translation Error(m)') 
            xlabel('Y Position(cm)') 
        %     legend('Low Carrier '+string(data.MetalName(1)), 'Low Carrier '+string(data.MetalName(2)))
            legend(name)  

            % Save the translation error plot
        %     saveas(gcf, savePath1, 'fig');

            % Plot rotation error
            subplot(2,1,2)
            for j = solid
                semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
                hold on
            end

            grid on

        %     title("Solid LC Steel and 6061 Al Low Carrier Effects Rotation Error on x = 5 and Rotate "+string(deg)+" Degree")
            title("Solid Metals Low Carrier Effects Rotation Error on x = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Rotation Error(rad)') 
            xlabel('Y Position(cm)') 
        %     legend('Low Carrier '+string(data.MetalName(numel(subsetsRot)/2+1)), 'Low Carrier '+string(data.MetalName(numel(subsetsRot)/2+2)))
            legend(name)  
        case 2
            %% Couplings different plot for HIGH carrier
            figure;
            for j = solid
                semilogy(x0, disArray((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("Solid Metals High Carrier Effects Coupling Magnitude on x = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Coupling Magnitude') 
            xlabel('X Position(cm)') 
            legend(name)

            figure;
            for j = solid
                semilogy(x0, disArrayLow((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("Solid Metals Low Carrier Effects Coupling Magnitude on x = "+string(point)+" and Rotate "+string(deg)+" Degree")
            ylabel('Coupling Magnitude') 
            xlabel('X Position(cm)') 
            legend(name)    
    end
end

%% Plot Sheet Metal Function
function plotsheet(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control, ob)
    %% x axis
    x0 = axis;
    
%     % Axis limit for translational error plot
%     x_trans = [0 50];
%     y_trans = [1e-6 2e-2];
%     
%     % Axis limit for rotational error plot
%     x_rot = [0 50];
%     y_rot = [1e-5 2e-1];
    
    %% Parameter for translation - High carrier
    step = numel(transResult) / size(data, 1);
    
    % Initialize an array of cells to store the split subset
    num_subsets = floor(length(transResult) / step);
    subsets = cell(1, num_subsets);
    
    % Split data and convert to row vectors using for loops
    for i = 1:num_subsets
        start_idx = (i - 1) * step + 1;
        end_idx = i * step;
        subset = transResult(start_idx:end_idx);
        subset_row_vector = subset'; 
        subsets{i} = subset_row_vector;
    end

    %% Parameter for rotation  - High carrier
    % Initialize an array of cells to store the split subset
    num_subsetsRot = floor(length(rotResult) / step);
    subsetsRot = cell(1, num_subsetsRot);
    
    % Split data and convert to row vectors using for loops
    for i = 1:num_subsetsRot
        start_idx = (i - 1) * step + 1;
        end_idx = i * step;
        subsetRot = rotResult(start_idx:end_idx);
        subset_row_vector_rot = subsetRot'; 
        subsetsRot{i} = subset_row_vector_rot;
    end

    %% Axis Legend assign
    if skip_control ==1
        sheet = 1:numel(subsets);
        name = data.MetalName((1:numel(subsets)));
    else
        sheet = 2:numel(subsets);
        name = data.MetalName((2:numel(subsets)));
    end
  
    switch ob
        case 1
            %% High carrier
            % Plot translation error 
            figure;
            subplot(2,1,1)  
            for j = sheet
                semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
                hold on
            end

            grid on
            
            title("Four Sheet Metals High Carrier Effects Translation Error on X=["+string(x0(1))+"..."+string(x0(end))+"] and Rotate "+string(deg)+" Degree")
            ylabel('Translation Error(m)') 
            xlabel('X Position(cm)') 
            legend(name)

            % Plot rotation error
            subplot(2,1,2)
            for j = sheet
                semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
                hold on
            end

            grid on
            title("Four Sheet Metals High Carrier Effects Rotation Error on X=["+string(x0(1))+"..."+string(x0(end))+"] and Rotate "+string(deg)+" Degree")
            ylabel('Rotation Error(rad)') 
            xlabel('X Position(cm)') 
            legend(name)

             %% Parameter for translation - Low carrier
            step = numel(transResultLow) / size(data, 1);

            % Initialize an array of cells to store the split subset
            num_subsets = floor(length(transResultLow) / step);
            subsets = cell(1, num_subsets);

            % Split data and convert to row vectors using for loops
            for i = 1:num_subsets
                start_idx = (i - 1) * step + 1;
                end_idx = i * step;
                subset = transResultLow(start_idx:end_idx);
                subset_row_vector = subset'; 
                subsets{i} = subset_row_vector;
            end

            %% Parameter for rotation  - Low carrier
            % Initialize an array of cells to store the split subset
            num_subsetsRot = floor(length(rotResultLow) / step);
            subsetsRot = cell(1, num_subsetsRot);

            % Split data and convert to row vectors using for loops
            for i = 1:num_subsetsRot
                start_idx = (i - 1) * step + 1;
                end_idx = i * step;
                subsetRot = rotResultLow(start_idx:end_idx);
                subset_row_vector_rot = subsetRot'; 
                subsetsRot{i} = subset_row_vector_rot;
            end

            %% LOW CARRIER SHEET METAL
            % Plot translation error 
            figure;
            subplot(2,1,1)  
            for j = sheet
                semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
                hold on
            end

            grid on
            title("Four Sheet Metals Low Carrier Effects Translation Error on X=["+string(x0(1))+"..."+string(x0(end))+"] and Rotate "+string(deg)+" Degree")
            ylabel('Translation Error(m)') 
            xlabel('X Position(cm)') 
            legend(name)

            % Plot rotation error
            subplot(2,1,2)
            for j = sheet
                semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
                hold on
            end

            grid on
            title("Four Sheet Metals Low Carrier Effects Rotation Error on X=["+string(x0(1))+"..."+string(x0(end))+"] and Rotate "+string(deg)+" Degree")
            ylabel('Rotation Error(rad)') 
            xlabel('X Position(cm)') 
            legend(name)

        case 2
            %% Coupling magnitude plot
            % High carrier
            figure;
            for j = sheet
                semilogy(x0, disArray((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Sheet Metals High Carrier Effects Coupling Magnitude on X=["+string(x0(1))+"..."+string(x0(end))+"] and Rotate "+string(deg)+" Degree")
            ylabel('Coupling Magnitude') 
            xlabel('X Position(cm)') 
            legend(name)

            % Low carrier
            figure;
            for j = sheet
                semilogy(x0, disArrayLow((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
                hold on
            end
            grid on
            title("All Sheet Metals Low Carrier Effects Coupling Magnitude on X=["+string(x0(1))+"..."+string(x0(end))+"] and Rotate "+string(deg)+" Degree")
            ylabel('Coupling Magnitude') 
            xlabel('X Position(cm)') 
            legend(name)
    end
    
end