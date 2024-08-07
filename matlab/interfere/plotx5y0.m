%% Plot Process-Translation Error
function plotx5y0(transResult, rotResult, transResultLow, rotResultLow)

name ={'Ideal Result', 'Hollow LC Steel', 'Hollow 416 SS', 'Hollow 304 SS', 'Hollow 6061 Al', 'Hollow Ti Gr 5', 'Hollow Copper', ...
    'Sheet LC Steel', 'Sheet 304 SS', 'Sheet 6061 Al', 'Sheet Copper', ...
     'Solid LC Steel', 'Solid 416 SS', 'Solid 304 SS', 'Solid 6061 Al', 'Solid Ti Gr 5', 'Solid Copper'};
% High Carrier versus Low Carrier Translation Error on(5,0)
subplot(1,2,1)

% X includes the whole 12 metals translation error
x = transResult;
y = x;
loglog(x, y);
axis equal;
S = 100;
hold on 

scatter(transResult(1), transResultLow(1), S, 'red', 'filled')
scatter(transResult(2), transResultLow(2), S, 'green', 'filled')
scatter(transResult(3), transResultLow(3), S, 'magenta', 'filled')
scatter(transResult(4), transResultLow(4), S, 'b', 'filled')
scatter(transResult(5), transResultLow(5), S, 'black', 'filled')
scatter(transResult(6), transResultLow(6), S, 'cyan', 'filled')
scatter(transResult(7), transResultLow(7), S, 'red^')
scatter(transResult(8), transResultLow(8), S, 'magenta^')
scatter(transResult(9), transResultLow(9), S, 'b^')
scatter(transResult(10), transResultLow(10), S, 'cyan^')
scatter(transResult(11), transResultLow(11), S, 'r*')
scatter(transResult(12), transResultLow(12), S, 'g*')
scatter(transResult(13), transResultLow(13), S, 'm*')
scatter(transResult(14), transResultLow(14), S, 'b*')
scatter(transResult(15), transResultLow(15), S, 'black*')
scatter(transResult(16), transResultLow(16), S, 'cyan*')

daspect([1 1 1])
hold off

xlabel("High Carrier Effects (log scale)")
ylabel("Low Carrier Effects (log scale)")
title({"12 Metals High Carrier versus Low Carrier Translation Error Comparison on" ,"(15,0) for Hollow and Solid Metals, (25,0) for Sheet Metal"})
legend(name ,'Location','northwest')

%% High Carrier versus Low Carrier Rotation Error on(5,0)
subplot(1,2,2)

% X includes the whole 12 metals rotation error
x1 = rotResult;
y1 = x1;
loglog(x1, y1);
axis equal;
hold on 

scatter(rotResult(1), rotResultLow(1), S, 'red', 'filled')
scatter(rotResult(2), rotResultLow(2), S, 'green', 'filled')
scatter(rotResult(3), rotResultLow(3), S, 'magenta', 'filled')
scatter(rotResult(4), rotResultLow(4), S, 'b', 'filled')
scatter(rotResult(5), rotResultLow(5), S, 'black', 'filled')
scatter(rotResult(6), rotResultLow(6), S, 'cyan', 'filled')
scatter(rotResult(7), rotResultLow(7), S, 'red^')
scatter(rotResult(8), rotResultLow(8), S, 'magenta^')
scatter(rotResult(9), rotResultLow(9), S, 'b^')
scatter(rotResult(10), rotResultLow(10), S, 'cyan^')
scatter(rotResult(11), rotResultLow(11), S, 'r*')
scatter(rotResult(12), rotResultLow(12), S, 'g*')
scatter(rotResult(13), rotResultLow(13), S, 'm*')
scatter(rotResult(14), rotResultLow(14), S, 'b*')
scatter(rotResult(15), rotResultLow(15), S, 'black*')
scatter(rotResult(16), rotResultLow(16), S, 'cyan*')


daspect([1 1 1])
hold off

xlabel("High Carrier Effects (log scale)")
ylabel("Low Carrier Effects (log scale)")
title({"12 Metals High Carrier versus Low Carrier Rotation Error Comparison on", "(15,0) for Hollow and Solid Metal, (25,0) for Sheet Metal"})
legend(name,'Location','northwest')

%%
HLtrans = table();
HLrot = table();
ratio_trans = transResultLow./transResult; 
ratio_rot = rotResultLow./rotResult;
for i = 1:numel(transResult)
    HLtrans_new = {name(i+1), transResult(i), transResultLow(i), ratio_trans(i)};
    HLrot_new = {name(i+1), rotResult(i), rotResultLow(i), ratio_rot(i)};
    
    HLtrans = [HLtrans; HLtrans_new];
    HLrot = [HLrot; HLrot_new];
end
HLtrans.Properties.VariableNames = {'MetalShape', 'High_Carrier', 'Low_Carrier','LowHigh_Ratio'};
HLrot.Properties.VariableNames = {'MetalShape', 'High_Carrier', 'Low_Carrier','LowHigh_Ratio'};
savefilename = 'transResult_Ratio.xlsx';
fprintf('\nTable of Translational Error Result and the Error Ratio (Low/High)\n')
disp(HLtrans)
writetable(HLtrans, savefilename);

savefilename = 'rotResult_Ratio.xlsx';
fprintf('\nTable of Rotational Error Result and the Error Ratio (Low/High)\n')
disp(HLrot)
writetable(HLrot, savefilename);
% writetable(HLrot, savefilename, 'Sheet', 'Rotation');


end 