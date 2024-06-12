clc; clear; close all;
h = 0.1;

% Load system and discretize
f = load("params/sysid_matrices_v2.mat");
sys_cont = ss([-f.A(:,1), f.A(:,2:3)], f.B, f.C, f.D);
System = c2d(sys_cont, h, 'zoh');

nx = 3;
ny = 3;
nu = 1;
nlobj = nlmpc(nx, ny, nu);
nlobj.Ts = h;
nlobj.PredictionHorizon = 3;
nlobj.ControlHorizon = 3;

nlobj.Model.StateFcn = @stateFcn;
nlobj.Jacobian.StateFcn = @stateJacobian;
nlobj.Model.NumberOfParameters = 0;
nlobj.Model.IsContinuousTime = true;

nlobj.Weights.OutputVariables = [100, 1, 0.0001];
nlobj.Weights.ManipulatedVariables = 2;

% Initialize params
params = load("params/non_lin_fit_params.mat");
x0 = [0; 0; 0];
u0 = zeros(nu, 1);
a1 = params.a1_n;
a2 = params.a2_n;
a3 = params.a3_n;
a4 = params.a4_n;
b = params.b_n;
c1 = params.c1_n;
c2 = params.c2_n;
c3 = params.c3_n;
p0 = {a1, a2, a3, a4, b, c1, c2, c3};

validateFcns(nlobj, x0, u0);


function dx = stateFcn(x, u)
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

function [A, Bmv] = stateJacobian(x, u)
    a1 = 1.282554581553218;
    a2 = 5.019891844235762e+02;
    a3 = 0.044403086921773;
    a4 = 12.397016691241376;
    b = 0.011983696907579;
    c1 = -0.104591226430571;
    c2 = 8.418685618659971;
    c3 = -8.799973581572068;
    A = [                    0,                                                                 1,               0;
          (a4*cos(x(1)))/(b - 1),    a3/(b - 1) - c1*(c2*(tanh(c2*x(2))^2 - 1) - c3*(tanh(c3*x(2))^2 - 1)), -(a1*b)/(b - 1);
         -(a4*cos(x(1)))/(b - 1),    c1*(c2*(tanh(c2*x(2))^2 - 1) - c3*(tanh(c3*x(2))^2 - 1)) - a3/(b - 1),      a1/(b - 1)];

    Bmv = [0;
            (a2*b)/(b - 1);
            -a2/(b - 1)];
end
