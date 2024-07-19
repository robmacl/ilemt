function [resultArray, data, disArray] = ExtractData(fileDirectory, op_ishigh)  
    format longE
    %% Create a table according to the dat files
    % Specify the directory where the DAT file is located
    files = dir(fullfile(fileDirectory, '*.dat'));
    % Create a mapping rule to map numbers to metal names
    metalMap = containers.Map({0,1, 2, 3, 4, 5, 6, 7}, {'Control', 'LC Steel', '416 SS', '304 SS', '6061 Al', 'Ti Grade 5', 'Copper', 'test'});
    % Create an empty table
    data = table();
    
    %% Find the first number after a word using regular expression
    pattern = '(hollow|solid|sheet|x5y0)(\d+)';
%     pattern = '(h|s|sheet|x5y0)(\d+)';
    
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
    disp(data);
    %% Define a cell array to accumulate results for each file
    % store poses result
    resultArray = [];
    disArray = [];   
    matrix_couplings = []; 

    % check_metal.m
    options = interfere_options('concentric', true);
    options.ishigh = op_ishigh;
    [cal, options] = load_interfere_cal(options);
    
    % Loop through each file
    
    for i = 1:numel(files)
   
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
         if strcmp(match(1,1), 'sheet')
             % Ignore data of 39th row for sheet metal data
%              poses(end, :) = [];
             resultArray = [resultArray; poses];
         else
            % Accumulate the results in the cell array
            resultArray = [resultArray; poses];
         end
    end

    % Now the results in resultsArray and the file/metal table in data
    
    %% Validity Check Process
    % store validity check pose_difference result
    diffVMResult = [];
    transVMResult = [];
    rotVMResult = [];
    
    i = 1;
    step = size(resultArray, 1) / size(data, 1);
    % count of loop
    count = 1;

    % Create an empty table for validity check
    VM = table();
    % Loop through the resultArray to get the pose difference
    while i <= (size(resultArray, 1) - step + 1) 
        diff = pose_difference(resultArray(i,:), resultArray((i + step - 1),:));
        
        i = i + step;
    
        transVM = sqrt(sum(diff(1,1:3).^2, 2));
        rotVM = sqrt(sum(diff(1,4:6).^2, 2));
    
        metalShape = data{count, 2};
        metalNum = data{count, 3};

        if count <= size(data,1)
            count = count + 1;
        end
        
        % Add new validity check to table
        newVM = {metalShape, metalNum, transVM, rotVM};
        VM = [VM; newVM];
       
        diffVMResult = [diffVMResult; diff];
        transVMResult = [transVMResult; transVM];
        rotVMResult = [rotVMResult; rotVM];
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
