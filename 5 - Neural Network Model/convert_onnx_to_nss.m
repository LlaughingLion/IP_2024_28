clc; clear; close all;

% Neural Network
net = importONNXNetwork("5 - Neural Network Model\Models\10sec_norelu.onnx","InputDataFormats",{'BC'},"OutputDataFormats",{'BC'});


function x_next = stateTransitionFcn(x, u, net)
    input = [u, x];
    x_next = predict(net, input);
end
