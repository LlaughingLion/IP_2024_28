clc; clear; close all;

h = 0.05;

% Unpack the data and create a iddata struct
f = load("0 - Data/sysid_data_cal/prbs_pos_2_long.mat");

% Split training and validation data
train_raw = f.data(6/h+1:80/h+1,:);
t_train = train_raw(:,1)-5;
u_train = train_raw(:,2);
theta_train = train_raw(:,3);
phi_dot_train = train_raw(:,4);
iddata_data_train = iddata([theta_train, phi_dot_train], u_train, 0.05,'Name','Two tanks');

% Unpack the data and create a iddata struct
f = load("0 - Data/sysid_data_cal/prbs_rand_0_25.mat");

Tend = 120;
val_raw = f.data(6/h+1:Tend/h,:);
t_val = val_raw(:,1)-6;
u_val = val_raw(:,2);
theta_val = val_raw(:,3);
phi_dot_val = val_raw(:,4);
iddata_data_val = iddata([theta_val, phi_dot_val], u_val, 0.05);


Order = [2 1 3];
f = load("params/sysid_results_v2.mat");
a1 = f.alpha_1;
a2 = f.alpha_2;
a3 = f.alpha_3;
a4 = f.alpha_4;

% Define guess for beta
b0 = f.beta;
c1 = -0.3;
c2 = 5;
c3 = -10;

Parameters = {a1;a2;a3;a4;b0;c1;c2;c3};


InitialStates = [0; 0; 0];

Ts = 0;

nlgr = idnlgrey('flywheelpend_nl',Order, Parameters,InitialStates,Ts,Name="Two tanks");

nlgr.Parameters(1).Fixed = true;
nlgr.Parameters(2).Fixed = true;
nlgr.Parameters(4).Fixed = true;


opt = nlgreyestOptions;
opt.SearchMethod = 'gna';
sys_est = nlgreyest(iddata_data_train, nlgr,opt);
[a1_n,a2_n,a3_n,a4_n,b_n,c1_n,c2_n,c3_n] = sys_est.Parameters.Value;

% Compare identified system with training data
x0_val = zeros([3,1]);
[simdata_train, ~, x_train] = sim(sys_est, u_train);
x0_val = zeros([3,1]);
simdata_val = sim(sys_est, u_val);

GOF_train = 100 * (1-goodnessOfFit(simdata_train, [theta_train,phi_dot_train], 'NRMSE'))
GOF_val = 100 * (1-goodnessOfFit(simdata_val, [theta_val,phi_dot_val], 'NRMSE'))

figure()


subplot(2,1,1); hold on;
plot(t_train, theta_train);
plot(t_train, simdata_train(:,1));
xlim([0,75]);
xlabel('$t$ (s)', "Interpreter","latex","FontSize",15);
ylabel('$\theta$ (rad)', "Interpreter","latex","FontSize",15)
legend("Training data", "Simulation data","Location","northwest","Orientation",	"horizontal","FontSize",6)
subplot(2,1,2); hold on;
plot(t_train, phi_dot_train);
plot(t_train, simdata_train(:,2));
xlim([0,75]);
xlabel('$t$ (s)', "Interpreter","latex","FontSize",15);
ylabel('$\dot \phi$ (rad)', "Interpreter","latex","FontSize",15)
legend("Training data", "Simulation data","Location","northwest","Orientation",	"horizontal","FontSize",6)
sgtitle("Training data and model prediction")
% exportgraphics(gcf,'0-Figures\Training data and model prediction.pdf') 
% % saveas(gcf,'0-Figures\Training data and model prediction.pdf')

% figure(); 
% subplot(2,1,1); hold on;
% plot(t_val, theta_val);
% plot(t_val, simdata_val(:,1));
% xlim([0,112])
% xlabel('$t$ (s)', "Interpreter","latex","FontSize",15);
% ylabel('$\theta$ (rad)', "Interpreter","latex","FontSize",15)
% legend("Validation data", "Simulation data","Location","northwest","Orientation",	"horizontal","FontSize",6)
% 
% subplot(2,1,2); hold on;
% plot(t_val, phi_dot_val);
% plot(t_val, simdata_val(:,2));
% xlim([0,112])
% xlabel('$t$ (s)', "Interpreter","latex","FontSize",15);
% ylabel('$\dot \phi$ (rad)', "Interpreter","latex","FontSize",15)
% legend("Validation data", "Simulation data","Location","northwest","Orientation",	"horizontal","FontSize",6)
% 
% sgtitle("PRBS validation data and model prediction")
% exportgraphics(gcf,'0 - Figures Coen\PRBS validation data and model prediction.pdf')


% Format the results and save them
% pars = getpvec(sys_est);
% beta = pars(1);
% alpha_1 = pars(2);
% alpha_2 = pars(3);
% alpha_3 = pars(4);
% alpha_4 = pars(5);
% covs = getcov(sys_est);
%save("params/sysid_results_v2.mat", 'beta', 'alpha_1', 'alpha_2', 'alpha_3', 'alpha_4', 'covs');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   FUNCTIONS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
