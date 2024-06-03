clc; clear; close all;
data = load("0 - Data\control_data\MPC_1.mat");
t = data.t;
theta = data.y(:,1);
phidot = data.y(:,3);
u = data.y(:,4);

tstart = 0;
tend = 3;

figure('Position', [10, 10, 810, 410]); hold on;
subplot(3,1,1); hold on;
stairs(t, theta);
xlim([tstart, tend]);
yline(0, ":");
ylabel("$\theta$ (rad)", "Interpreter","latex", "FontSize", 13);
title("MPC control response", "Interpreter", "latex", "FontSize", 13);

subplot(3,1,2); hold on;
stairs(t, phidot);
xlim([tstart, tend]);
yline(0, ":");
ylabel("$\dot{\phi}$ (rad/s)", "Interpreter","latex", "FontSize", 13);

subplot(3,1,3); hold on;
stairs(t, u);
xlim([tstart, tend]);
yline(0, ":");
ylabel("$u$", "Interpreter","latex", "FontSize", 13);
xlabel("$t$ (s)", "Interpreter","latex", "FontSize", 13);

tightfig;
saveas(gcf, "0 - Figures Liam/" + "MPC_3" + ".pdf");