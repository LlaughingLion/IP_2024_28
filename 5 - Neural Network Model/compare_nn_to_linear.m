clear; clc; close all;

% Raw data
data = load("0 - Data\sysid_closed_loop\20sec.mat");
ignoreSteps = 10;
Tend = 45;
t = data.t(ignoreSteps:Tend/0.05,:);
u = reshape(data.u(:,:,ignoreSteps:Tend/0.05), length(t), 1);
y = data.y(ignoreSteps:Tend/0.05,:);

% Linear identification
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);
System = c2d(sys_cont, 0.05, 'zoh');
simdata = lsim(System, u, t, y(1,1:3));


% Neural Network
net = importONNXNetwork("5 - Neural Network Model\Models\10sec.onnx","InputDataFormats",{'BC'},"OutputDataFormats",{'BC'});
%analyzeNetwork(net);

inputData = [u,y(:,1:3)];
outputData = zeros([size(inputData, 1), 3]);
outputData(1,:) = [0;0;0];
for i = 2:length(t)
    outputData(i,:) = predict(net, inputData(i,:));
end


figure(); 
subplot(2,1,1); hold on;
stairs(t, y(:,1));
%stairs(t, simdata(:,1));
stairs(t, outputData(:,1));
xlabel('$t$ (s)', "Interpreter","latex","FontSize",15);
ylabel('$\theta$ (rad)', "Interpreter","latex","FontSize",15)
legend("Measurements", "Linear", "Neural Net","Location","northwest","Orientation",	"horizontal","FontSize",6)

subplot(2,1,2); hold on;
stairs(t, y(:,3));
%stairs(t, simdata(:,2));
stairs(t, outputData(:,3));
xlabel('$t$ (s)', "Interpreter","latex","FontSize",15);
ylabel('$\dot \phi$ (rad)', "Interpreter","latex","FontSize",15)
legend("Measurements", "Linear", "Neural Net","Location","northwest","Orientation",	"horizontal","FontSize",6)
