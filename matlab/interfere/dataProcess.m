%% Data process for translation Error and rotation error
function [transResult, rotResult] = dataProcess(resultArray, data)

    % Store pose_difference result
    diffResult = [];
    transResult = [];
    rotResult = [];
    
    j = 1;

    step = size(resultArray, 1) / size(data, 1); 
    
    % Loop through the resultArray to get the result plot
    while j <= (size(resultArray, 1) - step + 1) 
    
        nometal = (resultArray(j, :) + resultArray(j + step - 1, :))/2;
        for m = 1:(step-2)
            plotDiff = pose_difference(nometal, resultArray(j+m, :));
            diffResult = [diffResult; plotDiff];
        end

        j = j + step;
    end

    for n = 1:numel(diffResult(:,1))
        trans = norm(diffResult(n, 1:3));
        rot = norm(diffResult(n, 4:6));
        transResult = [transResult; trans];
        rotResult = [rotResult; rot];
    end

end