clc; clear; close all;
data = load("0 - Data\control_data\MPC_8.mat");
h = 0.05;

tstart = 0.55;
T = 60;

t = data.t(tstart/h+1:(tstart+T)/h) - data.t(tstart/h+1);
theta = data.y(tstart/h+1:(tstart+T)/h,1);
phidot = data.y(tstart/h+1:(tstart+T)/h,3);
u = data.u(tstart/h+1:(tstart+T)/h);

figure('Position', [10, 10, 810, 410]); hold on;
subplot(3,1,1); hold on;
stairs(t, theta);
yline(0, ":");
ylabel("$\theta$ (rad)", "Interpreter","latex", "FontSize", 13);
title("MPC control response ($N = 10$)", "Interpreter", "latex", "FontSize", 13);

subplot(3,1,2); hold on;
stairs(t, phidot);
yline(0, ":");
ylabel("$\dot{\phi}$ (rad/s)", "Interpreter","latex", "FontSize", 13);

subplot(3,1,3); hold on;
stairs(t, u, "Color","#D95319");
yline(0, ":");
ylabel("$u$", "Interpreter","latex", "FontSize", 13);
xlabel("$t$ (s)", "Interpreter","latex", "FontSize", 13);

tightfig;
saveas(gcf, "0 - Figures Liam/" + "MPC_8_ext" + ".pdf");