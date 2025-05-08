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
%         {sensor_type, plot_type, degree_orientaion, control_skip, custom_plot}
%   
%     sensor_type is the the parameter identifying the system/sensor for tracking. 
%     The input is in string, and in this case, there are ilemt and 3DGuidance 
%     trakstar as "ilemt" and "Guidance", respectively.
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
%     

all_directory = {
    'D:\ilemt_interfere_data\output_file\Nov_test'};

[result_all, input] = file_separate(all_directory);
result_all = dataprocess(result_all);
plot_sanity(input, result_all,all_directory)

% result_all.transResult
% result_all.rotResult
% input_plot = {
%     {"Guidance", "Sheet", 0, "no_skip", false}};

% Check on the consistance in amount of directory and input parameter
% if numel(all_directory) == numel(input_plot)
%     % Loop for passing parameters to the processing and plotting
%     i = 1;
% %     for fileDirectory = all_directory
% %         plot_directory(string(fileDirectory),input_plot{i})
% %         i=i+1;
% %     end  
% 
% else
%     disp("The number of directories are not in the same amount as input variables")
% end
%%
function  [result_all, input] = file_separate(fileDirectory)
    files = dir(fullfile(string(fileDirectory), '*.dat'));
    pattern = '(ilemt|Guidance)_(translation|rotation)';
    
    result_all = struct('resultArray', [], 'num_data', []); 
    resultArray = [];
    num_data = [];    
    input = struct('sensor_type',[], 'error_type',[]); 
    k=1;
    for i = 1:numel(files)
        fileName = files(i).name;
        
        % Use regular expressions to match
        tokens = regexp(fileName, pattern, 'tokens');
        
        if ~isempty(tokens)
            
            if (tokens{1}{1}) == "Guidance"
%                 input.sensor_type{k} = tokens{1}{1};
                input.error_type{k} = tokens{1}{2};
                data1 = dlmread(string(fileDirectory)+'\'+string(fileName));
                poses = [];

                % Loop for pose solution convert
                for j = 1:size(data1,1)
                    % Construct transformation matrix T from data record
                    rot = rotz(data1(j,10)*pi/180)*roty(data1(j,11)*pi/180)*rotx(data1(j,12)*pi/180); % rotation matrix
                    T = [rot(1:4,1:3), [data1(j,7)*0.0254; data1(j,8)*0.0254; data1(j,9)*0.0254; 1]]; % transformation matrix

                    % Convert transformation matrix to pose
                    newpose = trans2pose( T );
                    poses = [poses; newpose];
                    
                end
                resultArray = [resultArray; poses];
                num_data = [num_data, size(poses,1)];
                input.sensor_type{k} = '3D Guidance trakSTAR';
                k=k+1;
                
            else
                  
                carrier = [true, false];
                for j = 1:2
                    input.sensor_type{k} = tokens{1}{1};
                    input.error_type{k} = tokens{1}{2};  
                    options = interfere_options('concentric', true);                   
                    options.ishigh = carrier(j);

                    [cal, options] = load_interfere_cal(options);

                    % Read data from the file lists
                    options.in_files = {string(fileDirectory)+'\'+string(fileName)};

                    % Read data from the file
                    [motion, couplings] = read_cal_data(options);
                    
                    % Solve pose for the metal
                    [poses, valid] = pose_solution(couplings, cal, options);
                    resultArray = [resultArray; poses];

                    % Collect the amount of data point in each file
                    num_data = [num_data, size(poses,1)];  
                    
                    if options.ishigh == 1
                        input.sensor_type{k} = 'ilemt-high carrier';
                    else
                        input.sensor_type{k} = 'ilemt-low carrier';
                    end
                    
                    k=k+1;
                end
            end
            result_all.resultArray = resultArray;
            result_all.num_data = num_data;
            
        end    
    end
    
end

function result_all = dataprocess(result_all)
    diffResult = [];
    transResult = [];
    rotResult = [];
    
    i = 1;
    j = 1;

    step = result_all.num_data(end);
    while j <= (size(result_all.resultArray, 1) - result_all.num_data(end)+1) 
        step = result_all.num_data(i);
        % Find baseline pose from average between first and last poses 
        nometal = (result_all.resultArray(j, :) + result_all.resultArray(j + step - 1, :))/2;
        for m = 1:(step-2)
            % Solve the error from different vector between that position and nome
            plotDiff = pose_difference(nometal, result_all.resultArray(j+m, :));
            diffResult = [diffResult; plotDiff];
        end
        
        j = j + step;
        i = i+1;
    end
    
    % Loop for bundle norm of tanslational and rotational 
    for n = 1:numel(diffResult(:,1))
        trans = norm(diffResult(n, 1:3));
        rot = norm(diffResult(n, 4:6));
 
        transResult = [transResult; trans];
        rotResult = [rotResult; rot];
    end
    
    % Bundle translational and rotational errors to struct of result_all
    result_all.transResult = transResult;
    result_all.rotResult = rotResult;   
end

function plot_sanity(input, result_all,directory)
        errorType = {'translation','rotaion', '[m]', '[rad]'};
        dataType = {result_all.transResult,result_all.rotResult};
        
        figure()
        for i = 1:2
            data = dataType{i};
            subplot(2,1,i)
            list_name = {};
            k = 0;        
            p=1;
            for j = 1:size(input.sensor_type,2)
                if input.error_type{j} == "translation"
                    plot(linspace(0,(result_all.num_data(j)-3)/100,result_all.num_data(j)-2),data(k+1:k+result_all.num_data(j)-2), '.-', 'MarkerSize', 8)
                    list_name{p}=input.sensor_type{j};
                    p=p+1;
                    hold on
                    
                end
                k = k+result_all.num_data(j)-2;    
            end  
            legend(list_name);  
            xlabel("Distance from Reference [m]")
            ylabel("Actual "+errorType{i}+" of sensor "+errorType{i+2})
            title("The "+errorType{i}+"al error from varying sensor from transmitter at (15,10) cm as a reference")
        end
        savefig(fullfile(directory, "Translation Test.fig"))
        
        figure()
        for i = 1:2
            data = dataType{i};
            subplot(2,1,i)
            list_name = {};
            k=0;        
            p=1;
            for j = 1:size(input.sensor_type,2)
                if input.error_type{j} == "rotation"
                    plot(linspace(0,2*pi-pi/18,result_all.num_data(j)-2),data(k+1:k+result_all.num_data(j)-2), '.-', 'MarkerSize', 8)
                    list_name{p}=input.sensor_type{j};
                    p=p+1;
                    hold on
                end
                k = k+result_all.num_data(j)-2;
            end  
            legend(list_name);  
            xlabel("Rotation from Reference [rad]")
            ylabel("Actual "+errorType{i}+" of sensor "+errorType{i+2})
            title("The "+errorType{i}+"al error from varying sensor orientation - horizon alignment as 0 degrees is a reference at (0,10)")
        end
        savefig(fullfile(directory, "Rotation Test.fig"))
           
end