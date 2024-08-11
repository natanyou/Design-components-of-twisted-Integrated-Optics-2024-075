function [jones_mode] = jones_jcm_calc(EM_fields_mode_1,EM_fields_mode_2,xc,yc)
    N = size(EM_fields_mode_1,4);
    jones_mode = zeros(2,2,N);                                                  % johns vector for mode 1
    Ex = {EM_fields_mode_1(:,:,1,:), EM_fields_mode_2(:,:,1,:)};
    Ey = {EM_fields_mode_1(:,:,2,:), EM_fields_mode_2(:,:,2,:)};
    Hx = {EM_fields_mode_1(:,:,3,:), EM_fields_mode_2(:,:,3,:)};
    Hy = {EM_fields_mode_1(:,:,4,:), EM_fields_mode_2(:,:,4,:)};
    for i=1:N
        for j=1:2
            for k=1:2
                integrand = Ex{j}(:,:,:,i).*conj(Hy{k}(:,:,:,1))...
                -Ey{j}(:,:,:,i).*conj(Hx{k}(:,:,:,1));       % untwisted mode 1 cros twisted mode 1      
                jones_mode(j,k,i) = trapz(yc, trapz(xc,integrand));
            end
        end
    end
end