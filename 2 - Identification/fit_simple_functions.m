% Script to fit simplified model functions to the gathered data
clc; clear; close all;

% alpha_1 estimate
inputVals = [-8, -6, -4, -2, 2, 4, 6, 8]';
alpha_1_results = zeros(size(inputVals));
alpha_1_std_results = zeros(size(inputVals));
doPlot = [0,0,0,0,0,0,1,0];
for i = 1:length(inputVals)
    dataPath = "0 - Data/cut_data_cal/disk_test_" + inputVals(i) + ".mat";
    [alpha_1_results(i), alpha_1_std_results(i)] = fitDiskDecay(dataPath, doPlot(i));
end

% Weighted average
alpha_1 = weightedAverage(alpha_1_results, 1./alpha_1_std_results);
alpha_1_std = std(alpha_1_results);

% Display output
disp("=== alpha_1 ==="); disp(["value", "std"]);
disp([alpha_1_results, alpha_1_std_results]);
fprintf("Average: " + alpha_1 + "     std: " + alpha_1_std + " (" + round(alpha_1_std/alpha_1*100, 1) + " perc)\n\n");



% alpha_2 estimate
inputVals = [-8, -6, -4, -2, 2, 4, 6, 8]';
alpha_2_results = zeros(size(inputVals));
alpha_2_std_results = zeros(size(inputVals));
doPlot = [0,0,0,0,0,0,1,0];
for i = 1:length(inputVals)
    dataPath = "0 - Data/cut_data_cal/disk_test_up_" + inputVals(i) + ".mat";
    [alpha_2_results(i), alpha_2_std_results(i)] = fitDiskWindUp(dataPath, alpha_1, doPlot(i));
end

% Weighted average
alpha_2 = weightedAverage(alpha_2_results, 1./alpha_2_std_results);
alpha_2_std = std(alpha_2_results);

% Display output
disp("=== alpha_2 ==="); disp(["value", "std"]);
disp([alpha_2_results, alpha_2_std_results]);
fprintf("Average: " + alpha_2 + "     std: " + alpha_2_std + " (" + round(alpha_2_std/alpha_2*100, 1) + " perc)\n\n");



% alpha_3 and alpha_4 estimate
inputVals = ["-25_1", "-25_2", "-25_3", "-25_4", "25_1", "25_2", "25_3", "25_4"]';
alpha_3_results = zeros(size(inputVals));
alpha_3_std_results = zeros(size(inputVals));
alpha_4_results = zeros(size(inputVals));
alpha_4_std_results = zeros(size(inputVals));
doPlot = [0,0,1,0,0,0,0,0];
for i = 1:length(inputVals)
    dataPath = "0 - Data/cut_data_cal/pend_test_" + inputVals(i) + ".mat";
    [alpha_3_results(i), alpha_3_std_results(i), alpha_4_results(i), alpha_4_std_results(i)] = fitPendulumSwing(dataPath, doPlot(i));
end

% Weighted average
alpha_3 = weightedAverage(alpha_3_results, 1./alpha_3_std_results);
alpha_3_std = std(alpha_3_results);

% Display output
disp("=== alpha_3 ==="); disp(["value", "std"]);
disp([alpha_3_results, alpha_3_std_results]);
fprintf("Average: " + alpha_3 + "     std: " + alpha_3_std + " (" + round(alpha_3_std/alpha_3*100, 1) + " perc)\n\n");

% Weighted average
alpha_4 = weightedAverage(alpha_4_results, 1./alpha_4_std_results);
alpha_4_std = std(alpha_4_results);

% Display output
disp("=== alpha_4 ==="); disp(["value", "std"]);
disp([alpha_4_results, alpha_4_std_results]);
fprintf("Average: " + alpha_4 + "     std: " + alpha_4_std + " (" + round(alpha_4_std/alpha_4*100, 1) + " perc)\n\n");



% Save all params in a .mat file
simple_estimate_alphas = [alpha_1, alpha_2, alpha_3, alpha_4]';
%save("params/simple_estimate_alphas_v2.mat", "simple_estimate_alphas");



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   FUNCTIONS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function to fit the alpha_1 parameter
function [alpha_1, alpha_1_std] = fitDiskDecay(dataPath, doPlot)
    % Load and unpack the data
    data = load(dataPath);
    t = data.cut_data(:,1) - data.cut_data(1,1);
    phi_dot = data.cut_data(:,4);
    
    % Fit the function parameters
    fitfun = fittype(@(alpha_1, c_1, c_2, x) c_1 * exp(-alpha_1 * x) + c_2);
    startPoints = [1, phi_dot(1), phi_dot(end)];
    [fitted_curve, ~] = fit(t, phi_dot, fitfun, "Start", startPoints);

    % Extract the desired parameter
    coeffvals = coeffvalues(fitted_curve);
    confbounds = confint(fitted_curve);
    alpha_1 = coeffvals(1);
    alpha_1_std = (confbounds(2,1) - confbounds(1,1))/4;

    % Plot if desired
    if doPlot
        figure('Position', [10, 10, 810, 310]); hold on;
        scatter(t, phi_dot, 'b+');
        plot(fitted_curve, 'predobs');
        yline(0, ":");
        xlabel("$t$ (s)", "Interpreter","latex", "FontSize", 13);
        ylabel("$\dot{\phi}$ (rad/s)", "Interpreter","latex", "FontSize", 13);
        title("Fit of $C\exp (\alpha_1 t)$ on data", "Interpreter", "latex", "FontSize", 13);
        legend(["Data", "Fit", "Error bounds"]);
        tightfig;
        saveas(gcf, "0 - Figures/" + "fit_alpha1" + ".pdf");
    end
