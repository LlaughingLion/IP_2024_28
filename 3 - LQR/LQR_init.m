h = 0.05;

% Weights
Q = diag([100, 0.1, 0.0001]);
R = 2;


% Load system and discretize
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);
%sys_cont = ss(f.A, f.B, f.C, f.D);
System = c2d(sys_cont, h, 'zoh');

Phi_del = [System.A, System.B; zeros(1,4)];
Gam_del = [0;0;0;1];
C_del = [System.C, zeros(2,1)];
D_del = zeros(2,1);
System_delayed = ss(Phi_del, Gam_del, C_del, D_del, h);

% System for simulation
sys_sim = ss([-f.A(:,1), f.A(:,2:3)], [f.B,[0;1;0]], eye(3), zeros(3,2));
System_sim = c2d(sys_sim, h, 'zoh');

% LQR Gain
K = -dlqr(System.A, System.B, Q, R, []);
%K = -dlqr(System_delayed.A, System_delayed.B, blkdiag(Q, 0), R, []);

% Plotting the Pole zero map of the LQR controlled system

LQR_contr_sys = ss(System.A+System.B*K,System.B,System.C,System.D,h);
figure();
pzmap(LQR_contr_sys);
saveas(gcf, "0 - Figures Coen/" + "Discrete_pzmap_LQR" + ".png");