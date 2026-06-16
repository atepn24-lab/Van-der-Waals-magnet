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
alpha = 0.05;
gamma = 1;

% Coupling J(x)
J_left  = -0.02;
J_right = 0.2;

w  = 8;
x0 = 0;

Jx = (J_left+J_right)/2 + ...
     ((J_right-J_left)/2)*tanh((x-x0)/w);

J  = repmat(Jx(:),1,Nz);

%% =========================
%% =========================
% INITIAL CONDITIONS
%% =========================
% 3. INITIAL CONDITIONS
% (LOAD GROUND STATE)
%% =========================
% filename = 'z-0,3.txt';
% %
% % %% ----- IMPORT FILE -----
%  opts = detectImportOptions(filename);
% %
% % % skip header text lines
%  opts.DataLines = [3 Inf];
% %
% data = readmatrix(filename, opts);
% %
% % %% ----- REMOVE NaNs -----
% data = data(~any(isnan(data),2), :);
% %
% % %% ----- TOTAL GRID POINTS -----
% N = Nx * Nz;
% %
% % %% =========================
% % % LAYER 1
% % %% =========================
% %
%  layer1 = data(1:N,:);
% %
%  mx1 = reshape(layer1(:,3), Nx, Nz);
%  my1 = reshape(layer1(:,4), Nx, Nz);
%  mz1 = reshape(layer1(:,5), Nx, Nz);
% %
% m1 = cat(3, mx1, my1, mz1);
% %
% % %% =========================
% % % LAYER 2
% % %% =========================
% %
%  layer2 = data(N+1:2*N,:);
% %
%  mx2 = reshape(layer2(:,3), Nx, Nz);
%  my2 = reshape(layer2(:,4), Nx, Nz);
% mz2 = reshape(layer2(:,5), Nx, Nz);
% %
%  m2 = cat(3, mx2, my2, mz2);
% %
% % %% =========================
% % % NORMALIZATION
% % %% =========================
% %
%  m1 = m1 ./ sqrt(sum(m1.^2,3));
%  m2 = m2 ./ sqrt(sum(m2.^2,3));
% %
% % %% =========================
% % % INITIAL VECTOR
% % %% =========================
% %
%  y = reshape(cat(3,m1,m2), [], 1);
%% =========================
% 3. INITIAL CONDITIONS
% (LOAD GROUND STATE)
%% =========================
 m1 = randn(Nx,Nz,3);
  m2 = randn(Nx,Nz,3);
% % % %
  m1 = m1 ./ sqrt(sum(m1.^2,3));
  m2 = m2 ./ sqrt(sum(m2.^2,3));
% % % %
  y = reshape(cat(3,m1,m2),[],1);



% 3. INITIAL CONDITIONS
% HALF FROM groundstate.txt
% HALF FROM groundstate2.txt
%% =========================

%% ----- Z SPLIT -----
% z_split = 50;
% 
% % index where z <= 50
% split_idx = find(z <= z_split, 1, 'last');
% 
% %% =========================================================
% % LOAD FIRST GROUND STATE
% %% =========================================================
% 
% filename1 = 'groundstate.txt';
% 
% opts1 = detectImportOptions(filename1);
% opts1.DataLines = [3 Inf];
% 
% data1 = readmatrix(filename1, opts1);
% 
% data1 = data1(~any(isnan(data1),2), :);
% 
% N = Nx * Nz;
% 
% %% ----- LAYER 1 -----
% layer1a = data1(1:N,:);
% 
% mx1a = reshape(layer1a(:,3), Nx, Nz);
% my1a = reshape(layer1a(:,4), Nx, Nz);
% mz1a = reshape(layer1a(:,5), Nx, Nz);
% 
% m1a = cat(3,mx1a,my1a,mz1a);
% 
% %% ----- LAYER 2 -----
% layer2a = data1(N+1:2*N,:);
% 
% mx2a = reshape(layer2a(:,3), Nx, Nz);
% my2a = reshape(layer2a(:,4), Nx, Nz);
% mz2a = reshape(layer2a(:,5), Nx, Nz);
% 
% m2a = cat(3,mx2a,my2a,mz2a);
% 
% %% =========================================================
% % LOAD SECOND GROUND STATE
% %% =========================================================
% 
% filename2 = 'groundstate2.txt';
% 
% opts2 = detectImportOptions(filename2);
% opts2.DataLines = [3 Inf];
% 
% data2 = readmatrix(filename2, opts2);
% 
% data2 = data2(~any(isnan(data2),2), :);
% 
% %% ----- LAYER 1 -----
% layer1b = data2(1:N,:);
% 
% mx1b = reshape(layer1b(:,3), Nx, Nz);
% my1b = reshape(layer1b(:,4), Nx, Nz);
% mz1b = reshape(layer1b(:,5), Nx, Nz);
% 
% m1b = cat(3,mx1b,my1b,mz1b);
% 
% %% ----- LAYER 2 -----
% layer2b = data2(N+1:2*N,:);
% 
% mx2b = reshape(layer2b(:,3), Nx, Nz);
% my2b = reshape(layer2b(:,4), Nx, Nz);
% mz2b = reshape(layer2b(:,5), Nx, Nz);
% 
% m2b = cat(3,mx2b,my2b,mz2b);
% 
% %% =========================================================
% % COMBINE STATES
% %% =========================================================
% 
% m1 = zeros(Nx,Nz,3);
% m2 = zeros(Nx,Nz,3);
% 
% % z = 1 -> 50 from first ground state
% m1(:,1:split_idx,:) = m1a(:,1:split_idx,:);
% m2(:,1:split_idx,:) = m2a(:,1:split_idx,:);
% 
% % z = 51 -> 100 from second ground state
% m1(:,split_idx+1:end,:) = m1b(:,split_idx+1:end,:);
% m2(:,split_idx+1:end,:) = m2b(:,split_idx+1:end,:);
% 
% %% =========================================================
% % NORMALIZATION
% %% =========================================================
% 
% m1 = m1 ./ sqrt(sum(m1.^2,3));
% m2 = m2 ./ sqrt(sum(m2.^2,3));
% 
% %% =========================================================
% % INITIAL VECTOR
% %% =========================================================
% 
% y = reshape(cat(3,m1,m2), [], 1);



