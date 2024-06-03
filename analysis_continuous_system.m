clc; clear; close all;

% Load system 
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss(f.A, f.B, f.C, f.D);
sys_cont_unstable = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);
sys_disc = c2d(sys_cont, 0.05, 'zoh');
sys_disc_unstable = c2d(sys_cont_unstable, 0.05, 'zoh');

figure();
sigma(sys_cont);

figure();
bode(sys_cont);

figure();
margin(sys_cont(1,1));

figure();
margin(sys_cont(2,1));

figure();
rlocus(sys_cont(1,1));

figure();
rlocus(sys_cont(2,1));

figure();
pzmap(sys_cont);


figure();
sigma(sys_cont_unstable);

figure();
bode(sys_cont_unstable);

figure();
margin(sys_cont_unstable(1,1));

figure();
margin(sys_cont_unstable(2,1));

figure();
pzmap(sys_cont_unstable);