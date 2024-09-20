function [result_all, data] = ExtractData(fileDirectory, op_ishigh)  
% Extract data from output files and do the validity check of the first and last 
% data points. 
% 
% Input arguments:
% fileDirectory:
%     Cell of the file directory.
% 
% op_ishigh:
%     Logical(true/false) for turning on and off options.ishigh paramter. The 
%     true logic is for converting result to high carrier data, the false, in the 
%     other hands, is for transforming to low carrier data. See interfere_options.m
%     for other sub-struct of options information.
% 
% Return values:
% result_all:
%     Struct of result data as listed:
%      - result_all.resultArray: double array of all translational and rotaional
%                                poses data
%      - result_all.coupling: double array of coupling magnitude
%      - result_all.num_data: double array of the amount of data points for each 
%                             output files
% 
% data:
%     Table with sub-cell array of FileName, MetalShape and MetalName.

    format longE
    %% Create a table according to the dat files
    % Specify the directory where the DAT file is located
    files = dir(fullfile(fileDirectory, '*.dat'));
    % Create a mapping rule to map numbers to metal names
    metalMap = containers.Map({0, 1, 2, 3, 4, 5, 6}, {'Control', 'LC Steel', '416 SS', '304 SS', '6061 Al', 'Ti Grade 5', 'Copper'});
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
    result_all = struct('resultArray', [], 'coupling', [], 'num_data', []);
    resultArray = [];
    coupling = [];
    num_data = [];
    
    % check_metal.m
    options = interfere_options('concentric', true);
    options.ishigh = op_ishigh;
    [cal, options] = load_interfere_cal(options);
    
    % Loop through each file
    
    for i = 1:numel(files)
        matrix_couplings = []; 
        % Read data from the file lists
        options.in_files = {fileDirectory+'\'+data{i,1}};%data{i,1};

        % Read data from the file
        [motion, couplings] = read_cal_data(options);
        matrix_couplings(:,:,:,i) = couplings;
        
        % Calculate normalized coupling magnitude
        diff = abs(matrix_couplings(:,:,1,i)- matrix_couplings(:,:,:,i));
        ref = sqrt(sum(sum((abs(matrix_couplings(:,:,1,i))).^2)));
        coupling_new = squeeze(sqrt(sum(sum(diff.^2))))/ref;
        coupling = [coupling; coupling_new(2:size(coupling_new,1)-1)];

        % Solve pose for the metal
        [poses, valid] = pose_solution(couplings, cal, options);
        resultArray = [resultArray; poses];
        
        % Collect the amount of data point in each file
        num_data = [num_data, size(poses,1)];
    end
    
    % Bundle three main results to struct of result_all
    result_all.resultArray = resultArray;
    result_all.coupling = coupling;
    result_all.num_data = num_data;
    
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
    while i <= (size(resultArray, 1))% - step + 1) 
        step = num_data(j);
        diff = pose_difference(resultArray(i,:), resultArray((i + step - 1),:));
        
        i = i + step;

        transVM = sqrt(sum(diff(1,1:3).^2, 2));
        rotVM = sqrt(sum(diff(1,4:6).^2, 2));
    
        metalShape = data.MetalShape{count};
        metalNum = data.MetalName{count};

        count = count +1;

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

    savefilename = fileDirectory+'/example.xlsx';  
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
