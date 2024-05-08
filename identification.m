clc; clear; close all;

% Unpack the data and create a iddata struct
f = load("sysid_data/prbs_pos_2_ext.mat");
t = f.data(:,1);
u = f.data(:,2);
theta = f.data(:,3);
phi_dot = f.data(:,4);
iddata_data = iddata([theta, phi_dot], u, 0.05);

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
sys_est = greyest(iddata_data, sys)

% Compare identified system with training data
simdata = lsim(sys_est, u, t);
figure(); 
subplot(2,1,1); hold on;
plot(t, theta);
plot(t, simdata(:,1));
subplot(2,1,2); hold on;
plot(t, phi_dot);
plot(t, simdata(:,2));


% Format the results and save them
pars = getpvec(sys_est);
beta = pars(1);
alpha_1 = pars(2);
alpha_2 = pars(3);
alpha_3 = pars(4);
alpha_4 = pars(5);
covs = getcov(sys_est);
save("params/sysid_results.mat", 'beta', 'alpha_1', 'alpha_2', 'alpha_3', 'alpha_4', 'covs');


