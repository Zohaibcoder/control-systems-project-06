clc; clear all;

% Aircraft plant
K_plant = 1.282; tau = -1.0;
num = [K_plant*tau  K_plant];
den = [1  1.935  0.987  0.179];
G = tf(num, den);

% Compensator Pole and Zero 
 
z_c = p(1)
theta_p_c = 180+theta_z-(theta_p-angle(s_d - p(1))*180/pi)
pc = imag(s_d)/(tan(theta_p_c*pi/180)) + abs(real(s_d))


%% Lead Compensator
z_c = 1.2679;
p_c = 0.083;
C_lead = tf([1  z_c], [1  p_c]);

% Compensated system
G_comp = C_lead * G;

% Plot original and compensated root locus
figure(1)
subplot(1,2,1)
rlocus(G); sgrid
title('Original Root Locus')
grid on; xlim([-2 2]); ylim([-2 2])

subplot(1,2,2)
rlocus(G_comp); sgrid
title('Compensated Root Locus')
grid on; xlim([-2 2]); ylim([-2 2])

angle(evalfr(C_lead,s_d))*180/pi

% figure(2)
% rlocus(G_comp) ; sgrid
% [k,poles] = rlocfind(G_comp)

