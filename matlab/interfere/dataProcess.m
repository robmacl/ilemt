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
    transResult = [];
    rotResult = [];
    
    i = 1;
    j = 1;

    step = result_all.num_data(1);
    
    % Loop through the resultArray to get the result plot
    while j <= (size(result_all.resultArray, 1) - step + 1) 
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

        % If vector is less than 1e-7, we will convert it to zero 
        trans = [trans>10^-7]*trans;
        rot = [rot>10^-7]*rot;
        
        % We will have a bundle of translational and rotational error
        % 1.zero for the vector that less than zero
        % 2.retain vector if it is gfreater than zero
        transResult = [transResult; trans];
        rotResult = [rotResult; rot];
    end

    i = 1;
    j = 1;
    step = result_all.num_data(1);

    % Loop for correcting zero vector
    while j <= (size(transResult, 1)) 
        step = result_all.num_data(i)-2;
        
        % If all rotational error is zero (error cant detect), we will change it to 1e-7
        if all(rotResult(j:j+step-1)== 0) 
            rotResult(j:j+step-1)= ones(step,1)*10^-7;
        end
        % If all translational error is zero (error cant detect), we will change it to 1e-7
        if all(transResult(j:j+step-1)== 0) 
                transResult(j:j+step-1)= ones(step,1)*10^-7;    
        end
        
        % If some component is zero, we will correct it to the minimum error for that sample
        transResult(j:j+step-1) = transResult(j:j+step-1)+[transResult(j:j+step-1)==0]*min(transResult(j:j+step-1)+[transResult(j:j+step-1)==0]*1000);
        rotResult(j:j+step-1) = rotResult(j:j+step-1)+[rotResult(j:j+step-1)==0]*min(rotResult(j:j+step-1)+[rotResult(j:j+step-1)==0]*1000);            
        
        j = j + step;
        i = i+1;
    end   
    
    % Bundle translational and rotational errors to struct of result_all
    result_all.transResult = transResult;
    result_all.rotResult = rotResult;

end