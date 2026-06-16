clear; clc; close all;

%% =========================
% 1. GRID SETUP
%% =========================
Nx = 20;
Nz = 200;
Lx = 20;
Lz = 200;
dx = Lx/(Nx-1);
dz = Lz/(Nz-1);
x = linspace(-Lx/2, Lx/2, Nx);
z = linspace(0, Lz, Nz);

%% =========================
% 2. PARAMETERS
%% =========================
A     = 5.3;
K     = 0.032;
alpha = 0;
gamma = 1;

% Coupling J(x)
J_left  = -0.02;
J_right = 0.2;
w  = 8;
x0 = 0;
Jx = (J_left+J_right)/2 + ...
     ((J_right-J_left)/2)*tanh((x-x0)/w);
J  = repmat(Jx(:),1,Nz);

%% =========================================================
% LOAD FIRST GROUND STATE (mz = 0)
%% =========================================================
filename1 = 'z0.txt';
opts1 = detectImportOptions(filename1);
opts1.DataLines = [3 Inf];
data1 = readmatrix(filename1, opts1);
data1 = data1(~any(isnan(data1),2), :);
N0 = Nx * Nz;
N = Nx*Nz/2 ;

%% ----- LAYER 1 -----
layer1a = data1(1:N0,:);
mx1a = reshape(layer1a(:,3), Nx, Nz);
my1a = reshape(layer1a(:,4), Nx, Nz);
mz1a = reshape(layer1a(:,5), Nx, Nz);
m1a = cat(3,mx1a,my1a,mz1a);

%% ----- LAYER 2 -----
layer2a = data1(N0+1:2*N0,:);
mx2a = reshape(layer2a(:,3), Nx, Nz);
my2a = reshape(layer2a(:,4), Nx, Nz);
mz2a = reshape(layer2a(:,5), Nx, Nz);
m2a = cat(3,mx2a,my2a,mz2a);

%% =========================================================
% LOAD SECOND GROUND STATE (mz = 0.3)
%% =========================================================
filename2 = 'z-0,3.txt';
opts2 = detectImportOptions(filename2);
opts2.DataLines = [3 Inf];
data2 = readmatrix(filename2, opts2);
data2 = data2(~any(isnan(data2),2), :);

%% ----- LAYER 1 -----
layer1b = data2(1:N,:);
mx1b = reshape(layer1b(:,3), Nx, Nz/2);
my1b = reshape(layer1b(:,4), Nx, Nz/2);
mz1b = reshape(layer1b(:,5), Nx, Nz/2);
m1b = cat(3,mx1b,my1b,mz1b);

%% ----- LAYER 2 -----
layer2b = data2(N+1:2*N,:);
mx2b = reshape(layer2b(:,3), Nx, Nz/2);
my2b = reshape(layer2b(:,4), Nx, Nz/2);
mz2b = reshape(layer2b(:,5), Nx, Nz/2);
m2b = cat(3,mx2b,my2b,mz2b);

%% =========================================================
% LOAD THIRD GROUND STATE (mz = -0.3)
%% =========================================================
filename3 = 'z0.4.txt';
opts3 = detectImportOptions(filename3);
opts3.DataLines = [3 Inf];
data3 = readmatrix(filename3, opts3);
data3 = data3(~any(isnan(data3),2), :);

%% ----- LAYER 1 -----
layer1c = data3(1:N,:);
mx1c = reshape(layer1c(:,3), Nx, Nz/2);
my1c = reshape(layer1c(:,4), Nx, Nz/2);
mz1c = reshape(layer1c(:,5), Nx, Nz/2);
m1c = cat(3,mx1c,my1c,mz1c);

%% ----- LAYER 2 -----
layer2c = data3(N+1:2*N,:);
mx2c = reshape(layer2c(:,3), Nx, Nz/2);
my2c = reshape(layer2c(:,4), Nx, Nz/2);
mz2c = reshape(layer2c(:,5), Nx, Nz/2);
m2c = cat(3,mx2c,my2c,mz2c);

%% =========================================================
% CONSTRUCT INITIAL CONDITIONS
%% =========================================================
% Start from mz = 0 everywhere
m1 = m1a;
m2 = m2a;

