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

%% Angle Deficiency

L = evalfr(G,s_d);
phase_angle = rad2deg(angle(L));
angle_def = 180 - abs(phase_angle);

fprintf("Plant Angle : %.2f degree\n",phase_angle)
fprintf("Required Phase lead : %.2f degree\n",angle_def)

%% Angle Deficiency
% Pole and Zero Angles

p = pole(G);
z = zero(G);

disp("Pole Angles")
for i = 1:length(p)
    theta = angle(s_d - p(i))*180/pi;
    fprintf("Pole %d = %.2f deg\n",i,theta);
end

disp("Zero Angles")
for i = 1:length(z)
    theta = angle(s_d - z(i))*180/pi;
    fprintf("Zero %d = %.2f deg\n",i,theta);
end

theta_p = sum(angle(s_d-p))*180/pi;
theta_z = sum(angle(s_d-z))*180/pi;

fprintf("\nTotal Pole Angle = %.2f deg\n",theta_p);
fprintf("Total Zero Angle = %.2f deg\n",theta_z);

fprintf("Plant Angle = %.2f deg\n",theta_z-theta_p);
fprintf("Required Phase Lead = %.2f deg\n",180-abs(theta_z-theta_p))

% Compensator Pole and Zero 

% By pole-zero canellation method ;
 
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


%% Lead Compensator Tests

z_c = [-0.5 -0.8 -1.0 -1.5 -2.0];
p_c = [-2 -4 -5 -6 -8];

for i = 1:length(z_c)

    fprintf('\n=====================================\n');
    fprintf('Test %d\n',i);
    fprintf('Zero = %.1f\tPole = %.1f\n',z_c(i),p_c(i));

    % Lead compensator
    C = tf([1 abs(z_c(i))],[1 abs(p_c(i))]);

    % Open-loop compensated system
    G_comp = C*G;

    % Plot root locus
    figure(i)
    rlocus(G_comp)
    sgrid(0.59,0.4)
    title(sprintf('Test %d',i))

    % Select gain from root locus
    [K,p] = rlocfind(G_comp);

    fprintf('Selected Gain K = %.4f\n',K);

    % Closed-loop system
    T = feedback(K*G_comp,1);

    fprintf('Closed-loop poles:\n');
    disp(pole(T))

    fprintf('Step Information:\n');
    disp(stepinfo(T))

end

%% Control System Designer 

controlSystemDesigner('rlocus',G)
% sisotool(G

