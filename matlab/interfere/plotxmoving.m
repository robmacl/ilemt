function plotxmoving(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis)
    % x axis
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
    %% HIGH CARRIER HOLLOW METAL
    % Plot translation error 
    figure;
    subplot(2,1,1)
    for j = 1:numel(subsets)/2
        semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Hollow Metals High Carrier Effects Translation Error on y = 0 and Rotate "+string(deg)+" Degree")
    ylabel('Translation Error(m)') 
    xlabel('X Position(cm)') 
    legend(string(data.MetalName(1:numel(subsets)/2)))
    
    % Plot rotation error
    subplot(2,1,2)
    for j = 1:numel(subsetsRot)/2
        semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Hollow Metals High Carrier Effects Rotation Error on y = 0 and Rotate "+string(deg)+" Degree")
    ylabel('Rotation Error(rad)') 
    xlabel('X Position(cm)') 
    legend(string(data.MetalName(1:numel(subsetsRot)/2)))
    
%     % Save the translation error plot
%     saveas(gcf, savePath1, 'fig');

    %% HIGH CARRIER SOLID METAL
    % Plot translation error 
    figure;
    subplot(2,1,1)
    
    for j = numel(subsets)/2 + 1:numel(subsets)
        semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Solid Metals High Carrier Effects Translation Error on y = 0 and Rotate "+string(deg)+" Degree")
    ylabel('Translation Error(m)') 
    xlabel('X Position(cm)') 
    legend(string(data.MetalName(numel(subsets)/2 + 1:numel(subsets))))
    
    % Plot rotation error
    subplot(2,1,2)    
    for j = numel(subsetsRot)/2 + 1:numel(subsetsRot)
        semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Solid Metals High Carrier Effects Rotation Error on y = 0 and Rotate "+string(deg)+" Degree")
    ylabel('Rotation Error(rad)') 
    xlabel('X Position(cm)') 
    legend(string(data.MetalName(numel(subsetsRot)/2 + 1:numel(subsetsRot))))

%     % Save the translation error plot
%     saveas(gcf, savePath2, 'fig');

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
    
    %% LOW CARRIER HOLLOW METAL
    %Plot translation error 
    figure;
    subplot(2,1,1)

    for j = 1:numel(subsets)/2
        semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Hollow Metals Low Carrier Effects Translation Error on y = 0 and Rotate "+string(deg)+" Degree")
    ylabel('Translation Error(m)') 
    xlabel('X Position(cm)') 
    legend(string(data.MetalName(1:numel(subsets)/2)))
    
    % Plot rotation error
    subplot(2,1,2)    
    for j = 1:numel(subsetsRot)/2
        semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Hollow Metals Low Carrier Effects Rotation Error on y = 0 and Rotate "+string(deg)+" Degree")
    ylabel('Rotation Error(rad)') 
    xlabel('X Position(cm)') 
    legend(string(data.MetalName(1:numel(subsetsRot)/2)))
    

    %% LOW CARRIER SOLID METAL
    %Plot translation error 
    figure;
    subplot(2,1,1)
    
    for j = numel(subsets)/2 + 1:numel(subsets)
        semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Solid Metals Low Carrier Effects Translation Error on y = 0 and Rotate "+string(deg)+" Degree")
    ylabel('Translation Error(m)') 
    xlabel('X Position(cm)') 
    legend(string(data.MetalName(numel(subsets)/2 + 1:numel(subsets))))
    
    % Plot rotation error
    subplot(2,1,2)    
    for j = numel(subsetsRot)/2 + 1:numel(subsetsRot)
        semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Solid Metals Low Carrier Effects Rotation Error on y = 0 and Rotate "+string(deg)+" Degree")
    ylabel('Rotation Error(rad)') 
    xlabel('X Position(cm)') 
    legend(string(data.MetalName(numel(subsetsRot)/2 + 1:numel(subsetsRot))))

%     % Save the translation error plot
%     saveas(gcf, savePath2, 'fig');
end