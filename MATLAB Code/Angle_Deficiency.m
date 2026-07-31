clc; clear all;

% Aircraft plant
K_plant = 1.282; tau = -1.0;
num = [K_plant*tau  K_plant];
den = [1  1.935  0.987  0.179];
G = tf(num, den);


                      %% Angle Deficiency
 

L = evalfr(G,s_d);
phase_angle = rad2deg(angle(L));
angle_def = 180 - abs(phase_angle);

fprintf("Plant Angle : %.2f degree\n",phase_angle)
fprintf("Required Phase lead : %.2f degree\n",angle_def)


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
