function EM_fields = JCM_solve_fields(N,alpha_max,alpha_t,guess,sizes_1,sizes_2)
jcm_root = "C:\Users\natanyou\AppData\Roaming\JCMwave\JCMsuite";
addpath(fullfile(jcm_root, 'ThirdPartySupport', 'Matlab'));
    EM_fields_mode_1 = ones(sizes_1,sizes_2,4,N);                                     % electric fields (mat 1 ex and 2 ey) and magnetic fields (mat 3 hx and 4 hy)
    EM_fields_mode_2 = ones(sizes_1,sizes_2,4,N);                                     % electric fields (mat 1 ex and 2 ey) and magnetic fields (mat 3 hx and 4 hy)
    neff_JCM = zeros(2, N);                                                             % array for n_eff2 values
    guess_itr = guess;

    % solution for electric and magnetic fields
    for i = 1:N
        keys.alpha = alpha_t(i);                                                        % set twist rate for current itaration guess
        keys.guess = guess_itr;                                                         % set current as previous n_eff1 found,or initial guess for i==1
        results = jcmwave_solve('project.jcmp', keys);                                  % find modes with JCM
        cfbE = results{2};
        cfbH = results{3};
        amplitude_mode_1 = cfbE.field{1};
        amplitude_mode_2 = cfbE.field{2}; 
        EM_fields_mode_1(:,:,1,i) = amplitude_mode_1(:,:,1);                            % Ex mode 1
        EM_fields_mode_1(:,:,2,i) = amplitude_mode_1(:,:,2);                            % Ey mode 1
        EM_fields_mode_2(:,:,1,i) = amplitude_mode_2(:,:,1);                            % Ex mode 2
        EM_fields_mode_2(:,:,2,i) = amplitude_mode_2(:,:,2);                            % Ey mode 2
        amplitude_mode_1 = cfbH.field{1};
        amplitude_mode_2 = cfbH.field{2};
        EM_fields_mode_1(:,:,3,i) = amplitude_mode_1(:,:,1);                            % Hx mode 1
        EM_fields_mode_1(:,:,4,i) = amplitude_mode_1(:,:,2);                            % Hy mode 1
        EM_fields_mode_2(:,:,3,i) = amplitude_mode_2(:,:,1);                            % Hx mode 2
        EM_fields_mode_2(:,:,4,i) = amplitude_mode_2(:,:,2);                            % Hy mode 2
        neff_JCM(:,i) = (results{1}.eigenvalues.effective_refractive_index(1:2));       % get n_eff1
        guess_itr = real(neff_JCM(i));                                                  % set guess for next iteration
    end
    EM_fields = zeros(2,sizes_1,sizes_2,4,N);
    EM_fields(1,:,:,:,:) = EM_fields_mode_1;                                            % return mode 1 solution
    EM_fields(2,:,:,:,:) = EM_fields_mode_2;                                            % return mode 2 solution
end
