clear all
close all
clc

directory = {'C:\Users\robertm2\Desktop\log_test'};
files =dir(fullfile(string(directory),'*.dat'));


[data, time, mag] = Extract_log(files)
plot_log(data, mag, time)
