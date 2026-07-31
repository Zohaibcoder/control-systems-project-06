clc; clear all;

% Aircraft plant
K_plant = 1.282; tau = -1.0;
num = [K_plant*tau  K_plant];
den = [1  1.935  0.987  0.179];
G = tf(num, den);

             %% Control System Designer 

controlSystemDesigner('rlocus',G)
% sisotool(G
