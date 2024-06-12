% Initialization script that defines and computes all variables necessary
% for MPC, and stores them in the workspace

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sampling time
h = 0.05;

% Prediction horizon
Nhor = 5;

% LQR cost functions
Q = diag([100, 0.1, 0.0001]);
R = 2;

% State and input boundaries
xlim = [-0.35, 0.35;    % theta
        -10, 10;        % theta_dot
        -400, 400];     % phi_dot
ulim = [-1, 1];         % u

% Swingup Params
swingup_max = 1;
friction_compensation = 1.1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Offline Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load system and discretize
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);
%sys_cont = ss(f.A, f.B, f.C, f.D);
System = c2d(sys_cont, h, 'zoh');
Phi = System.A; Gamma = System.B;

% Compute LQR set for terminal set
model = LTISystem(System);
model.x.min = xlim(:,1);
model.x.max = xlim(:,2);
model.u.min = ulim(:,1);
model.u.max = ulim(:,2);
model.x.penalty = QuadFunction(Q);
model.u.penalty = QuadFunction(R);
Xf = model.LQRSet;
clc;

% Compute Riccati eq for terminal cost
P = idare(Phi, Gamma, Q, R);

% Compute prediction matrices T and S (used for x = T*x_0 + S*u)
[nx, nu] = size(Gamma);
T = zeros(nx*(Nhor+1), nx);
for k = 0:Nhor
    T(nx*k + 1 : nx*(k+1), :) = Phi^k;
end

S = zeros(nx*Nhor, nu*Nhor);
for k = 1:Nhor
    for l = 0:k-1
        S(nx*k + 1 : nx*(k+1), nu*l + 1 : nu*(l+1)) = Phi^(k-l-1) * Gamma;
    end
end

% Compute boundary matrices for all x and u in horizon
Ax = blkdiag(kron(eye(Nhor), [eye(nx); -eye(nx)]), Xf.A);
bx = [repmat([xlim(:,2); -xlim(:,1)], [Nhor, 1]); Xf.b];
Au = blkdiag(kron(eye(Nhor), [eye(nu); -eye(nu)]));
bu = [repmat([ulim(:,2); -ulim(:,1)], [Nhor, 1])];

% Use T and S to convert bounds on x and u to one single bound on u
A_full = [Ax*S; Au];

% Compute cost function matrices H and f(x0)
% Define Qbar and Rbar for cost of the entire horizon
Qbar = [kron(eye(Nhor), Q), zeros(nx*Nhor, nx); zeros(nx, nx*Nhor), P];
Rbar = kron(eye(Nhor), R);

% Define H and f as cost functions requiring only u as input: J(u) = u'Hu + u'x0'f
H = S' * Qbar * S + Rbar;
H = (H + H')/2;
f = S' * Qbar * T;

% Load a4 from params
a4 = load("params\sysid_results_v2.mat").alpha_4;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pack everything in structs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Weights.Q = Q;
Weights.R = R;
Weights.P = P;

Bounds.A = A_full;
Bounds.Ax = Ax;
Bounds.bx = bx;
Bounds.bu = bu;

PredMatrices.T = T;
PredMatrices.S = S;

CostMatrices.H = H;
CostMatrices.f = f;

Swingup.max = swingup_max;
Swingup.a4 = a4;
Swingup.friction_compensation = friction_compensation;

MPCparams.Bounds = Bounds;
MPCparams.PredMatrices = PredMatrices;
MPCparams.CostMatrices = CostMatrices;
MPCparams.Swingup = Swingup;

% Create the simulink object
bus_info = Simulink.Bus.createObject(MPCparams);
MPCparams_bus = evalin('base', bus_info.busName);

% Clear temp variables
clear f xlim ulim options obs_poles sys_cont Phi Gamma model nx nu ny k l Ax bx Au bu A_full Qbar Rbar Q R P S T H f Xf A_obs B_obs C_obs D_obs L Weights Bounds PredMatrices CostMatrices Nhor;
disp("=== Init complete! ===");

