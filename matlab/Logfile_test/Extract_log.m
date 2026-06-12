function [data, time, mag] = Extract_log(files)

    data = table();
    deviceMap = containers.Map({'iota', 'navio'}, {'iotamotion', 'Navio'});
    pattern = '(iota|navio)_(no|off|on)';
    
    for i = 1:numel(files)
        fileName = files(i).name;
    
        % Use regular expressions to match
        tokens = regexp(fileName, pattern, 'tokens');
            
        if ~isempty(tokens)
            % Extract matching keywords and numbers
            match = tokens{1};
            keyword = match{1};
            keyword2 = match{2};
    
            deviceName = deviceMap(keyword);
            
            % Add data to table
            newRow = {fileName, deviceName,keyword2};
            data = [data; newRow];
        end
    end
    
    data.Properties.VariableNames = {'FileName', 'Device', 'Status'};
    % Display table
    fprintf('\n****************************************************\n')
    fprintf('               Detail of data files')
    fprintf('\n****************************************************\n')
    disp(data);   
    
    for i = numel(files):-1:1
        file = char(append(string(files(i).folder)+'\\'+string(files(i).name)));
        tp = solve_poses(file)
        tp = load(tp);
        
        pose.hr = tp.poses(tp.entry_type == 0, :);
        pose.lr = tp.poses(tp.entry_type == 1, :);
        
        time.real.hr.(data.Status{i}) = tp.timestamp(tp.entry_type == 0, :);
        time.real.lr.(data.Status{i}) = tp.timestamp(tp.entry_type == 1, :);
    
        time.norm.hr.(data.Status{i}) = time.real.hr.(data.Status{i})-time.real.hr.(data.Status{i})(1);
        time.norm.lr.(data.Status{i}) = time.real.lr.(data.Status{i})-time.real.lr.(data.Status{i})(1);
        
        mag.trans.hr.(data.Status{i}) = vecnorm(pose.hr(:, 1:3),2,2);
        mag.trans.lr.(data.Status{i}) = vecnorm(pose.lr(:, 1:3),2,2);

        meanhr.trans = mean(mag.trans.hr.(data.Status{i}));
        meanlr.trans = mean(mag.trans.lr.(data.Status{i}));

        mag.trans.hr.(data.Status{i}) = mag.trans.hr.(data.Status{i})-meanhr.trans;
        mag.trans.lr.(data.Status{i}) = mag.trans.lr.(data.Status{i})-meanlr.trans;
    
        mag.rot.hr.(data.Status{i}) = vecnorm(pose.hr(:, 4:6),2,2);
        mag.rot.lr.(data.Status{i}) = vecnorm(pose.lr(:, 4:6),2,2);

        meanhr.rot = mean(mag.rot.hr.(data.Status{i}));
        meanlr.rot = mean(mag.rot.lr.(data.Status{i}));

        mag.rot.hr.(data.Status{i}) = mag.rot.hr.(data.Status{i})-meanhr.rot;
        mag.rot.lr.(data.Status{i}) = mag.rot.lr.(data.Status{i})-meanlr.rot;     
    
    end
end