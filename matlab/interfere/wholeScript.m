clear all
close all
clc

fileDirectory = pwd


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
            skip_control = input('Would you like to include the control test in the plot?(Yes=1 or No=0):');
            if skip_control == 1 || skip_control == 0
                [resultArray, data, resultArrayLow, transResult, rotResult, transResultLow, rotResultLow, disArray, disArrayLow] = valid(fileDirectory);
                axis_moving = dlmread(fileDirectory+"\"+string(data.FileName(1)));
                axis = axis_moving(2:end-1,1);
                % plot
                plotxmoving(transResult, rotResult,transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control);
            else
                disp('Error in assigned control test in plot')
            end

        else
            disp('Error in orientation input')
        end

        
    case 3
        deg = input('Any orientation?(0 or 90): ');
        if deg == 0 || deg == 90
            skip_control = input('Would you like to include the control test in the plot?(Yes=1 or No=0):');
            if skip_control == 1 || skip_control == 0
                [resultArray, data, resultArrayLow, transResult, rotResult, transResultLow, rotResultLow, disArray, disArrayLow] = valid(fileDirectory);
                axis_moving = dlmread(fileDirectory+"\"+string(data.FileName(1)));
                axis = axis_moving(2:end-1,2);
                % plot
                plotymoving(transResult, rotResult,transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control);
            else
                disp('Error on assigned control test in plot')
            end
        else
            disp('Error in orientation input')
        end
        
    case 4
        deg = input('Any orientation?(0 or 90): ');
        if deg == 0 || deg == 90
            skip_control = input('Would you like to include the control test in the plot?(Yes=1 or No=0):');
            if skip_control == 1 || skip_control == 0
                [resultArray, data, resultArrayLow, transResult, rotResult, transResultLow, rotResultLow, disArray, disArrayLow] = valid(fileDirectory);
                axis_moving = dlmread(fileDirectory+"\"+string(data.FileName(1)));
                axis = axis_moving(2:end-1,1);
                % plot
                plotsheet(transResult, rotResult, transResultLow, rotResultLow, data, deg, axis, disArray, disArrayLow, skip_control);
            else
                disp('Error in assigned control test in plot')
            end
        else
            disp('Error in orientation input')
        end
        
    otherwise
        disp('Sorry, there is no choice you chose')
end

%% Function
function [resultArray, data, resultArrayLow, transResult, rotResult, transResultLow, rotResultLow, disArray, disArrayLow] = valid(fileDirectory)
    % do the validity check and print out the summary statistitcs 
%     [resultArray, resultArrayLow, data] = ExtractData(fileDirectory);
    [resultArray, data, disArray] = ExtractData(fileDirectory, true);
    [resultArrayLow, data, disArrayLow] = ExtractData(fileDirectory, false);
    % Run the data process
    [transResult, rotResult] = dataProcess(resultArray, data);
    % Run the data process of low carrier data on x5y0
    [transResultLow, rotResultLow] = dataProcess(resultArrayLow, data);
end
