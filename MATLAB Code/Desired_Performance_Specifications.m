clc; clear all;

% Aircraft plant
K_plant = 1.282; tau = -1.0;
num = [K_plant*tau  K_plant];
den = [1  1.935  0.987  0.179];
G = tf(num, den);

%% Desired Cloed Loop poles

s_d = -0.5+0.6j;

sigma = -real(s_d);
wn = abs(s_d);
zeta = sigma/wn;

fprintf("Desired pole: %.2f + %.2fj\n",real(s_d),imag(s_d))
fprintf("sigma: %.2f\n",sigma)
fprintf("Natural Frequency: %.3f rad/s\n",wn)
fprintf("Damping Ratio: %.2f\n",zeta)