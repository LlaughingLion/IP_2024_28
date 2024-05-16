h = 0.05;

% Weights
Q = diag([100, 0.1, 0.1]);
R = 1;


% Load system and discretize
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss(f.A, f.B, f.C, f.D);
System = c2d(sys_cont, h, 'zoh');

K = -dlqr(System.A, System.B, Q, R, []);

