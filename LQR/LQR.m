clc; clear; close all;

h = 0.05;

%Continuous system
f = load("params/sysid_matrices_v1.mat");
A = f.A;
A = [-1*A(:,1),A(:,2:end)];
sys_cont = ss(A,f.B,f.C(1,:),f.D(1,:));

%Discretized system
sys_disc = c2d(sys_cont,h,'zoh');

Q = diag([100,0.01,0.01]);
R = 0.01;

K = dlqr(sys_disc.A,sys_disc.B,Q,R);

