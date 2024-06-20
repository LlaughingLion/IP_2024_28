clear; clc; close all;

% Raw data
data = load("0 - Data\sysid_closed_loop\20sec.mat");
ignoreSteps = 10;
Tend = 300;
t = data.t(ignoreSteps:Tend/0.05,:);
u = reshape(data.u(:,:,ignoreSteps:Tend/0.05), length(t), 1);
y = data.y(ignoreSteps:Tend/0.05,:);

% Linear identification
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);
System = c2d(sys_cont, 0.05, 'zoh');
simdata = lsim(System, u, t, y(1,1:3));

% Nonlinear identification
f = load("params/idgrey_obj.mat");
sys_est = f.sys_est;
simdata_nonlin = sim(sys_est, u);


% Neural Network
net = importONNXNetwork("5 - Neural Network Model\Models\10sec_norelu.onnx","InputDataFormats",{'BC'},"OutputDataFormats",{'BC'});
%analyzeNetwork(net);

inputData = [u,y(:,1:3)];
outputData = zeros([size(inputData, 1), 3]);
outputData(1,:) = [0;0;0];
for i = 2:length(t)
    input = [u(i), outputData(i-1,:)];
    outputData(i,:) = predict(net, input);
end


GOF_nn = 100 * (1-goodnessOfFit(y(:,[1,3]), outputData(:,[1,3]), 'NRMSE'))
GOF_nonlin = 100 * (1-goodnessOfFit(y(:,[1,3]), simdata_nonlin, 'NRMSE'))


Tplot_end = 100;

figure('Position', [10, 10, 810, 410]); hold on;
subplot(2,1,1); hold on;
stairs(t(1:Tplot_end/0.05), y(1:Tplot_end/0.05,1));
stairs(t(1:Tplot_end/0.05), simdata_nonlin(1:Tplot_end/0.05,1));
stairs(t(1:Tplot_end/0.05), outputData(1:Tplot_end/0.05,1));
xlabel('$t$ (s)', "Interpreter","latex","FontSize",15);
ylabel('$\theta$ (rad)', "Interpreter","latex","FontSize",15)
legend("Measurements", "Nonlinear", "Neural Net","Location","northwest","Orientation",	"horizontal","FontSize",6)
title("Nonlinear Model vs Neural Network")

subplot(2,1,2); hold on;
stairs(t(1:Tplot_end/0.05), y(1:Tplot_end/0.05,3));
stairs(t(1:Tplot_end/0.05), simdata_nonlin(1:Tplot_end/0.05,2));
stairs(t(1:Tplot_end/0.05), outputData(1:Tplot_end/0.05,3));
xlabel('$t$ (s)', "Interpreter","latex","FontSize",15);
ylabel('$\dot \phi$ (rad)', "Interpreter","latex","FontSize",15)
legend("Measurements", "Nonlinear", "Neural Net","Location","northwest","Orientation",	"horizontal","FontSize",6)

tightfig;
saveas(gcf, "0 - Figures Liam/" + "comp_nonlin_nn" + ".pdf");




function dx = nonlin_flywheel_pend(x, u)
    a1 = 1.282554581553218;
    a2 = 5.019891844235762e+02;
    a3 = 0.044403086921773;
    a4 = 12.397016691241376;
    b = 0.011983696907579;
    c1 = -0.104591226430571;
    c2 = 8.418685618659971;
    c3 = -8.799973581572068;
    dx = [x(2);
          a4/(b-1)*x(1) + a3/(b-1)*x(2) + c1*(tanh(c2*x(2)) - tanh(c3*x(2))) - a1*b/(b-1)*x(3) + a2*b/(b-1)*u(1);
         -a4/(b-1)*x(1) - a3/(b-1)*x(2) - c1*(tanh(c2*x(2)) - tanh(c3*x(2))) + a1*b/(b-1)*x(3) - a2/(b-1)*u(1)];
end