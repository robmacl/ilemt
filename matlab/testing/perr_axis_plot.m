function perr_axis_plot (perr, onax, options)
% Plot INL and DNL, with seperate plots for XYZ and RxRyRz
  ax_names = {'X', 'Y', 'Z', 'Rx', 'Ry', 'Rz'};
  perr_axis_plot1(onax(1:3), options, ax_names(1:3), 'mm', 'degrees');
  perr_axis_plot1(onax(4:6), options, ax_names(4:6), 'degrees', 'mm');
end
