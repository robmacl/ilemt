%% Plot x-moving Function for Sheet metal
function plotsheet(result_all, data, input_param)
    %% Parameter preparation and data extraction
    step = numel(result_all.High.transResult) / size(data, 1);
    
    % Initialize an array of cells to store the split subset
    num_subsets = floor(length(result_all.High.transResult) / step);
    subsets = cell(1, num_subsets);
    
    % Split data and convert to row vectors using for loops
    for i = 1:num_subsets
        start_idx = (i - 1) * step + 1;
        end_idx = i * step;
        
        subset.High.trans = result_all.High.transResult(start_idx:end_idx);
        subset.High.rot = result_all.High.rotResult(start_idx:end_idx);
        subset.Low.trans = result_all.Low.transResult(start_idx:end_idx);
        subset.Low.rot =  result_all.Low.rotResult(start_idx:end_idx);
        
        subset_High_trans{i} = subset.High.trans';
        subset_High_rot{i} = subset.High.rot';
        subset_Low_trans{i} = subset.Low.trans';
        subset_Low_rot{i} = subset.Low.rot';
    end

    % Assign index in the array of double if the control sample will be presented
    if input_param.skip_control == "no_skip"
        idx.Sheet = 1:numel(subsets);
        idx.name = data.MetalName((1:numel(subsets)));
    else
        idx.Sheet = 2:numel(subsets);
        idx.name = data.MetalName((2:numel(subsets)));
    end
    
    %% Create the x-moving plot 
    % parameter for ilemt system    
    carrier_choice.ilemt = {'High', 'Low'};
    data_sheet.ilemt = {subset_High_trans,subset_Low_trans, subset_High_rot,subset_Low_rot};
    % parameter for 3D Guidance system    
    carrier_choice.Guidance = {'High'};
    data_sheet.Guidance = {subset_High_trans, subset_High_rot};      
    
    
    % Loop for doing all plots    
    for i = 1:size(carrier_choice.(input_param.sensor),2)
        % Identify carrier types
        idx.carrier = carrier_choice.(input_param.sensor){i};
        
        if input_param.sensor == 'ilemt'
            sheet_errorPlot(idx, data_sheet.(input_param.sensor){i}, data_sheet.(input_param.sensor){i+2}, input_param)
            sheet_coupling(idx, result_all.(carrier_choice.(input_param.sensor){i}).coupling, step, input_param)
        else
            sheet_errorPlot(idx, data_sheet.(input_param.sensor){i}, data_sheet.(input_param.sensor){i+1}, input_param)
        end
        
        
    end     
    
end

%% Sub-function for translation and rotational error 
function sheet_errorPlot(idx, data_trans, data_rot, input_param)
% Input arguments:
% idx:
%   Struct of related index as listed:
%     - idx.carrier: carrier type of that plot in character format including High and Low
%     - idx.Sheet: the sub-struct of double array indicating all file index
%     - idx.name: cell array of metal shape and type of sample
% 
% data_trans:
%   Cell array of the translational data in double vector format for each file/cell.  
% 
% data_rot:
%   Cell array of the rotational data in double vector format for each file/cell.
% 
% input_param:
%     The struct of essential parameters. See input_params.m for more information

    % Assign the axis limit
    if input_param.deg == 0
        limit.x_trans = 'auto';
        limit.y_trans = 'auto';
        limit.x_rot = 'auto';
        limit.y_rot = 'auto';    
    else
        limit.x_trans = 'auto';
        limit.y_trans = 'auto';
        limit.x_rot = 'auto';
        limit.y_rot = 'auto';         
    end
    
    lim_axis = {limit.x_trans, limit.x_rot, limit.y_trans limit.y_rot};
    error_unit = {'Translation','Rotation','m','rad'};  

    figure;
    % Loop for plotting translational and rotational errors
    for i = 1:2
        x_lim = lim_axis{i};
        y_lim = lim_axis{i+2};
        
        if i == 1 
            data = data_trans;
        else
            data = data_rot;
        end
        
        % Assign title name ame file name for each ilemt and 3D Guidance systems separately
        if input_param.sensor == "ilemt"
            title_detail = "Four Sheet Metals "+string(idx.carrier)+" Carrier Effects "+string(error_unit{i})+" Error on X=["+string(input_param.x_axis(1))+"..."+string(input_param.x_axis(end))+"] and Rotate "+string(input_param.deg)+" Degree";
            name_file = "TransRotError_sheet_"+string(idx.carrier)+".fig";
        else
            title_detail = "Four Sheet Metals of 3DGuidance trakSTAR with "+string(error_unit{i})+" Error on X=["+string(input_param.x_axis(1))+"..."+string(input_param.x_axis(end))+"] and Rotate "+string(input_param.deg)+" Degree";
            name_file = "TransRotError_sheet.fig";
        end
 
        subplot(2,1,i)  
        for j = idx.Sheet
            semilogy(input_param.x_axis, data{j}, '.-', 'MarkerSize', 8)
            hold on
        end

        grid on
        title(title_detail)
        ylabel(string(error_unit{i})+' Error ('+error_unit{i+2}+')') 
        xlabel('X Position(cm)') 
        legend(idx.name)
        xlim(x_lim);
        ylim(y_lim);
    end
    
    savefig(fullfile(input_param.directory, name_file))
end

%% Sub-function for coupling magnitude plot
function sheet_coupling(idx, data, step, input_param)
% Input arguments:
% idx:
%   Struct of related index as listed:
%     - idx.carrier: carrier type of that plot in character format including High and Low
%     - idx.Sheet: the sub-struct of double array indicating all file index
%     - idx.name: cell array of metal shape and type of sample
% 
% data:
%   Double array of coupling magnitude of all output files
% 
% step:
%   Double indicating the amount of point data in each output file
% 
% input_param:
%   The struct of essential parameters. See input_params.m for more information

    limit.x = 'auto';         
    limit.y = [1e-5 2e-1];  

    figure;
    for j = idx.Sheet
        semilogy(input_param.x_axis, data((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("All Sheet Metals "+string(idx.carrier)+" Carrier Effects Coupling Magnitude on X=["+string(input_param.x_axis(1))+"..."+string(input_param.x_axis(end))+"] and Rotate "+string(input_param.deg)+" Degree")
    ylabel('Normalized Coupling Magnitude') 
    xlabel('X Position(cm)') 
    legend(idx.name)
    xlim(limit.x);
    ylim(limit.y);

    savefig(fullfile(input_param.directory, "Coupling_Sheet_"+string(idx.carrier)+".fig"))
end