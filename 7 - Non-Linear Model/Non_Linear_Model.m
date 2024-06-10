clc; clear; close all;

h = 0.05;

% Split training and validation data
data = load("0 - Data\sysid_closed_loop\20sec.mat");
ignoreSteps = 1/h;
Tend = 6000*h;
t_train = data.t(ignoreSteps:Tend/0.05,:);
u_train = reshape(data.u(:,:,ignoreSteps:Tend/0.05), length(t_train), 1);
y_train = data.y(ignoreSteps:Tend/0.05,:);
theta_train = y_train(:,1);
theta_dot_train = y_train(:,2);
phi_dot_train = y_train(:,3);
iddata_data_train = iddata([theta_train, phi_dot_train], u_train, h);

% Unpack the data and create a iddata struct

% Split training and validation data
data = load("0 - Data\sysid_closed_loop\10sec.mat");
ignoreSteps = 2.5/h;
Tend = 6000*h;
t_val = data.t(ignoreSteps:Tend/0.05,:);
u_val = reshape(data.u(:,:,ignoreSteps:Tend/0.05), length(t_val), 1);
y_val = data.y(ignoreSteps:Tend/0.05,:);
theta_val = y_val(:,1);
theta_dot_val = y_val(:,2);
phi_dot_val = y_val(:,3);
iddata_data_val = iddata([theta_val, phi_dot_val], u_val, h);


% Load estimated parameters

f = load("params/sysid_results_v2.mat");
a1 = 0;
a2 = 1;
a3 = 0;
a4 = -f.alpha_4/(f.beta-1);
a5 = f.alpha_3/(f.beta-1); 
a6 = -f.alpha_1*f.beta/(f.beta-1);
a7 = f.alpha_4/(f.beta-1);
a8 = -f.alpha_3/(f.beta-1);
a9 = -f.alpha_1/(f.beta-1);
b1 = 0;
b2 = f.alpha_2*f.beta/(f.beta-1);
b3 = -f.alpha_2/(f.beta-1);


parameters =  {'c_a1',a1;'c_a2',a2;'c_a3',a3;'c_a4',a4;'c_a5',a5;'c_a6',a6;'c_a7',a7;'c_a8',a8;'c_a9',a9;'c_b1',b1;'c_b2',b2;'c_b3',b3;};

f = load("params/sysid_matrices_v2.mat");
sys_cont = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);

% Do the identification
sys = idgrey(@flywheelpendfcn, parameters, 'c');

for i = 1:12
    sys.Structure.Parameters(i).Free = true;
end

sys_est = greyest(iddata_data_train, sys)


% Compare identified system with training data
x0_val = zeros([3,1]);
[simdata_train, ~, x_train] = lsim(sys_est, u_train, t_train,x0_val);
x0_val = zeros([3,1]);
simdata_val = lsim(sys_est, u_val, t_val, x0_val);

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


A = sys_est.A;
B = sys_est.B;
C = sys_est.C;
D = sys_est.D;
save("params/subspace_ID.mat", 'A', "B", "C", "D");



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   FUNCTIONS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A, B, C, D] = flywheelpendfcn(a1,a2,a3,a4,a5,a6,a7,a8,a9,b1,b2,b3,x0,Ts)

    A = [a1,a2,a3;
        a4,a5,a6;
        a7,a8,a9
        ];
    B = [b1;
        b2;
        b3];
    C = [1, 0, 0;
        0, 0, 1];
    D = zeros(2,1);

   
end