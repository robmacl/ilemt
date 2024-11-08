function  [input_param] = input_params(fileDirectory, data, input_plot)
% Retuen all necessary input parameters. Additional parameters especially the 
% axis from output file of the test are also added.
% 
% Input arguments:
% fileDiectory:
%     Cell of directory name.
% 
% data:
%     Table with sub-cell array of FileName, MetalShape and MetalName of the 
%     matched directory.
% 
% input_plot:
%     Cell array of input variables (plot_type, degree_orientaion,
%     control_skip, custom_plot).
% 
% Return values:
% input_params:
%     Struct of input parameters including:
%     - input_param.type: type of plot 
%     - input_param.deg: orientation of sample
%     - input_param.skip_control: identification of skip control 
%     - input_param.custom: identification of custom plot
%     - input_param.directory: output file directoty
%     - input_param.position: specific position of each metal shapes for comparing 
%                             in high-low carriers comparison plots with sub-struct 
%                             of hollow, solid, and sheet in double
%     - input_param.axis: double array of x positions for high-low comparison
%                         plots with sub-struct of hollow, solid, and sheet 
%     - input_param.x_axis: double array of x positions 
%     - input_param.y_axis: double array of y positions

    % Input parameter from the original input of main_metal_interfere.m 
    input_param.sensor = input_plot{1};
    input_param.type = input_plot{2};
    input_param.deg = input_plot{3};
    input_param.skip_control = input_plot{4};
    input_param.custom = input_plot{5};   
    input_param.directory = fileDirectory;
    
    % High-Low carriers plot requires the additional parameters of specific
    % position and axis varying
    if input_param.type == 'HighLow'
        MetalType = {"hollow", "solid", "sheet"};
        % Get double array of varying x positions of each metal types
        for i = 1:numel(MetalType)
            file_order = find(string(data.MetalShape) == MetalType{i});
            data_all1.(MetalType{i}) = dlmread(fileDirectory+"\"+string(data.FileName(file_order(1))));
            input_param.axis.(MetalType{i}) = data_all1.(MetalType{i})(2:end-1,1);
        end
        % Assign specific position of each metal for comparison
        if input_param.custom == false
            input_param.position.hollow = data_all1.hollow(2,1);
            input_param.position.solid = data_all1.solid(2,1);
            input_param.position.sheet = data_all1.sheet(2,1);
        else
            input_param.position.hollow =15;
            input_param.position.solid = input_param.position.hollow;
            input_param.position.sheet =24;
            % Error warning if the assign position does not match the
            % varying position
            if isempty(find(input_param.axis.hollow == input_param.position.hollow, 1)) || isempty(find(input_param.axis.solid == input_param.position.solid ,1)) || isempty(find(input_param.axis.sheet == input_param.position.sheet,1))
                disp('Please check on desire position of each metal type')
            end
        end
    
    else
        % Process x and y positions from output file for other plot types
        data_all2 = dlmread(fileDirectory + "\" + string(data.FileName(1)));
        input_param.x_axis = data_all2(2:end-1,1);
        input_param.y_axis = data_all2(2:end-1,2);
    end
end
