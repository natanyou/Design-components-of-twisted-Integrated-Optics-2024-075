% define problem parameters
N = 100;
temp = matfile('n_H_and_V.mat');
n_H_and_V = temp.n_H_and_V;
n_H = n_H_and_V(1);
n_V = n_H_and_V(2);
l = 100*10^-3;
theta = pi;
lambda = 1.55*10^-6;
psi = linspace(0,pi/2-0.01,4);   % tan(psi)=2*alpha/lambda

j0 = [1; 0];
Ls = 0:0.2*l:l;
stokes_mat = zeros(4,numel(Ls));
for i=1:numel(Ls)
    j = calc_T(lambda, (pi/l)*Ls(i), n_H, n_V, Ls(i))*j0;
    stokes_mat(:,i) = jones_to_stokes(j);
end
figure;
plot_poincare_sphere(stokes_mat(2,:),stokes_mat(3,:),stokes_mat(4,:),'blue');
title("Modal polarization states for varying \psi");

% define anonymous function for optimization 
calc_T_lambda = @(lambda) det(eye(2) - calc_T(lambda, theta, n_H, n_V, l));

% find roots of det(I-T)

lambda_guess = 1.55*10^-6;
lambda = linspace(0.99999.*lambda_guess,1.00001.*lambda_guess,10000);
lambda_res_psi = zeros(N,numel(lambda));
[lambda_res,det_I_sub_T, minima_locs] =...
    find_res_wavelengths(lambda, lambda_guess,psi(1),n_H,n_V,l);

%% plot det(I-T) and rsonance wavelengths
figure;
plot(lambda, abs(det_I_sub_T));
title('Absolute value of det(I - T) vs. lambda');
xlabel('lambda');
ylabel('abs(det(I - T))');
hold on;
scatter(lambda_res(1:2:end), abs(det_I_sub_T(minima_locs(1:2:end))), 'g', 'filled');
scatter(lambda_res(2:2:end), abs(det_I_sub_T(minima_locs(2:2:end))), 'r', 'filled');
grid on;
hold off;
%%
% find resonances as function of psi
lambda_res_psi = zeros(N,numel(lambda_res));
det_I_sub_T_psi = zeros(numel(det_I_sub_T),N);
minima_locs_psi = zeros(N,numel(minima_locs));
figure;
legend_entries = cell(1, numel(psi));
plot_handles = gobjects(1, numel(psi));
for i = 1:numel(psi)
    [lambda_res, det_I_sub_T, minima_locs] = find_res_wavelengths(lambda, lambda_guess, psi(i), n_H, n_V, l);
    lambda_res_psi(i, :) = lambda_res;
    det_I_sub_T_psi(:, i) = det_I_sub_T;
    minima_locs_psi(i, :) = minima_locs;
    plot_handles(i) = plot(lambda, abs(det_I_sub_T));
    hold on;
    scatter(lambda_res(1:2:end), abs(det_I_sub_T(minima_locs(1:2:end))), 'g', 'filled');
    scatter(lambda_res(2:2:end), abs(det_I_sub_T(minima_locs(2:2:end))), 'r', 'filled');
    legend_entries{i} = ['$\psi = ', num2str(psi(i)), '$'];
end
title('Absolute value of det(I - T) vs. lambda');
xlabel('lambda');
ylabel('abs(det(I - T))');
grid on;
legend(plot_handles, legend_entries, 'Interpreter', 'latex');
hold off;
