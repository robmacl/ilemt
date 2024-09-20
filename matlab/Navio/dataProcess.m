%% Data process for translation Error and rotation error
function result_all = dataProcess(result_all)
% Data process for translation Error and rotation error.
% 
% Input arguments:
% result_all:
%     Struct of result data. The essential two that be used for conveerting to 
%     translaion and rotation error in this function is shown as listed:
%      - result_all.resultArray: double array of all translational and rotaional
%                     poses data
%      - result_all.num_data: double array of the amount of data points for each 
%                            output files
% 
% Return values:
% result_all:
%     Struct of two pose solutions are added to the struct of result_all.
%      - result_all.transResult: double array of translation error for each 
%                                output files
%      - result_all.rotResult: double array of rotation error for each 
%                              output files

    % Store pose_difference result
    diffResult = [];
    result_all.transResult = [];
    result_all.rotResult = [];
    
    i = 1;
    j = 1;

    step = result_all.num_data(1);
    
    % Loop through the resultArray to get the result plot
    while j <= (size(result_all.resultArray, 1) - step + 1) 
        step = result_all.num_data(i);
        nometal = (result_all.resultArray(j, :) + result_all.resultArray(j + step - 1, :))/2;
        for m = 1:(step-2)
            plotDiff = pose_difference(nometal, result_all.resultArray(j+m, :));
            diffResult = [diffResult; plotDiff];
        end

        j = j + step;
        i = i+1;
    end

    for n = 1:numel(diffResult(:,1))
        trans = norm(diffResult(n, 1:3));
        rot = norm(diffResult(n, 4:6));
        result_all.transResult = [result_all.transResult; trans];
        result_all.rotResult = [result_all.rotResult; rot];
    end
end