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
%     The plot_type is for identify the type of plot (including HighLow, xmoving, 
%     ymoving, Sheet) in string. HighLow is for comparison of high carrier and low carrier
%     in both translational and rotatiional errors. The xmoving and ymoving is 
%     for ploting the translation error, rotational error, and coupling magnitude
%     of hollow and solid metals when varying x and y position. Similary to 
%     xmoving, Sheet is the same plot as xmoving, but it is for sheet metal.
%     
%     degree_orientation is for assigning the orientation of sample in 
%     metal interfere experiment in degree. The value is in double.
%     
%     control_skip can be inputted as string of "skip" for skipping the 
%     first output file of control while "no_skip" is for including the control.
% 
%     custom_plot is for the plotting the high-low carrier comparison plot 
%     with the output files of xmoving and sheet. The input is logical, true 
%     for custom plot and false for the others.
    
% all_directory = {
%     'D:\ilemt_interfere_data\output_file\June HighLow',... 
%     'D:\ilemt_interfere_data\output_file\July HighLow custom',...
%     'D:\ilemt_interfere_data\output_file\June Y=0',...
%     'D:\ilemt_interfere_data\output_file\June Y=0 90 degree',...
%     'D:\ilemt_interfere_data\output_file\July X=20',...
%     'D:\ilemt_interfere_data\output_file\June sheet',...
%     'D:\ilemt_interfere_data\output_file\June sheet 90 degree',...
%     'D:\ilemt_interfere_data\output_file\October Y=0',...
%     'D:\ilemt_interfere_data\output_file\October sheet'};
% 
% input_plot = {{"ilemt", "HighLow", 0, "skip", false},...
%     {"ilemt", "HighLow", 0, "skip", true},...
%     {"ilemt", "xmoving", 0, "skip", false},...
%     {"ilemt", "xmoving", 90, "skip", false},...
%     {"ilemt", "ymoving", 0, "skip", false},...
%     {"ilemt", "Sheet", 0 , "skip", false},...
%     {"ilemt", "Sheet", 90, "skip", false},...
%     {"Guidance", "xmoving", 0, "skip", false},...
%     {"Guidance", "Sheet", 0, "skip", false}};

all_directory = {
    'D:\ilemt_interfere_data\output_file\June Y=0',...
    'D:\ilemt_interfere_data\output_file\June sheet',...    
    'D:\ilemt_interfere_data\output_file\October Y=0',...
    'D:\ilemt_interfere_data\output_file\October sheet',...
    'D:\ilemt_interfere_data\output_file\October sheet 90 degree'};

input_plot = {
    {"ilemt", "xmoving", 0, "skip", false},...
    {"ilemt", "Sheet", 0 , "skip", false},...    
    {"Guidance", "xmoving", 0, "skip", false},...
    {"Guidance", "Sheet", 0, "skip", false},...
    {"Guidance", "Sheet", 90, "skip", false}};


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
    


