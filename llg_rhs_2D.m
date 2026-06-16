function dydt = llg_rhs_2D(~, y, Nx, Nz, dx, dz, A, K, J, alpha, gamma)

m = reshape(y, Nx, Nz, 6);
m1 = m(:,:,1:3);
m2 = m(:,:,4:6);
n1 = sqrt(sum(m1.^2,3)); 
n2 = sqrt(sum(m2.^2,3)); 
m1 = m1 ./ n1; 
m2 = m2 ./ n2;


coeff = gamma/(1+alpha^2);

%% =========================
% LAPLACIAN (2D)
%% =========================

% ===== X direction (FM / AFM BC) =====
m1_xL = cat(1, repmat(reshape([0 1 0],1,1,3),1,Nz), m1(1:Nx-1,:,:)); %blue
m1_xR = cat(1, m1(2:Nx,:,:), repmat(reshape([0 1 0],1,1,3),1,Nz));

m2_xL = cat(1, repmat(reshape([0 -1 0],1,1,3),1,Nz), m2(1:Nx-1,:,:));
m2_xR = cat(1, m2(2:Nx,:,:), repmat(reshape([0 1 0],1,1,3),1,Nz));

lap_x1 = (m1_xR - 2*m1 + m1_xL)/dx^2;
lap_x2 = (m2_xR - 2*m2 + m2_xL)/dx^2;

% ===== Z direction (FREE BC) =====
m1_zL = cat(2, m1(:,1,:), m1(:,1:Nz-1,:));
m1_zR = cat(2, m1(:,2:Nz,:), m1(:,Nz,:));

m2_zL = cat(2, m2(:,1,:), m2(:,1:Nz-1,:));
m2_zR = cat(2, m2(:,2:Nz,:), m2(:,Nz,:));

lap_z1 = (m1_zR - 2*m1 + m1_zL)/dz^2;
lap_z2 = (m2_zR - 2*m2 + m2_zL)/dz^2;

lap1 = lap_x1 + lap_z1;
lap2 = lap_x2 + lap_z2;

%% =========================
% EFFECTIVE FIELD
%% =========================

H1 = A*lap1 + K*cat(3,zeros(Nx,Nz),m1(:,:,2),zeros(Nx,Nz)) + J.*m2;
H2 = A*lap2 + K*cat(3,zeros(Nx,Nz),m2(:,:,2),zeros(Nx,Nz)) + J.*m1;

mxH1   = cross(m1,H1,3);
mxmxH1 = cross(m1,mxH1,3);

mxH2   = cross(m2,H2,3);
mxmxH2 = cross(m2,mxH2,3);

dmdt1 = -coeff*mxH1 - alpha*coeff*mxmxH1;
dmdt2 = -coeff*mxH2 - alpha*coeff*mxmxH2;

% projection 
dmdt1 = dmdt1 - sum(m1.*dmdt1,3).*m1;
dmdt2 = dmdt2 - sum(m2.*dmdt2,3).*m2;


dydt = reshape(cat(3,dmdt1,dmdt2),[],1);
