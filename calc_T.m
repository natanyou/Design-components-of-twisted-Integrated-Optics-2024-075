function T = calc_T(lambda, theta, n1, n2, L)
    psi = atan2(2*theta*lambda,L*2*pi*real((n1-n2)));
    sigma_y = [0, -1i; 1i, 0];
    sigma_z = [1, 0; 0, -1];
    msigma = sin(psi).*sigma_y + cos(psi).*sigma_z;
    T = exp(-1i*(n1+n2)*pi*L/lambda).*expm(-1i*msigma*pi*(n1-n2)./cos(psi)*L/lambda);
    T = expm(1i*sigma_y*theta)*T;
end
