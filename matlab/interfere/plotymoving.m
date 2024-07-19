function plotymoving(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control)
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
    %%
    if skip_control ==1
        solid = 1:numel(subsets);
        name = data.MetalName((1:numel(subsets)));
    else
        solid = 2:numel(subsets);
        name = data.MetalName((2:numel(subsets)));
    end
%     %% HIGH CARRIER HOLLOW METAL
%     % Plot translation error 
%     figure;
%     subplot(2,1,1)  
%     for j = 1:numel(subsets)/2
%         semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
%         hold on
%     end
% 
%     grid on
%     title("Hollow LC Steel and 6061 Al High Carrier Effects Translation Error on x = 5 and Rotate "+string(deg)+" Degree")
%  
%     ylabel('Translation Error(m)') 
%     xlabel('Y Position(cm)') 
%     legend('High Carrier '+string(data.MetalName(1)), 'High Carrier '+string(data.MetalName(2)))
%     
%     % Save the translation error plot
% %     saveas(gcf, savePath1, 'fig');
% 
%     % Plot rotation error
%     subplot(2,1,2)
%     for j = 1:numel(subsetsRot)/2
%         semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
%         hold on
%     end
% 
%     grid on
% 
%     title("Hollow LC Steel and 6061 Al High Carrier Effects Rotation Error on x = 5 and Rotate "+string(deg)+" Degree")
%     ylabel('Rotation Error(rad)') 
%     xlabel('Y Position(cm)') 
%     legend('High Carrier '+string(data.MetalName(numel(subsetsRot)/2+1)), 'High Carrier '+string(data.MetalName(numel(subsetsRot)/2+2)))
% 
% %     % Save the translation error plot
% %     saveas(gcf, savePath1, 'fig');


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
    title("Solid Metals High Carrier Effects Translation Error on x = 20 and Rotate "+string(deg)+" Degree") 
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
    title("Solid Metals High Carrier Effects Rotation Error on x = 20 and Rotate "+string(deg)+" Degree")
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
    
%     %% LOW CARRIER HOLLOW METAL
%     % Plot translation error 
%     figure;
%     subplot(2,1,1)  
%     for j = 1:numel(subsets)/2
%         semilogy(x0, subsets{j}, '.-', 'MarkerSize', 8)
%         hold on
%     end
% 
%     grid on
%     title("Hollow LC Steel and 6061 Al Low Carrier Effects Translation Error on x = 5 and Rotate "+string(deg)+" Degree")
%  
%     ylabel('Translation Error(m)') 
%     xlabel('Y Position(cm)') 
%     legend('Low Carrier '+string(data.MetalName(1)), 'Low Carrier '+string(data.MetalName(2)))
%     
%     % Save the translation error plot
% %     saveas(gcf, savePath1, 'fig');
% 
%     % Plot rotation error
%     subplot(2,1,2)
%     for j = 1:numel(subsetsRot)/2
%         semilogy(x0, subsetsRot{j}, '.-', 'MarkerSize', 8)
%         hold on
%     end
% 
%     grid on
% 
%     title("Hollow LC Steel and 6061 Al Low Carrier Effects Rotation Error on x = 5 and Rotate "+string(deg)+" Degree")
%     ylabel('Rotation Error(rad)') 
%     xlabel('Y Position(cm)') 
%     legend('Low Carrier '+string(data.MetalName(numel(subsetsRot)/2+1)), 'Low Carrier '+string(data.MetalName(numel(subsetsRot)/2+2)))
% 
% %     % Save the translation error plot
% %     saveas(gcf, savePath1, 'fig');


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
    title("Solid Metals Low Carrier Effects Translation Error on x = 20 and Rotate "+string(deg)+" Degree")
 
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
    title("Solid Metals Low Carrier Effects Rotation Error on x = 20 and Rotate "+string(deg)+" Degree")
    ylabel('Rotation Error(rad)') 
    xlabel('Y Position(cm)') 
%     legend('Low Carrier '+string(data.MetalName(numel(subsetsRot)/2+1)), 'Low Carrier '+string(data.MetalName(numel(subsetsRot)/2+2)))
    legend(name)  

%% Couplings different plot for HIGH carrier
    figure;
    for j = solid
        semilogy(x0, disArray((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Sheet Metals High Carrier Effects Coupling Magnitude on x = 20 and Rotate "+string(deg)+" Degree")
    ylabel('Coupling Magnitude') 
    xlabel('X Position(cm)') 
    legend(name)
    
    figure;
    for j = solid
        semilogy(x0, disArrayLow((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Sheet Metals Low Carrier Effects Coupling Magnitude on x = 20 and Rotate "+string(deg)+" Degree")
    ylabel('Coupling Magnitude') 
    xlabel('X Position(cm)') 
    legend(name)    

end