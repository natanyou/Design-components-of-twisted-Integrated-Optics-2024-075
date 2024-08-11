function [lambda_res,det_I_sub_T, minima_locs] =...
    find_res_wavelengths(lambda, lambda_guess,psi,n_H,n_V,l)

    T = zeros([numel(lambda) 2 2]);
    det_I_sub_T = zeros([numel(lambda) 1]);
    for i=1:numel(lambda)
        T(i,:,:) = calc_T(lambda(i),psi,n_H,n_V,l);
        det_I_sub_T(i) = det(eye(2)-squeeze(T(i,:,:)));
    end
    
    % find resonance wavelengths
    inverted_I_sub_T = -abs(det_I_sub_T);
    [minima_values, minima_locs] = findpeaks(inverted_I_sub_T);
    lambda_res = lambda(minima_locs);
end