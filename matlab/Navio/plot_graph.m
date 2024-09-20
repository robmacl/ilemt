function plot_graph(result_all, data, input_param)
% Pass all related argumens to plot the assigned plot type.
% 
% Input arguments:
% result_all:
%     Struct with the sub-struct of high and low carriers. Each of them has 
%     the sub-sub-struct of translational error, rotational error, coupling 
%     magnitude, and number of data in each ouput file in double array.
% 
% data:
%     Table with sub-cell array of FileName, MetalShape and MetalName.
% 
% input_param:
%     Struct of input parameters. See input_params.m for more information

%     if input_param.type == 'HighLow'
%         plotHighLow(result_all, data, input_param)
    if input_param.type == 'xmoving'
         plotxmoving(result_all, data, input_param)
    elseif input_param.type == 'ymoving'
        plotymoving(result_all, data, input_param)
%     elseif input_param.type == 'Sheet'
%         plotsheet(result_all, data, input_param) 
    end
         
end