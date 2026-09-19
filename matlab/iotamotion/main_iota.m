clear all
close all
clc

% all_directory:
%     Cell array of output_file directories of each plot.
% 
% input_plot:
%     Cell array of four input parameters. Each parameters in one cell are for 
%     processing at that specific order of diectory which is arranged as:
% 
%         {plot_type, degree_orientaion, control_skip, custom_plot}
%     
%     The plot_type is for identify the type of plot (including xmoving, 
%     ymoving) in string.
    
all_directory = {'D:\ilemt_interfere_data\output_file\Dec iota Y=0',...
    'D:\ilemt_interfere_data\output_file\Dec iota X=10',...
    'D:\ilemt_interfere_data\output_file\Dec iota on Y=0',...
    'D:\ilemt_interfere_data\output_file\Jan iota on X=10'};

input_plot = {{"xmoving"},...
    {"ymoving"},...
    {"xmoving"},...
    {"ymoving"}};

% Check on the consistance in amount of directory and input parameter
if numel(all_directory) == numel(input_plot)
    % Loop for passing parameters to the processing and plotting
    i = 1;
    for fileDirectory = all_directory
        plot_directory(string(fileDirectory),input_plot{i})
        i=i+1;
    end    
else
    disp("The number of directories are not in the same amount as input variables")
end
    


