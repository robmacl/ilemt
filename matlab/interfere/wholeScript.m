clear all
close all
clc

% import the file directory needed to analyze
% fileDirectory = 'D:\ilemt_cal_data\output_files\May_x5y0'
% fileDirectory = 'D:\ilemt_cal_data\output_files\May Y=0'
fileDirectory = pwd
% fileDirectory = 'D:\ilemt_cal_data\output_files\May Test'
% fileDirectory = 'D:\ilemt_cal_data\output_files\May sheet'
%fileDirectory = 'D:\ilemt_cal_data\output_files\May_x15y0'

disp('Choice to do:')
disp('1.High and Low carrier comparison')
disp('2.Vary x position')
disp('3.Vary y position')
disp('4.Sheet metal')
choice = input('Choose the prefer choice: ');
switch choice
    case 1
        [resultArray, data, resultArrayLow, transResult, rotResult, transResultLow, rotResultLow] = valid(fileDirectory);
        % plot
        plotx5y0(transResult, rotResult, transResultLow, rotResultLow);
        
    case 2
        deg = input('Any orientation?(0 or 90): ');
        if deg == 0 || deg == 90
            [resultArray, data, resultArrayLow, transResult, rotResult, transResultLow, rotResultLow] = valid(fileDirectory);
            axis_moving = dlmread(fileDirectory+"\"+string(data.FileName(1)));
            axis = axis_moving(2:end-1,1);
        % plot
            plotxmoving(transResult, rotResult,transResultLow, rotResultLow, data, deg, axis);
        else
            disp('Error in orientation input')
        end
        
    case 3
        deg = input('Any orientation?(0 or 90): ');
        if deg == 0 || deg == 90
            [resultArray, data, resultArrayLow, transResult, rotResult, transResultLow, rotResultLow] = valid(fileDirectory);
            axis_moving = dlmread(fileDirectory+"\"+string(data.FileName(1)));
            axis = axis_moving(2:end-1,2);
        % plot
            plotymoving(transResult, rotResult,transResultLow, rotResultLow, data, deg, axis);
        else
            disp('Error in orientation input')
        end
        
    case 4
        deg = input('Any orientation?(0 or 90): ');
        if deg == 0 || deg == 90
            [resultArray, data, resultArrayLow, transResult, rotResult, transResultLow, rotResultLow] = valid(fileDirectory);
            axis_moving = dlmread(fileDirectory+"\"+string(data.FileName(1)));
            axis = axis_moving(2:end-1,1);
        % plot
            plotsheet(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis);
        else
            disp('Error in orientation input')
        end
        
    otherwise
        disp('Sorry, there is no choice you chose')
end

%% Function
function [resultArray, data, resultArrayLow, transResult, rotResult, transResultLow, rotResultLow] = valid(fileDirectory)
    % do the validity check and print out the summary statistitcs 
%     [resultArray, resultArrayLow, data] = ExtractData(fileDirectory);
    [resultArray, data] = ExtractData(fileDirectory, true);
    [resultArrayLow, data] = ExtractData(fileDirectory, false);
    % Run the data process
    [transResult, rotResult] = dataProcess(resultArray, data);
    % Run the data process of low carrier data on x5y0
    [transResultLow, rotResultLow] = dataProcess(resultArrayLow, data);
end
