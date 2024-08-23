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

    % Extract data from file to high and low carriers, do the validity check and print out the summary statistitcs 
    [result_all.High, data] = ExtractData(fileDirectory, true);
    [result_all.Low, data] = ExtractData(fileDirectory, false);
    
    % Process high carrier data to translation and rotation components
    result_all.High = dataProcess(result_all.High);
    % Process low carrier data to translation and rotation components
    result_all.Low = dataProcess(result_all.Low);

    % Process all parameters for plotting
    [input_param] = input_params(fileDirectory, data, input_plot);
    
    % Main plotting function
    plot_graph(result_all, data, input_param);
end

