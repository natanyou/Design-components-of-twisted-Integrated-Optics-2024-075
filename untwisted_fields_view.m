function null = untwisted_jcm_fields_view(EM_fields_mode_1, EM_fields_mode_2, clims)
    figure;
    subplot(421);
    imagesc(x,y,real(EM_fields_mode_1(:,:,1,1)),clims);
    title("Ex mode 1 non twisted");
    subplot(422);
    imagesc(x,y,real(EM_fields_mode_1(:,:,2,1)),clims);
    title("Ey mode 1 non twisted");
    subplot(423);
    imagesc(x,y,real(EM_fields_mode_2(:,:,1,1)),clims);
    title("Ex mode 2 non twisted");
    subplot(424);
    imagesc(x,y,real(EM_fields_mode_2(:,:,2,1)),clims);
    title("Ey mode 2 non twisted");
    
    subplot(425);
    imagesc(x,y,real(EM_fields_mode_1(:,:,3,1)));
    title("Hx mode 1 non twisted");
    subplot(426);
    imagesc(x,y,real(EM_fields_mode_1(:,:,4,1)));
    title("Hy mode 1 non twisted");
    subplot(427);
    imagesc(x,y,real(EM_fields_mode_2(:,:,3,1)));
    title("Hx mode 2 non twisted");
    subplot(428);
    imagesc(x,y,real(EM_fields_mode_2(:,:,4,1)));
    title("Hy mode 2 non twisted");
    null = 0;
end