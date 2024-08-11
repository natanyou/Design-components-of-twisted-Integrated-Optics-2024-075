function plot_neff_phase_errors(neff_jcm, neff_pert, lambda, alpha_t,l_arr)
    beta_jcm = neff_jcm*(2*pi/lambda);
    beta_pert = neff_pert*(2*pi/lambda);
    neff_err = neff_jcm - neff_pert;
    neff_err_rel = abs(neff_err)./neff_jcm;
    
    % Plot n_eff as a function of twist rate
    figure;
    plot(alpha_t, real(neff_jcm(1,:)));
    hold on;
    plot(alpha_t, real(neff_jcm(2,:)));
    plot(alpha_t, neff_pert(1,:));  % neff 1 perturbation
    plot(alpha_t, neff_pert(2,:));  % neff 2 perturbation
    hold off;
    title("n_{eff} as a function of twist rate");
    xlabel("Twist rate [radian/meter]");
    ylabel("n_{eff}");
    legend("n_{eff1} JCM", "n_{eff2} JCM","n_{eff1} Perturbation", "n_{eff2} Perturbation",'Location','best' );
    grid on;
        
    % n_eff absolute error 
    figure;
    plot(alpha_t ,abs(neff_err(1,:)));
    hold on;
    plot(alpha_t ,abs(neff_err(2,:)));
    hold off;
    title("n_{eff} absolute error");
    xlabel("Twist rate [radian/meter]");
    ylabel("Absolute error");
    legend("n_{eff1} error","n_{eff2} error",'Location','best');
    grid on;
    
    
    % n_eff relative error 
    figure;
    plot(alpha_t ,neff_err_rel(1,:));
    hold on;
    plot(alpha_t ,neff_err_rel(2,:));
    hold off;
    title("n_{eff} relative error");
    xlabel("Twist rate [radian/meter]");
    ylabel("Relative error");
    legend("n_{eff1} relative error","n_{eff2} relative error",'Location','best');
    grid on;
    

    
    % phase error 
    beta_err = beta_jcm - beta_pert;
    phase_diff_mat = zeros(2,numel(neff_jcm(1,:)),length(l_arr));                              % dim1 = mode, dim 2 = twist rates, dim 3 = length of waveguide
    phase_jcm_l = zeros(2,numel(neff_jcm(1,:)),length(l_arr));
    for i=1:length(l_arr)
        phase_diff_mat(:,:,i) = beta_err*l_arr(i);                         % each element is phase error
        phase_jcm_l(:,:,i) = beta_jcm*l_arr(i);
    end
    phase_diff_rel_mat = phase_diff_mat./phase_jcm_l;

    % Subplots for absolute phase error
    for j = 1:2
        figure;
        hold on;
        grid on;
        for i = 1:length(l_arr)
            plot(alpha_t, abs(phase_diff_mat(j, :, i)));
        end
        title(sprintf('Absolute accumulated phase error for varius lengths (mode %d)', j));
        xlabel('Twist rate [radian/meter]');
        ylabel('Absolute accumulated phase error [radian]');
        legendLabels = arrayfun(@(x) sprintf('length = %.2f [mm]', x), l_arr * 10^3, 'UniformOutput', false);
        legend(legendLabels, 'Location', 'best');
        
    end
    
    % Subplots for relative phase error
    for j = 1:2
        figure;
        hold on;
        grid on;
        % for i = 1:length(l_arr)
            plot(alpha_t, abs(phase_diff_rel_mat(j, :, 1)));
        % end % note that since l appeares in both numerator and denominetor and is reduced, thus loop is unnecessary
        title(sprintf('Relative accumulated phase error (independent of length) (mode %d)', j));
        xlabel('Twist rate [radian]');
        ylabel('Relative accumulated phase error');
        legendLabels = arrayfun(@(x) sprintf('length = %.2f [mm]', x), l_arr * 10^3, 'UniformOutput', false);
        % legend(legendLabels, 'Location', 'best');
        
    end

    % plots absolute phase difference err
    figure;
    hold on;
    grid on;
    for i = 1:length(l_arr)
        plot(alpha_t, abs(phase_diff_mat(1, :, i)-phase_diff_mat(2, :, i)));
    end
    title('Absolute phase difference error as a function of twist rate for varius lengths');
    xlabel('Twist rate [radian/meter]');
    ylabel('Absolute phase difference error [radian]');
    legendLabels = arrayfun(@(x) sprintf('length = %.2f [mm]', x), l_arr * 10^3, 'UniformOutput', false);
    legend(legendLabels, 'Location', 'best');
    

    % plots relative phase difference err
    figure;
    hold on;
    grid on;
    % for i = 1:length(l_arr)
    plot(alpha_t, abs((phase_diff_mat(1, :, 1)-phase_diff_mat(2, :, 1))./(phase_jcm_l(1, :, i)-phase_jcm_l(2, :, i))));
    % end  % note that since l appeares in both numerator and denominetor and is reduced, thus loop is unnecessary
    title('Relative phase difference error as a function of twist rate (independent of length)');
    xlabel('Twist rate [radian/meter]');
    ylabel('Relative phase difference error');
    
    % phase error in the twist angle - length  plane
    l_t = linspace(min(l_arr), max(l_arr), numel(alpha_t)); % twist length
    phi = linspace(min(alpha_t), max(alpha_t), numel(alpha_t));
    phi = phi .* l_t; % twist angle
    figure;
    
    for j = 1:2
        [L_T, BETA_DIFF] = meshgrid(l_t, beta_err(j, :));
        PHASE_DIFF_GRID = BETA_DIFF .* L_T;
        [L_T, BETA_JCM] = meshgrid(l_t, beta_jcm(j, :));
        PHASE_JCM_GRID = BETA_JCM .* L_T;
    
        % Absolute error subplot
        subplot(2, 2, j);
        imagesc(phi, (l_t * 10^3), abs(real(PHASE_DIFF_GRID)));
        set(gca, 'YDir', 'normal');
        colorbar;
        title(sprintf('Absolute accumulated phase error (mode %d)', j));
        xlabel('Twist angle [radian]');
        ylabel('Twist length [mm]');
        
    
        % Relative error subplot
        subplot(2, 2, j + 2);
        imagesc(phi, (l_t * 10^3), abs(real(PHASE_DIFF_GRID ./ PHASE_JCM_GRID)));
        set(gca, 'YDir', 'normal');
        colorbar;
        title(sprintf('Relative accumulated phase error (mode %d)', j));
        xlabel('Twist angle [radian]');
        ylabel('Twist length [mm]');
        
    end
end
