clc; clear; close all;

sys = load('params/sysid_matrices.mat');

% Linearization along unstable eq.
sys.A = [-sys.A(:,1), sys.A(:,2:3)];

sys_ss = ss(sys.A,sys.B,sys.C,sys.D);

bode(sys_ss);

% PID values
Kp = 1;
Ki = 1;
Kd = 1;
tau = 0.1;

s = tf('s');

PID = ss(Kp + Ki/s + (Kd*s)/(s+tau));



