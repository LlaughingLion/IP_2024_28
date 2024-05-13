clc; clear; close all;

h = 0.05;

% Unpack the data and create a iddata struct
f = load("sysid_data/prbs_pos_2_long.mat");

% Split training and validation data
train_raw = f.data(6/h+1:80/h+1,:);
t_train = train_raw(:,1);
u_train = train_raw(:,2);
theta_train = train_raw(:,3);
phi_dot_train = train_raw(:,4);
iddata_data_train = iddata([theta_train, phi_dot_train], u_train, 0.05);

% Unpack the data and create a iddata struct
f = load("sysid_data/prbs_rand_1.mat");

val_raw = f.data(0/h+1:end,:);
t_val = val_raw(:,1);
u_val = val_raw(:,2);
theta_val = val_raw(:,3);
phi_dot_val = val_raw(:,4);
iddata_data_val = iddata([theta_val, phi_dot_val], u_val, 0.05);

% Load estimated parameters
f = load("params/simple_estimate_alphas.mat");
param_init = f.simple_estimate_alphas();
a1 = param_init(1);
a2 = param_init(2);
a3 = param_init(3);
a4 = param_init(4);

% Define guess for beta
b0 = 0.5;

% Do the identification
sys = idgrey(@flywheelpendfcn, {'beta',b0; 'alpha_1',a1; 'alpha_2',a2; 'alpha_3',a3; 'alpha_4',a4}, 'c');

sys.Structure.Parameters(2).Free = true;
sys.Structure.Parameters(3).Free = true;
sys.Structure.Parameters(4).Free = false;
sys.Structure.Parameters(5).Free = false;

sys_est = greyest(iddata_data_train, sys)

% Compare identified system with training data
[simdata_train, ~, x_train] = lsim(sys_est, u_train, t_train);
x0_val = [theta_val(1), x_train(end, 2), phi_dot_val(1)];
x0_val = [0,0,0];
simdata_val = lsim(sys_est, u_val, t_val, x0_val);

GOF_train = 100 * (1-goodnessOfFit(simdata_train, [theta_train, phi_dot_train], 'NRMSE'))
GOF_val = 100 * (1-goodnessOfFit(simdata_val, [theta_val, phi_dot_val], 'NRMSE'))

figure(); 
subplot(2,2,1); hold on;
plot(t_train, theta_train);
plot(t_train, simdata_train(:,1));
subplot(2,2,3); hold on;
plot(t_train, phi_dot_train);
plot(t_train, simdata_train(:,2));

subplot(2,2,2); hold on;
plot(t_val, theta_val);
plot(t_val, simdata_val(:,1));
subplot(2,2,4); hold on;
plot(t_val, phi_dot_val);
plot(t_val, simdata_val(:,2));


% Format the results and save them
pars = getpvec(sys_est);
beta = pars(1);
alpha_1 = pars(2);
alpha_2 = pars(3);
alpha_3 = pars(4);
alpha_4 = pars(5);
covs = getcov(sys_est);
save("params/sysid_results.mat", 'beta', 'alpha_1', 'alpha_2', 'alpha_3', 'alpha_4', 'covs');


A = sys_est.A;
B = sys_est.B;
C = sys_est.C;
D = sys_est.D;
save("params/sysid_matrices.mat", 'A', "B", "C", "D");



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   FUNCTIONS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A, B, C, D] = flywheelpendfcn(b, a1, a2, a3, a4, x0, Ts)
    A = [0, 1, 0;
        a4/(b-1), a3/(b-1), -a1*b/(b-1);
        -a4/(b-1), -a3/(b-1), a1/(b-1);
        ];
    B = [0;
        a2*b/(b-1);
        -a2/(b-1)];
    C = [1, 0, 0;
        0, 0, 1];
    D = zeros(2,1);
end