clear; clc; clear all;

% Grid
Nx = 201;
L  = 100; 
dx = L/(Nx-1);
x  = linspace(-L/2, L/2, Nx);

% Parameters
A     = 5.3;    
K     = 0.032;  
w     = 8;    
alpha = 0.5;    % damping
gamma = 1;    % gyromagnetic ratio

% interlayer coupling (J)
J_left  = -0.02;
J_right = 0.2;
J0 = (J_left + J_right)/2;      
Am  = (J_right - J_left)/2;      
x0 = 5;                       
J = J0 + Am * tanh((x - x0)/w);
% J plot
%figure('Color', 'white', 'Position', [100 100 600 500]);
%hold on; grid on;
%plot(x, J, 'Color', [0.85 0.75 0], 'LineWidth', 3);
%xlabel('x', 'FontSize', 14);
%ylabel('J', 'FontSize', 14);
%title('Coupling dependance on x');
%xlim([min(x) max(x)]); 
%ylim([-0.06 0.22]);

% initial condition 
m2(1:Nx, :) = randn(Nx, 3);
m1(1:Nx, :) = randn(Nx, 3);


% normalize
m1 = m1 ./ vecnorm(m1,2,2);
m2 = m2 ./ vecnorm(m2,2,2);

% pack into vector
y0 = reshape([m1 m2], [], 1);

options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
tspan = [0 3000];
[t, y] = ode45(@(t,y) llg_rhs(t,y,Nx,dx,A,K,J,alpha,gamma), tspan, y0, options);

% final state
m = reshape(y(end,:), Nx, 6);
m1 = m(:,1:3);
m2 = m(:,4:6);
disp(m) ;
% ===== FIGURE (modified) =====
figure(1); 
set(gcf,'Color','white','Position',[150 150 900 700]);

% Mx component
subplot(3,1,1);
hold on; grid on;
plot(x, m1(:, 1), 'r', 'LineWidth', 2, 'DisplayName', ['m1, A=' num2str(A)]);
plot(x, m2(:, 1), 'b', 'LineWidth', 2, 'DisplayName', ['m2, A=' num2str(A)]);
ylabel('M_x');
title('Spin Components Depended on Spin Number (Final State)');
legend('Location', 'best');
xlim([min(x) max(x)]); ylim([-1.1 1.1]);

% My component
subplot(3,1,2);
hold on; grid on;
plot(x, m1(:, 2), 'r', 'LineWidth', 0.5, 'DisplayName', ['m1, A=' num2str(A)]);
plot(x, m2(:, 2), 'g', 'LineWidth', 0.5, 'DisplayName', ['m2, A=' num2str(A)]);
ylabel('M_y');
legend('Location','best');
xlim([min(x) max(x)]); ylim([-1.1 1.1]);


% Mz component
subplot(3,1,3);
hold on; grid on;
plot(x, m1(:, 3), 'r', 'LineWidth', 2);
plot(x, m2(:, 3), 'b', 'LineWidth', 2);
xlabel('Spin Number (1 to Nx)');
ylabel('M_z');
xlim([min(x) max(x)]); ylim([-1.1 1.1]);




