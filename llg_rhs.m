function dydt = llg_rhs(~, y, Nx, dx, A, K, J, alpha, gamma)
    m = reshape(y, Nx, 6);
    m1 = m(:, 1:3);
    m2 = m(:, 4:6);
    
    %normalize
    m1 = m1 ./ vecnorm(m1,2,2);
    m2 = m2 ./ vecnorm(m2,2,2);

    coeff = gamma / (1 + alpha^2);
    
    % Laplacian operator discretization
    m1_left  = [[0 1 0]; m1(1:Nx-1, :)];
    m1_right = [m1(2:Nx, :); [0 1 0]];
    lap1 = (m1_right - 2*m1 + m1_left) / dx^2;
    
    m2_left  = [[0 -1 0]; m2(1:Nx-1, :)];
    m2_right = [m2(2:Nx, :); [0 1 0]];
    lap2 = (m2_right - 2*m2 + m2_left) / dx^2;
    
    % effective field
    H1 = A*lap1 + K*[zeros(Nx,1), m1(:,2), zeros(Nx,1)] + J(:).*m2;
    H2 = A*lap2 + K*[zeros(Nx,1), m2(:,2), zeros(Nx,1)] + J(:).*m1;

    mxH1   = cross(m1, H1, 2);
    mxmxH1 = cross(m1, mxH1, 2);
    dmdt1  = -coeff * mxH1 - (alpha * coeff) * mxmxH1;
    mxH2   = cross(m2, H2, 2);
    mxmxH2 = cross(m2, mxH2, 2);
    dmdt2  = -coeff * mxH2 - (alpha * coeff) * mxmxH2;
    
    % projection
    dmdt1 = dmdt1 - (sum(m1.*dmdt1,2)).*m1;
    dmdt2 = dmdt2 - (sum(m2.*dmdt2,2)).*m2;

    dydt = reshape([dmdt1, dmdt2], [], 1);
end