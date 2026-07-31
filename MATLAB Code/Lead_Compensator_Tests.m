clc; clear all;

% Aircraft plant
K_plant = 1.282; tau = -1.0;
num = [K_plant*tau  K_plant];
den = [1  1.935  0.987  0.179];
G = tf(num, den);

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