%% =========================
% 4. TIME SETTINGS
%% =========================
t = 0;

t_end = 3000;
dt    = 0.5;

opts = odeset('RelTol',1e-6,'AbsTol',1e-8);

%% =========================
% 5. FIGURE SETUP
%% =========================
figure('Color','white','Position',[100 100 900 700]);

idx_x = 1:2:Nx;
idx_z = 1:2:Nz;

[X_grid, Z_grid] = ndgrid(x(idx_x), z(idx_z));

% Two separate layers
Y1 = 2*ones(size(X_grid));
Y2 =  -2*ones(size(X_grid));

vecsize = 2;

hold on;
grid on;

%% ===== INITIAL LAYER 1 =====
Mx1 = m1(idx_x,idx_z,1);
My1 = m1(idx_x,idx_z,2);
Mz1 = m1(idx_x,idx_z,3);

q1 = quiver3( ...
    X_grid, Y1, Z_grid, ...
    Mx1*vecsize, ...
    My1*vecsize, ...
    Mz1*vecsize, ...
    0,'b','LineWidth',1.2);

%% ===== INITIAL LAYER 2 =====
Mx2 = m2(idx_x,idx_z,1);
My2 = m2(idx_x,idx_z,2);
Mz2 = m2(idx_x,idx_z,3);

q2 = quiver3( ...
    X_grid, Y2, Z_grid, ...
    Mx2*vecsize, ...
    My2*vecsize, ...
    Mz2*vecsize, ...
    0,'r','LineWidth',1.2);

q1.MaxHeadSize = 0.5;
q2.MaxHeadSize = 0.5;

%% =========================
% AXES
%% =========================
axis equal;

xlim([min(x) - 2 max(x) + 2]);
ylim([-5 5]);
zlim([min(z) max(z)]);

xlabel('x');
ylabel('Layer Direction');
zlabel('z');

title('Bilayer LLG Spin Dynamics');

view([35 25]);

rotate3d on;

drawnow;

%% =========================
% 6. TIME LOOP
%% =========================
while t < t_end

    fprintf('Starting step at t = %.2f\n',t);

    %% ===== SOLVE =====
    [~,y_out] = ode45( ...
        @(t,y) llg_rhs_2D( ...
        t,y,Nx,Nz,dx,dz,A,K,J,alpha,gamma), ...
        [t t+dt], y, opts);
    

    y = y_out(end,:)';
    dydt = llg_rhs_2D( ...
        t, y, Nx, Nz, dx, dz, ...
        A, K, J, alpha, gamma);

    max_torque = max(abs(dydt));

    fprintf('max torque = %.3e\n', max_torque);

    t = t + dt;

    fprintf('Finished step at t = %.2f\n',t);

    %% ===== RESHAPE =====
    m = reshape(y,Nx,Nz,6);

    m1 = m(:,:,1:3);
    m2 = m(:,:,4:6);

    %% ===== UPDATE LAYER 1 =====
    q1.UData = m1(idx_x,idx_z,1)*vecsize;
    q1.VData = m1(idx_x,idx_z,2)*vecsize;
    q1.WData = m1(idx_x,idx_z,3)*vecsize;

    %% ===== UPDATE LAYER 2 =====
    q2.UData = m2(idx_x,idx_z,1)*vecsize;
    q2.VData = m2(idx_x,idx_z,2)*vecsize;
    q2.WData = m2(idx_x,idx_z,3)*vecsize;

    %% ===== TITLE =====
    title(sprintf('Bilayer LLG Spin Dynamics | t = %.2f',t));

    drawnow limitrate;

end
%% =========================
% FINAL NUMERICAL OUTPUT
%% =========================
m_final = reshape(y,Nx,Nz,6);

m1_final = m_final(:,:,1:3);
m2_final = m_final(:,:,4:6);

[X,Z] = ndgrid(x,z);

data1 = [ ...
    X(:), ...
    Z(:), ...
    reshape(m1_final(:,:,1),[],1), ...
    reshape(m1_final(:,:,2),[],1), ...
    reshape(m1_final(:,:,3),[],1)];

data2 = [ ...
    X(:), ...
    Z(:), ...
    reshape(m2_final(:,:,1),[],1), ...
    reshape(m2_final(:,:,2),[],1), ...
    reshape(m2_final(:,:,3),[],1)];

%% =========================
% WRITE TO TEXT FILE
%% =========================
filename = 'final_state.txt';

fid = fopen(filename,'w');

%% ----- HEADER -----
fprintf(fid,'===== LAYER 1 =====\n');
fprintf(fid,'x\tz\tmx\tmy\tmz\n');

%% ----- LAYER 1 DATA -----
fprintf(fid,'%f\t%f\t%f\t%f\t%f\n', data1.');

fprintf(fid,'\n');

%% ----- LAYER 2 HEADER -----
fprintf(fid,'===== LAYER 2 =====\n');
fprintf(fid,'x\tz\tmx\tmy\tmz\n');

%% ----- LAYER 2 DATA -----
fprintf(fid,'%f\t%f\t%f\t%f\t%f\n', data2.');

fclose(fid);

disp('Data saved to final_state.txt');
