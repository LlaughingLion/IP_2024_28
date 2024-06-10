clc; clear; close all;

h = 0.05;

% Unpack the data and create a iddata struct
f = load("0 - Data/sysid_data_cal/prbs_pos_2_long.mat");

% Split training and validation data
set1_raw = f.data(6/h+1:80/h+1,:);
t_set1 = set1_raw(:,1)-5;
u_set1 = set1_raw(:,2);
theta_set1 = set1_raw(:,3);
phi_dot_set1 = set1_raw(:,4);
iddata_data_set1 = iddata([theta_set1, phi_dot_set1], u_set1, 0.05);


% Unpack the data and create a iddata struct
f = load("0 - Data/sysid_data_cal/prbs_rand_0_25.mat");

Tend = 120;
val_set2 = f.data(6/h+1:Tend/h,:);
t_set2 = val_set2(:,1)-6;
u_set2 = val_set2(:,2);
theta_set2 = val_set2(:,3);
phi_dot_set2 = val_set2(:,4);
iddata_data_set2= iddata([theta_set2, phi_dot_set2], u_set2, 0.05);

% Unpack the data and create a second iddata struct
f = load("0 - Data/sysid_data_cal/chirp_1.mat");

Tend = 40;
val_set3 = f.data(0/h+1:Tend/h,:);
t_val3 = val_set3(:,1);
u_val3 = val_set3(:,2);
theta_val3 = val_set3(:,3);
phi_dot_val3 = val_set3(:,4);
iddata_data_val3 = iddata([theta_val3, phi_dot_val3], u_val3, 0.05);

% Unpack the data and create a second iddata struct
f = load("0 - Data/sysid_data_cal/prbs_neg_2_ext.mat");

Tend = length(f.data)*h;
val_set4 = f.data(5/h+1:Tend/h,:);
t_val4 = val_set4(:,1)-5;
u_val4 = val_set4(:,2);
theta_val4 = val_set4(:,3);
phi_dot_val4 = val_set4(:,4);
iddata_data_val4 = iddata([theta_val4, phi_dot_val4], u_val4, 0.05);

% Unpack the data and create a second iddata struct
f = load("0 - Data/sysid_data_cal/prbs_both_2_long.mat");

Tend = length(f.data)*h;
val_set5 = f.data(6/h+1:118/h,:);
t_val5 = val_set5(:,1)-6;
u_val5 = val_set5(:,2);
theta_val5 = val_set5(:,3);
phi_dot_val5 = val_set5(:,4);
iddata_data_val5 = iddata([theta_val5, phi_dot_val5], u_val5, 0.05);

% Load estimated parameters
f = load("params/simple_estimate_alphas_v2.mat");
param_init = f.simple_estimate_alphas();
a1 = param_init(1);
a2 = param_init(2);
a3 = param_init(3);
a4 = param_init(4);

% Define guess for beta
b0 = 0.5;

DataSets = {iddata_data_set1,iddata_data_set2,iddata_data_val3,iddata_data_val4,iddata_data_val5};

GOF_matrix_theta = zeros(5);
GOF_matrix_phi_dot = zeros(5);

for train_i = 1:length(DataSets)
    % Do the identification
    sys = idgrey(@flywheelpendfcn, {'beta',b0; 'alpha_1',a1; 'alpha_2',a2; 'alpha_3',a3; 'alpha_4',a4}, 'c');
    
    sys.Structure.Parameters(2).Free = true;
    sys.Structure.Parameters(3).Free = true;
    sys.Structure.Parameters(4).Free = false;
    sys.Structure.Parameters(5).Free = false;
    
    sys_est = greyest(DataSets{train_i}, sys)
    for val_i = 1:length(DataSets)
        % Compare identified system with training data
        x0_val = [DataSets{val_i}.OutputData(1,1), 0, DataSets{val_i}.OutputData(1,2)];
        simdata_val = lsim(sys_est, DataSets{val_i}.InputData , DataSets{val_i}.SamplingInstants, x0_val);
        GOF_val = 100 * (1-goodnessOfFit(simdata_val, [DataSets{val_i}.OutputData(:,1), DataSets{val_i}.OutputData(:,2)], 'NRMSE'));
        GOF_matrix_theta(train_i,val_i)=GOF_val(1,1);
        GOF_matrix_phi_dot(train_i,val_i)=GOF_val(2,1);
    end
end
self_fit_GOF_theta = sum(GOF_matrix_theta.*eye(size(GOF_matrix_theta)),2);
self_fit_GOF_phi_dot = sum(GOF_matrix_phi_dot.*eye(size(GOF_matrix_phi_dot)),2);
% Step 1: Create a logical mask to exclude diagonal elements
mask = ~eye(size(GOF_matrix_theta));
% Step 2: Use the mask to sum the non-diagonal elements row-wise
rowSum_theta = sum(GOF_matrix_theta .* mask, 2);
rowSum_phi_dot = sum(GOF_matrix_phi_dot .* mask, 2);
% Step 3: Count the number of non-diagonal elements in each row
numNonDiagonal = sum(mask, 2);
% Step 4: Calculate the row-wise average excluding diagonal elements
val_avg_GOF_theta = rowSum_theta ./ numNonDiagonal
val_avg_GOF_phi_dot = rowSum_phi_dot ./ numNonDiagonal

latex(vpa(sym([self_fit_GOF_phi_dot,GOF_matrix_phi_dot,val_avg_GOF_phi_dot]),4))

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