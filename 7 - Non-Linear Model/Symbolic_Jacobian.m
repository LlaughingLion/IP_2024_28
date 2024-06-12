clc; clear; close all;
syms x1 x2 x3 u1 a1 a2 a3 a4 b c1 c2 c3 

dx = [x2;             
          a4/(b-1)*sin(x1) + a3/(b-1)*x2+c1*(tanh(c2*x2)-tanh(c3*x2)) - a1*b/(b-1)*x3 + a2*b/(b-1)*u1;   
         -a4/(b-1)*sin(x1) - a3/(b-1)*x2-c1*(tanh(c2*x2)-tanh(c3*x2)) + a1/(b-1)*x3 - a2/(b-1)*u1];

Jac_A = jacobian(dx,[x1,x2,x3]);
Jac_B = jacobian(dx,u1);
