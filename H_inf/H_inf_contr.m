clc; clear; close all;

h = 0.05;

%Continuous system
f = load("params/sysid_matrices_v1.mat");
A = f.A;
A = [-1*A(:,1),A(:,2:end)];
sys_cont = ss(A,f.B,f.C(1,:),f.D(1,:));

%Discretized system
sys_disc = c2d(sys_cont,h,'zoh');
Phi = sys_disc.A;
Gamma = sys_disc.B;

z = tf('z',h);
s = tf('s');
Wu = 0.1*s/s;
Wp = (s/3+0.3*2*pi)/(s+0.3*2*pi*10^-4);

sys_cont.InputName = "u";
sys_cont.OutputName = "y";

Wp.InputName = "v";
Wp.OutputName = "z1";

Wu.InputName = "u";
Wu.OutputName = "z2";

S1 = sumblk("v = r-y",1);

T = connect(sys_cont,Wp,Wu,S1,['r',"u"],["z1","z2","v"]);

%HINFSYN optimisation
[K_3,gamma_3] = hinfsyn(T,1,1);
K_3.InputName = "v";
K_3.OutputName = "u";

t = 0:h:20;
u = zeros(1,length(t));
sys_K_3 = connect(sys_cont,K_3,S1,['r'],["y","u"]);
xinit = zeros(length(sys_K_3.A),1);
xinit(1,1) = 0.1;
lsim(sys_K_3,u,t,xinit);

figure
S_inv = (1 + sys_cont*K_3)^-1;
sigma(1/Wp,"--b",S_inv,"b")

figure
KS_inv = K_3/(1 + sys_cont*K_3);
sigma(1/Wu,"--b",KS_inv,"b")


