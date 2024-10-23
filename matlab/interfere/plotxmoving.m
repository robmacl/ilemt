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
    if input_param.skip_control == "no_skip"
        idx.Hollow = 1:numel(subsets)/2;
        idx.Solid = numel(subsets)/2 + 1:numel(subsets);
        idx.name = (data.MetalName(1:numel(subsets)/2));
    else
        idx.Hollow = 2:numel(subsets)/2;
        idx.Solid = numel(subsets)/2 + 2:numel(subsets);
        idx.name = (data.MetalName(2:numel(subsets)/2));
    end
    
    %% Create the x-moving plot  
    shape_choice = {'Hollow', 'Solid'};       
    carrier_choice.ilemt = {'High', 'Low'};
    data_xmoving.ilemt = {subset_High_trans,subset_Low_trans,subset_High_rot,subset_Low_rot};    
    carrier_choice.Guidance = {'High'};  
    data_xmoving.Guidance = {subset_High_trans,subset_High_rot};

    for j = 1:size(carrier_choice.(input_param.sensor),2)
         for i = 1:size(shape_choice,2)
             % Identify shape and carrier types
             idx.shape = shape_choice{i};
             idx.carrier = carrier_choice.(input_param.sensor){j};

             if input_param.sensor == "ilemt"    
                 xmoving_errorPlot(idx, data_xmoving.(input_param.sensor){j}, data_xmoving.(input_param.sensor){j+2}, input_param)
                 xmoving_coupling(idx, result_all.(idx.carrier).coupling, step, input_param)
             else
                 xmoving_errorPlot(idx, data_xmoving.(input_param.sensor){j}, data_xmoving.(input_param.sensor){j+1}, input_param)
             end
         end
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
    if input_param.deg == 0 && input_param.sensor == "ilemt"
        limit.x_trans = [0 50];
        limit.y_trans = [1e-6 2e-2];
        limit.x_rot = [0 50];
        limit.y_rot = [1e-5 2e-1];    
    else
        limit.x_trans = 'auto';
        limit.y_trans = 'auto';
        limit.x_rot = 'auto';
        limit.y_rot = 'auto';    
    end
    
    lim_axis = {limit.x_trans, limit.x_rot, limit.y_trans limit.y_rot};
    errorType = {'Translation','Rotation'};
    
    figure;
    % Loop for plotting translational and rotational errors
    for i = 1:2
        if input_param.sensor == "ilemt"
            title_detail = "All " +string(idx.shape)+ " Metals "+string(idx.carrier)+" Carrier Effects "+string(errorType{i})+" Error on y = "+string(input_param.y_axis(1))+" and Rotate "+string(input_param.deg)+" Degree";
            name_file = "TransRotError_"+string(idx.shape)+"_"+string(idx.carrier)+".fig";
        else
            title_detail = "All " +string(idx.shape)+ " Metals of 3DGuidance trakSTAR with "+string(errorType{i})+" Error on y = "+string(input_param.y_axis(1))+" and Rotate "+string(input_param.deg)+" Degree";
            name_file = "TransRotError_"+string(idx.shape)+".fig";
        end
        
        x_lim = lim_axis{i};
        y_lim = lim_axis{i+2}; 
        
        if i == 1 
            data = data_trans;
        else
            data = data_rot;
        end
        subplot(2,1,i)
        for j = idx.(idx.shape)
%             data{j}
            if input_param.sensor == 'ilemt'
                semilogy(input_param.x_axis, data{j}, '.-', 'MarkerSize', 8)
            else
                semilogy(input_param.x_axis, data{j}, '.-', 'MarkerSize', 8)
            end
            hold on
        end
        grid on
        
        title(title_detail)
        ylabel(string(errorType{i})+' Error(m)') 
        xlabel('X Position(cm)') 
        legend(idx.name)
        xlim(x_lim);
        ylim(y_lim);
    end

    savefig(fullfile(input_param.directory, name_file))
%     savefig(fullfile(input_param.directory, "TransRotError_"+string(idx.shape)+"_"+string(idx.carrier)+".fig"))
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
    limit.y = [1e-5 2e-1];  

    figure;
    for j = idx.(idx.shape)
        if input_param.sensor == 'ilemt'
            semilogy(input_param.x_axis, data((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
        else
            plot(input_param.x_axis, data((j-1)*step+1:j*step), '.-', 'MarkerSize', 8)
        end
        hold on
    end
    grid on
    title("All "+string(idx.shape)+" Metals "+string(idx.carrier)+" Carrier Effects Coupling Magnitude on y = "+string(input_param.y_axis(1))+" and Rotate "+string(input_param.deg)+" Degree")
    ylabel('Normalized Coupling Magnitude') 
    xlabel('X Position(cm)') 
    legend(idx.name)
    xlim(limit.x);
    ylim(limit.y);
        
    savefig(fullfile(input_param.directory, "Coupling_"+string(idx.shape)+"_"+string(idx.carrier)+".fig"))    
end