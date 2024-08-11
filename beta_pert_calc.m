function beta_pert = beta_pert_calc(beta_non_twisted,alpha_t,N)
    beta_avg = ((beta_non_twisted(1)+beta_non_twisted(2))/2)*ones(1,N);             % beta_bar
    lambda_biref = beta_non_twisted(1)-beta_non_twisted(2);                         % lambda bi-refringence
    beta_pert = zeros(2,N);
    beta_pert(1,:) = beta_avg + 0.5*(((lambda_biref.^2)+4*(alpha_t.^2)).^0.5);
    beta_pert(2,:) = beta_avg - 0.5*(((lambda_biref.^2)+4*(alpha_t.^2)).^0.5); 
end