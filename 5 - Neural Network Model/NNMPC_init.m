h = 0.05;

% Load system and discretize
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);
%sys_cont = ss(f.A, f.B, f.C, f.D);
System = c2d(sys_cont, h, 'zoh');

% Neural Network
net = importONNXNetwork("5 - Neural Network Model\Models\10sec_norelu.onnx","InputDataFormats",{'BC'},"OutputDataFormats",{'BC'});

nlobj = nlmpc(3, 3, 1);
nlobj.Ts = h;
nlobj.Model.StateFcn = @(x, u) stateTransitionFcn(x, u, net);
nlobj.PredictionHorizon = 2;
nlobj.ControlHorizon = 2;
nlobj.Weights.ManipulatedVariables = [2];
nlobj.Weights.OutputVariables = [100, 0.1, 0.0001];

nlobj.ManipulatedVariables(1).Min = -1;
nlobj.ManipulatedVariables(1).Max = 1;








disp("=== Init complete! ===");


function x_next = stateTransitionFcn(x, u, net)
    input = [u; x];
    x_next = predict(net, input')';
end


