Ex = h5read("outputs/moebius-3x2-R20.h5","/slice/Ex");
Ey = h5read("outputs/moebius-3x2-R20.h5","/slice/Ey");
Ez = h5read("outputs/moebius-3x2-R20.h5","/slice/Ez");
x = h5read("outputs/moebius-3x2-R20.h5","/slice/x");
y = h5read("outputs/moebius-3x2-R20.h5","/slice/y");
z = h5read("outputs/moebius-3x2-R20.h5","/slice/z");
Ex_amp = squeeze(Ex.r)+1i*squeeze(Ex.i);
Ey_amp = squeeze(Ey.r)+1i*squeeze(Ey.i);
Ez_amp = squeeze(Ez.r)+1i*squeeze(Ez.i);
save('Ex.mat', 'Ex');
save('Ey.mat', 'Ey');
save('Ez.mat', 'Ez');
I = Ex_amp.*conj(Ex_amp)+Ey_amp.*conj(Ey_amp)+Ez_amp.*conj(Ez_amp);
% imagesc(squeeze(Ex.r(1,:,:)))
%%
figure;
radius = 20;
[~, idx_x] = min(abs(x - radius));
[~, idx_y] = min(abs(y - 0));
plot(squeeze(I(idx_x, idx_y,:)));
grid on;
%%


