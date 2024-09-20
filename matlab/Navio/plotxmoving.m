%% Plot x-moving Function for Hollow and Solid metal
function plotxmoving(result_all, data, input_param)
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
        subset.Low.rot = result_all.Low.rotResult(start_idx:end_idx);
        
        subset_High_trans{i} = subset.High.trans';
        subset_High_rot{i} = subset.High.rot';
        subset_Low_trans{i} = subset.Low.trans';
        subset_Low_rot{i} = subset.Low.rot';
    end
    
    % Assign index in the array of double if the control sample will be presented    
    idx.test = 1:numel(subsets);
    idx.name = (data.NavioParts(1:numel(subsets)));
    idx.orien = (data.Orientation(1:numel(subsets)));
    
    idx.label = {};
    idx.label = {idx.name+" "+string(idx.orien)+" degrees"};
    
    %% Create the x-moving plot    
    carrier_choice = {'High', 'Low'};
    data_xmoving = {subset_High_trans,subset_Low_trans,subset_High_rot,subset_Low_rot};
   
    % Loop for doing all plots
    for j = 1:2
        % Identify carrier types
        idx.carrier = carrier_choice{j};

        xmoving_errorPlot(idx, data_xmoving{j}, data_xmoving{j+2}, input_param)
        xmoving_coupling(idx, result_all.(idx.carrier).coupling, step, input_param)
    end
end

%% Sub-function for translation and rotational error 
function xmoving_errorPlot(idx, data_trans, data_rot, input_param)
% Input arguments:
% idx:
%   Struct of related index as listed:
%     - idx.shape: metal shape of that plot in character format including Hollow and Solid 
%     - idx.carrier: carrier type of that plot in character format including High and Low
%     - idx.(idx.shape): the sub-struct of double array indicating all file index of that 
%                        sample
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
    limit.x_trans = 'auto';
    limit.y_trans = 'auto';
    limit.x_rot = 'auto';
    limit.y_rot = 'auto';         
    
    lim_axis = {limit.x_trans, limit.x_rot, limit.y_trans limit.y_rot};
    errorType = {'Translation','Rotation'};
    
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
        subplot(2,1,i)
        for j = idx.test
            semilogy(input_param.x_axis, data{j}, '.-', 'MarkerSize', 8)
            hold on
        end
        grid on
        title("Navio Handpiece Test " +string(idx.carrier)+" Carrier Effects "+string(errorType{i})+" Error on y = "+string(input_param.y_axis(1)))
        ylabel(string(errorType{i})+' Error(m)') 
        xlabel('X Position(cm)') 
        legend(idx.label{1})
        xlim(x_lim);
        ylim(y_lim);
    end

    savefig(fullfile(input_param.directory, "TransRotError_"+"_"+string(idx.carrier)+".fig"))
end

%% Sub-function for coupling magnitude plot
function xmoving_coupling(idx, data, step, input_param)
% Input arguments:
% idx:
%   Struct of related index as listed:
%     - idx.shape: metal shape of that plot in character format including Hollow and Solid 
%     - idx.carrier: carrier type of that plot in character format including High and Low
%     - idx.(idx.shape): the sub-struct of double array indicating all file index of that 
%                        sample
%     - idx.name: cell array of metal type of sample
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
    limit.y = 'auto';  

    figure;
    for j = idx.test
        semilogy(input_param.x_axis, data((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
        hold on
    end
    grid on
    title("Navio Handpiece Test " +string(idx.carrier)+" Carrier Effects Coupling Magnitude on y = "+string(input_param.y_axis(1)))
    ylabel('Normalized Coupling Magnitude') 
    xlabel('X Position(cm)') 
    legend(idx.label{1})
    xlim(limit.x);
    ylim(limit.y);
        
    savefig(fullfile(input_param.directory, "Coupling_"+string(idx.carrier)+".fig"))    
end