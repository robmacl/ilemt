function plot_directory(fileDirectory, input_plot)
% Overall process layouts through extracting data from file to high and low 
% carriers, processing to translational and rotational components, further 
% processing the essential parameters like axis for plotting and ploting.
% 
% Input arguments:
% fileDirectory:
%     The cell of output file directory.
% 
% input_plot:
%     Four essential sub-variables for specific plot that matches directory.

    % For ilemt system, it has both high and low carriers
    if input_plot{1}=="ilemt"
        % Extract data from file to high and low carriers, do the validity 
        % check and print out the summary statistitcs 
        [result_all.High, data] = ExtractData(fileDirectory, true);
        [result_all.Low, data] = ExtractData(fileDirectory, false);

        % Process high carrier data to translation and rotation components
        result_all.High = dataProcess(result_all.High);
        % Process low carrier data to translation and rotation components
        result_all.Low = dataProcess(result_all.Low);

    % For 3DGuidance system, we will collect the record in high carrier parameter. 
    % The data in low carrier variable is just for preventing error
    elseif input_plot{1}== "Guidance"      
        [result_all.High, data] = ExtractData_t2pose(fileDirectory);
        result_all.High = dataProcess(result_all.High);
        result_all.Low = result_all.High;
    end
        
    % Process all parameters for plotting
    [input_param] = input_params(fileDirectory, data, input_plot);

    % Main plotting function
    plot_graph(result_all, data, input_param);
end