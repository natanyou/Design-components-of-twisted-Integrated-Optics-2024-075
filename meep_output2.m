Ex_f = h5read("outputs/moebius-3x2-R20.h5","/spectrum/Ex");
Ey_f = h5read("outputs/moebius-3x2-R20.h5","/spectrum/Ey");
Ez_f = h5read("outputs/moebius-3x2-R20.h5","/spectrum/Ez");
x = h5read("outputs/moebius-3x2-R20.h5","/slice/x");
y = h5read("outputs/moebius-3x2-R20.h5","/slice/y");
z = h5read("outputs/moebius-3x2-R20.h5","/slice/z");
Ex_f_amp = squeeze(Ex_f.r)+1i*squeeze(Ex_f.i);
Ey_f_amp = squeeze(Ey_f.r)+1i*squeeze(Ey_f.i);
Ez_f_amp = squeeze(Ez_f.r)+1i*squeeze(Ez_f.i);
save('Ex_f.mat', 'Ex_f');
save('Ey_f.mat', 'Ey_f');
save('Ez_f.mat', 'Ez_f');
I = Ex_f_amp.*conj(Ex_f_amp)+Ey_f_amp.*conj(Ey_f_amp)+Ez_f_amp.*conj(Ez_f_amp);
f = linspace(1, 100, numel(I));
%%
figure;
plot(f,I);
