clc; clear; close all;

% Load system 
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss(f.A, f.B, f.C, f.D);
sys_cont_unstable = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);
sys_disc = c2d(sys_cont, 0.05, 'zoh');
sys_disc_unstable = c2d(sys_cont_unstable, 0.05, 'zoh');

unco = length(sys_disc.A) - rank(ctrb(sys_disc));
unco_2 = length(sys_disc_unstable.A) - rank(ctrb(sys_disc_unstable));
unob = length(sys_disc.A) - rank(obsv(sys_disc));
unob_2 = length(sys_disc_unstable.A) - rank(obsv(sys_disc_unstable));

pole(sys_disc)
pole(sys_disc_unstable)

% figure();
% bode(sys_disc);
% saveas(gcf, "0 - Figures Coen/" + "Discrete_bode_stab" + ".png");
% 
% figure();
% pzmap(sys_disc);
% saveas(gcf, "0 - Figures Coen/" + "Discrete_pzmap_stab" + ".png");
% 
% figure();
% bode(sys_disc_unstable);
% saveas(gcf, "0 - Figures Coen/" + "Discrete_bode_unstab" + ".png");
% 
% figure();
% pzmap(sys_disc_unstable);
% saveas(gcf, "0 - Figures Coen/" + "Discrete_pzmap_unstab" + ".png");

