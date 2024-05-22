h = 0.05;

% Weights
Q = diag([100, 0.1, 0.0001]);
R = 2;


% Load system and discretize
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);
%sys_cont = ss(f.A, f.B, f.C, f.D);
System = c2d(sys_cont, h, 'zoh');

% System for simulation
sys_sim = ss([-f.A(:,1), f.A(:,2:3)], [f.B,[0;1;0]], eye(3), zeros(3,2));
System_sim = c2d(sys_sim, h, 'zoh');

% LQR Gain
K = -dlqr(System.A, System.B, Q, R, []);

