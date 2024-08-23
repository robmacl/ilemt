function plotHighLow(result_all, data, input_param)
    % Create cell array of metal name, error type, and metal shape
    name = {'High = Low', 'Hollow LC Steel', 'Hollow 416 SS', 'Hollow 304 SS', 'Hollow 6061 Al', 'Hollow Ti Gr 5', 'Hollow Copper', ...
        'Sheet LC Steel', 'Sheet 304 SS', 'Sheet 6061 Al', 'Sheet Copper', ...
         'Solid LC Steel', 'Solid 416 SS', 'Solid 304 SS', 'Solid 6061 Al', 'Solid Ti Gr 5', 'Solid Copper'};
    errorType = {'Translation','Rotational'};
    shape_choice = {'hollow', 'solid', 'sheet'};
    
    %% Rearrangment the data to match the order of name
    % Create empty struct with sub metal types
    transResult_High = struct('hollow', [], 'solid', [], 'sheet', []);
    transResult_Low = struct('hollow', [], 'solid', [], 'sheet', []);
    rotResult_High = struct('hollow', [], 'solid', [], 'sheet', []);
    rotResult_Low = struct('hollow', [], 'solid', [], 'sheet', []);
    
    % Loop for storing the translation and rotation errors separately for
    % each metal types
    i = 1;
    idx_start = 1;
    while i <= size(data,1)
        metal_shape = string(data.MetalShape(i));
        if ismember(metal_shape, shape_choice)
            % Find the row of demanded position in data
            step = find(input_param.axis.(metal_shape) == input_param.position.(metal_shape));
            % Add the data at that position to the seprated array of metal type
            transResult_High.(metal_shape) = [transResult_High.(metal_shape); result_all.High.transResult(idx_start + step - 1)];
            transResult_Low.(metal_shape) = [transResult_Low.(metal_shape); result_all.Low.transResult(idx_start + step - 1)];
            rotResult_High.(metal_shape) = [rotResult_High.(metal_shape); result_all.High.rotResult(idx_start + step - 1)];
            rotResult_Low.(metal_shape) = [rotResult_Low.(metal_shape); result_all.Low.rotResult(idx_start + step - 1)];
            idx_start = idx_start + result_all.High.num_data(i) - 2;
        end
        i = i + 1;
    end
            
    % Arrange the result in the demanded order (hollow-sheet-solid)
    Rearrange.transResult.High = cat(1,transResult_High.hollow,transResult_High.sheet,transResult_High.solid);
    Rearrange.rotResult.High = cat(1,rotResult_High.hollow,rotResult_High.sheet,rotResult_High.solid);
    Rearrange.transResult.Low = cat(1,transResult_Low.hollow,transResult_Low.sheet,transResult_Low.solid);
    Rearrange.rotResult.Low = cat(1,rotResult_Low.hollow,rotResult_Low.sheet,rotResult_Low.solid);
    
    %% Create High-Low carriers comparison plot
    figure;
    % Translational Error plot
    subplot(1,2,1)
    HighLowPlotMethod(Rearrange.transResult, errorType{1}, input_param.position, name) 
    % Rotational Error plot
    subplot(1,2,2)
    HighLowPlotMethod(Rearrange.rotResult, errorType{2}, input_param.position, name) 

    % Save figure
    if input_param.custom
        savefig(fullfile(input_param.directory, 'custom_HighLow.fig'))
    else
        savefig(fullfile(input_param.directory, 'general_HighLow.fig'))
    end
    
    %% Write table for process error ratio conclusion  
    % Create emty tables for translational and rotational data
    HLtrans = table();
    HLrot = table();
    
    % Calculate the ratio of each errors
    ratio_trans = Rearrange.transResult.Low./Rearrange.transResult.High; 
    ratio_rot = Rearrange.rotResult.Low./Rearrange.rotResult.High;
    
    % Loop for combining
    for i = 1:numel(Rearrange.transResult.High)
        % Add new information to the stored parameter
        HLtrans_new = {name(i+1), Rearrange.transResult.High(i), Rearrange.transResult.Low(i), ratio_trans(i)};
        HLrot_new = {name(i+1), Rearrange.rotResult.High(i), Rearrange.rotResult.Low(i), ratio_rot(i)};

        HLtrans = [HLtrans; HLtrans_new];
        HLrot = [HLrot; HLrot_new];
    end
    
    % Add column name to table
    HLtrans.Properties.VariableNames = {'MetalShape', 'High_Carrier', 'Low_Carrier','LowHigh_Ratio'};
    HLrot.Properties.VariableNames = {'MetalShape', 'High_Carrier', 'Low_Carrier','LowHigh_Ratio'};
    
    % Write error ratio (Low carrier/High carrier)
    savefilename = 'transResult_Ratio.xlsx';
    fprintf('\nTranslational Table has been written to Excel successfully.\n')
    writetable(HLtrans, savefilename);

    savefilename = 'rotResult_Ratio.xlsx';
    fprintf('Rotational Table has been written to Excel successfully.\n')
    writetable(HLrot, savefilename);            
end 

%% Sub-function for the scatter plot
function HighLowPlotMethod(data, errorType, position, name)
% Input arguments:
% data:
%     The struct in double array format. This argument would have the sub-struct 
%     for high carrier and low carrier data, and should be rearranged.
% 
% errorType:
%     Character format of error type identification.
% 
% position:
%     Struct of double identifying the demanded position of each metal
%     types as the sub-struct.
% 
% name:
%     Cell array of the metal shape and name in the matched order.

    x = data.High;
    y = x;
    loglog(x, y);
    axis equal;
    S = 100;
    hold on 
    
    scatter(data.High(1), data.Low(1), S, 'red', 'filled')
    scatter(data.High(2), data.Low(2), S, 'green', 'filled')
    scatter(data.High(3), data.Low(3), S, 'magenta', 'filled')
    scatter(data.High(4), data.Low(4), S, 'b', 'filled')
    scatter(data.High(5), data.Low(5), S, 'black', 'filled')
    scatter(data.High(6), data.Low(6), S, 'cyan', 'filled')
    scatter(data.High(7), data.Low(7), S, 'red^')
    scatter(data.High(8), data.Low(8), S, 'magenta^')
    scatter(data.High(9), data.Low(9), S, 'b^')
    scatter(data.High(10), data.Low(10), S, 'cyan^')
    scatter(data.High(11), data.Low(11), S, 'r*')
    scatter(data.High(12), data.Low(12), S, 'g*')
    scatter(data.High(13), data.Low(13), S, 'm*')
    scatter(data.High(14), data.Low(14), S, 'b*')
    scatter(data.High(15), data.Low(15), S, 'black*')
    scatter(data.High(16), data.Low(16), S, 'cyan*') 
    
    daspect([1 1 1])
    hold off

    xlabel("High Carrier Effects (log scale)")
    ylabel("Low Carrier Effects (log scale)")
    title({['12 Metals High Carrier versus Low Carrier ' errorType ' Error Comparison on'],['(' num2str(position.hollow) ',0) for Hollow and Solid Metals, (' num2str(position.sheet) ',0) for Sheet Metal']})
    legend(name ,'Location','northwest')
end