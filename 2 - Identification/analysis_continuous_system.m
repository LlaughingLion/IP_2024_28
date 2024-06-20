clc; clear; close all;

% Load system 
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss(f.A, f.B, f.C, f.D);
sys_cont_unstable = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);
sys_disc = c2d(sys_cont, 0.05, 'zoh');
sys_disc_unstable = c2d(sys_cont_unstable, 0.05, 'zoh');



figure();
bode(sys_cont);

figure();
pzmap(sys_cont);


figure();
bode(sys_cont_unstable);

figure();
pzmap(sys_cont_unstable);