end

% Function to fit the alpha_2 parameter
function [alpha_2, alpha_2_std] = fitDiskWindUp(dataPath, alpha_1, doPlot)
    % Load and unpack the data
    data = load(dataPath);
    t = data.cut_data(:,1) - data.cut_data(1,1);
    phi_dot = data.cut_data(:,4);
    u = data.cut_data(1,2);
    
    % Fit the function parameters
    fitfun = fittype(@(b, c_1, x) c_1 * exp(-alpha_1 * x) + b);
    startPoints = [500/alpha_1*u, -500/alpha_1*u];
    [fitted_curve, ~] = fit(t, phi_dot, fitfun, "Start", startPoints);
    
    % Extract the desired parameter
    coeffvals = coeffvalues(fitted_curve);
    confbounds = confint(fitted_curve);
    alpha_2 = coeffvals(1) / u * alpha_1;
    alpha_2_std = (confbounds(2,1) - confbounds(1,1))/4 / abs(u) * alpha_1;

    % Plot if desired
    if doPlot
        figure('Position', [10, 10, 810, 310]); hold on;
        scatter(t, phi_dot, 'b+');
        plot(fitted_curve, 'predobs');
        yline(0, ":");
        xlabel("$t$ (s)", "Interpreter","latex", "FontSize", 13);
        ylabel("$\dot{\phi}$ (rad/s)", "Interpreter","latex", "FontSize", 13);
        title("Fit of $\frac{\alpha_2}{\alpha_1} u + C\exp (\alpha_1 t)$ on data", "Interpreter", "latex", "FontSize", 13);
        legend(["Data", "Fit", "Error bounds"]);
        tightfig;
        saveas(gcf, "0 - Figures/" + "fit_alpha2" + ".pdf");
    end
end

% Function to fit the alpha_3 and alpha_4 parameters
function [alpha_3, alpha_3_std, alpha_4, alpha_4_std] = fitPendulumSwing(dataPath, doPlot)
    % Load and unpack the data
    data = load(dataPath);
    t_full = data.cut_data(:,1) - data.cut_data(1,1);
    theta_full = data.cut_data(:,3);

    t = t_full(20:end) - t_full(20);
    theta = theta_full(20:end);

    % Fit the function parameters
    fitfun = fittype(@(beta, omega_star, A, d, x) exp(-beta * x) .* (A * sin(omega_star * x - d)));
    startPoints = [0.25, 3.5, -0.3, 0];
    [fitted_curve, ~] = fit(t, theta, fitfun, "Start", startPoints);
    
    % Extract the desired parameter
    coeffvals = coeffvalues(fitted_curve);
    beta = coeffvals(1);
    omega_star = coeffvals(2);
    alpha_3 = beta * 2;
    alpha_4 = omega_star^2 + beta^2;
    
    % Extract uncertainty
    confbounds = confint(fitted_curve);
    beta_std = (confbounds(2,1) - confbounds(1,1))/4;
    omega_star_std = (confbounds(2,2) - confbounds(1,2))/4;
    alpha_3_std = beta_std * 2;
    alpha_4_std = 2 * sqrt((omega_star*omega_star_std)^2 + (beta*beta_std)^2);

    % Plot if desired
    if doPlot
        figure('Position', [10, 10, 810, 310]); hold on;
        scatter(t, theta, 'b+');
        plot(fitted_curve, 'predobs');
        yline(0, ":");
        xlabel("$t$ (s)", "Interpreter","latex", "FontSize", 13);
        ylabel("$\theta$ (rad)", "Interpreter","latex", "FontSize", 13);
        title("Fit of $A\exp (-\beta t)\sin(\omega_0 t - d)$ on data", "Interpreter", "latex", "FontSize", 13);
        legend(["Data", "Fit", "Error bounds"]);
        tightfig;
        saveas(gcf, "0 - Figures/" + "fit_alpha34" + ".pdf");
    end
end

% Weighted avg function
function avg = weightedAverage(vals, weights)
    avg = sum(vals .* weights) / sum(weights);
end