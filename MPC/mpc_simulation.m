clc; close all;

% Initial condition
x0 = [0.1; 0; 0];

% Simulation time
T = 2.5;
Nsim = T/h;
t = 0:h:T;

% Include MPC folder
addpath("MPC");

% Simulation loop
x = zeros(3, Nsim+1);
x(:, 1) = x0;
x_obs = zeros(3, Nsim);
u = zeros(1,Nsim);
for k = 1:Nsim
    u(k) = mpc_controller(x_obs(:,k), MPCparams);

    x(:,k+1) = System.A * x(:,k) + System.B * u(k);
    x_obs(:,k+1) = LBGobs.A * x_obs(:,k) + LBGobs.B * [u(k); System.C * x(:,k)];
end


% Plot
figure();
ylabels = ["\theta", "dot(\theta)", "\phi"];
for k = 1:3
    subplot(4, 1, k); hold on;
    stairs(t, x(k,:));
    stairs(t, x_obs(k,:));
    yline(0, ":");
    ylabel(ylabels(k));
    if k == 1
        title("MPC");
    end
    if k == 3
        xlabel("t (sec)");
        legend(["True state", "Observed state"], Location="southeast");
    end
end

subplot(4,1,4); hold on;
stairs(t(1:end-1), u);
ylabel("u");