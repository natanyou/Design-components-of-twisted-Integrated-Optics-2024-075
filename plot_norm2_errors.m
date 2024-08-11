function plot_norm2_errors(alpha_t ,stokes_jcm, stokes_pert)
    norm2_err = zeros(2, numel(alpha_t));
    norm2_mode = zeros(2, numel(alpha_t));
    for j=1:2
        for i=1:numel(alpha_t)
            norm2_err(j,i) = norm(stokes_jcm(:,i,j)-stokes_pert(:,i,j));
            norm2_mode(j,i) = norm(stokes_jcm(:,i,j));
        end
    end
    figure;
    hold on;
    grid on;
    for j=1:2
        plot(alpha_t,norm2_err(j,:)); 
        grid on;
    end
    title("Absolute norm 2 of stokes error vector")
    xlabel("Twist rate");
    ylabel('||s_{JCM} - s_{analytical}||');
    legend("Error for mode 1","Error for mode 2");
    
    % relative norm 2 err
    figure;
    hold on;
    grid on;
    for j=1:2
        plot(alpha_t,norm2_err(j,:)./norm2_mode(j,:)); 
    end
    title("Relative norm 2 of stokes error vector")
    xlabel("Twist rate");
    ylabel('$\displaystyle\frac{||s_{JCM} - s_{analytical}||}{||s_{JCM}||}$','interpreter','latex');
    legend("Error for mode 1","Error for mode 2");
    grid on;
end
