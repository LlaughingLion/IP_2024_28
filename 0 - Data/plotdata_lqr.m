clc; clear; close all;
data = load("0 - Data\control_data\LQR_2.mat");
h = 0.05;

tstart = 0.25;
T = 11;

t = data.t(round(tstart/h)+1:round((tstart+T)/h)) - data.t(round(tstart/h)+1);
theta = data.y(tstart/h+1:(tstart+T)/h,1);
phidot = data.y(tstart/h+1:(tstart+T)/h,3);
u = data.u(tstart/h+1:(tstart+T)/h);

figure('Position', [10, 10, 810, 410]); hold on;
subplot(3,1,1); hold on;
stairs(t, theta);
yline(0, ":");
ylabel("$\theta$ (rad)", "Interpreter","latex", "FontSize", 13);
title("LQR control response", "Interpreter", "latex", "FontSize", 13);
xlim([0,T])

subplot(3,1,2); hold on;
stairs(t, phidot);
yline(0, ":");
ylabel("$\dot{\phi}$ (rad/s)", "Interpreter","latex", "FontSize", 13);
xlim([0,T])

subplot(3,1,3); hold on;
stairs(t, u, "Color","#D95319");
yline(0, ":");
ylabel("$u$", "Interpreter","latex", "FontSize", 13);
xlabel("$t$ (s)", "Interpreter","latex", "FontSize", 13);
xlim([0,T])
tightfig;
saveas(gcf, "0 - Figures Coen/" + "LQR_2_short" + ".pdf");