% Insert mz = -0.3 slice at z = 49 directly from filename3
m1(:, 49, :) = m1b(:, 49, :);
m2(:, 49, :) = m2b(:, 49, :);

% Insert mz = 0.3 slice at z = 51 directly from filename2
m1(:, 51, :) = m1c(:, 51, :);
m2(:, 51, :) = m2c(:, 51, :);

%% =========================================================
% NORMALIZATION
%% =========================================================
m1 = m1 ./ sqrt(sum(m1.^2,3));
m2 = m2 ./ sqrt(sum(m2.^2,3));

%% =========================================================
% INITIAL VECTOR
%% =========================================================
y = reshape(cat(3,m1,m2), [], 1);

%% =========================
% 4. TIME SETTINGS
%% =========================
t = 0;
t_end = 15;
dt    = 0.2;
opts = odeset('RelTol',1e-6,'AbsTol',1e-8);

%% =========================
% 5. FIGURE SETUP
%% =========================
fig = figure('Color','w','Position',[100 100 1800 600]);
[Xsurf,Zsurf] = meshgrid(x,z);

%% ----- INITIAL DATA -----
mz1 = squeeze(m1(:,:,3))';
mz2 = squeeze(m2(:,:,3))';

%% =====================================================
% LAYER 1 SURFACE
%% =====================================================
ax1 = subplot(1,3,1);
s1 = surf(Xsurf,Zsurf,mz1,'EdgeColor','none');
axis([-10 10 0 200 -0.15 0.15]) ;
clim([-0.15 0.15])
shading interp
colormap turbo
xlabel('x')
ylabel('z')
zlabel('m_z')
title('Layer 1')
view(85,35)

colorbar
grid on

%% =====================================================
% LAYER 2 SURFACE
%% =====================================================
ax2 = subplot(1,3,2);
s2 = surf(Xsurf,Zsurf,mz2,'EdgeColor','none');
axis([-10 10 0 200 -0.15 0.15]) ;
clim([-0.15 0.15])
shading interp
colormap turbo
xlabel('x')
ylabel('z')
zlabel('m_z')
title('Layer 2')
view(85,35) 
colorbar
grid on

%% =========================
% GIF SETTINGS
%% =========================
gif_filename = 'soliton_sim.gif';

%% =========================
% TIME LOOP
%% =========================
frame_id = 1;
while t < t_end
    fprintf('Starting step at t = %.3f\n', t);
    
    %% ===== SOLVE =====
    [~,y_out] = ode45( ...
        @(t,y) llg_rhs_2D( ...
        t,y,Nx,Nz,dx,dz,A,K,J,alpha,gamma), ...
        [t t+dt], y, opts);
    y = y_out(end,:)';
    t = t + dt;
    fprintf('Finished step at t = %.3f\n', t);
    
    %% =========================
    % RESHAPE
    %% =========================
    m = reshape(y,Nx,Nz,6);
    m1 = m(:,:,1:3);
    m2 = m(:,:,4:6);
    
    %% =========================
    % RENORMALIZE
    %% =========================
    m1 = m1 ./ sqrt(sum(m1.^2,3));
    m2 = m2 ./ sqrt(sum(m2.^2,3));

    %% =========================
    % DELTA m_z
    %% =========================
    mz1 = squeeze(m1(:,:,3))';
    mz2 = squeeze(m2(:,:,3))';

    %% =========================
    % UPDATE SURFACES
    %% =========================
    set(s1, 'ZData', mz1, 'CData', mz1);
    set(s2, 'ZData', mz2, 'CData', mz2);
    
    %% =========================
    % GIF RECORDING
    %% =========================
    frame = getframe(fig);
    im = frame2im(frame);
    [Amap,map] = rgb2ind(im,256);
    if frame_id == 1
        imwrite(Amap,map,gif_filename, ...
            'gif', ...
            'LoopCount',Inf, ...
            'DelayTime',0.08);
    else
        imwrite(Amap,map,gif_filename, ...
            'gif', ...
            'WriteMode','append', ...
            'DelayTime',0.08);
    end
    frame_id = frame_id + 1;
end