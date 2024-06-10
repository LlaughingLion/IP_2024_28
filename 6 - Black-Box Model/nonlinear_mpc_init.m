clc; clear; close all;
h = 0.05;

nx = 3;
ny = 3;
nu = 1;
nlobj = nlmpc(nx, ny, nu);
nlobj.Ts = h;
nlobj.PredictionHorizon = 10;
nlobj.ControlHorizon = 10;

nlobj.Model.StateFcn = @stateFcn;
nlobj.Jacobian.StateFcn = @stateJacobian;
nlobj.Model.NumberOfParameters = 7;

nlobj.Weights.OutputVariables = [100, 1, 0.0001];
nlobj.Weights.ManipulatedVariables = 2;


x0 = [0; 0; 0];
u0 = zeros(nu, 1);
a1 = 0;
a2 = 0;
a3 = 0;
a4 = 0;
b = 0;
c1 = 0;
c2 = 0;
p0 = {a1, a2, a3, a4, b, c1, c2};

validateFcns(nlobj, x0, u0, [], p0);


function dx = stateFcn(x, u, a1, a2, a3, a4, b, c1, c2)
    dx = [x(2);
          a4/(b-1)*x(1) + a3/(b-1)*(x(2)+c1*tanh(c2*x(2))) - a1*b/(b-1)*x(3) + a2*b/(b-1)*u(1);
         -a4/(b-1)*x(1) - a3/(b-1)*(x(2)+c1*tanh(c2*x(2))) - a1*b/(b-1)*x(3) + a2*b/(b-1)*u(1)];
end

function [A, Bmv] = stateJacobian(x, u, a1, a2, a3, a4, b, c1, c2)
    A = zeros(3,3);
    Bmv = zeros(3,1);
end
