function plotsheet(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control)
    %% x axis
    x0 = axis;
    
    
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
        sheet = 1:numel(subsets);
        name = data.MetalName((1:numel(subsets)));
    else
        sheet = 2:numel(subsets);
        name = data.MetalName((2:numel(subsets)));
    end
    %% HIGH CARRIER SHEET METAL
    % Plot translation error 
    figure;
    subplot(2,1,1)  
    for j = sheet
        semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
        hold on
    end

    grid on
    title("Four Sheet Metals High Carrier Effects Translation Error on X=[16..100] and Rotate "+string(deg)+" Degree")
    ylabel('Translation Error(m)') 
    xlabel('X Position(cm)') 
    legend(name)
    
    % Save the translation error plot
%     saveas(gcf, savePath1, 'fig');

    % Plot rotation error
    subplot(2,1,2)
    for j = sheet
        semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
        hold on
    end

    grid on
    title("Four Sheet Metals High Carrier Effects Rotation Error on X=[16..100] and Rotate "+string(deg)+" Degree")
    ylabel('Rotation Error(rad)') 
    xlabel('X Position(cm)') 
    legend(name)

%     % Save the translation error plot
%     saveas(gcf, savePath1, 'fig');

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
    
    %% LOW CARRIER SHEET METAL
    % Plot translation error 
    figure;
    subplot(2,1,1)  
    for j = sheet
        semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
        hold on
    end

    grid on
    title("Four Sheet Metals Low Carrier Effects Translation Error on X=[16..100] and Rotate "+string(deg)+" Degree")
    ylabel('Translation Error(m)') 
    xlabel('X Position(cm)') 
    legend(name)
    
    % Save the translation error plot
%     saveas(gcf, savePath1, 'fig');

    % Plot rotation error
    subplot(2,1,2)
    for j = sheet
        semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
        hold on
    end

    grid on
    title("Four Sheet Metals Low Carrier Effects Rotation Error on X=[16..100] and Rotate "+string(deg)+" Degree")
    ylabel('Rotation Error(rad)') 
    xlabel('X Position(cm)') 
    legend(name)

%     % Save the translation error plot
%     saveas(gcf, savePath1, 'fig');
%% Couplings different plot for HIGH carrier
    figure;
    for j = sheet
        semilogy(x0, disArray((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Sheet Metals High Carrier Effects Coupling Magnitude on X=[16..100] and Rotate "+string(deg)+" Degree")
    ylabel('Coupling Magnitude') 
    xlabel('X Position(cm)') 
    legend(name)
    
    figure;
    for j = sheet
        semilogy(x0, disArrayLow((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Sheet Metals Low Carrier Effects Coupling Magnitude on X=[16..100] and Rotate "+string(deg)+" Degree")
    ylabel('Coupling Magnitude') 
    xlabel('X Position(cm)') 
    legend(name)
    
end