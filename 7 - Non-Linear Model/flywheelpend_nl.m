
function [dx,y] = flywheelpend_nl(t,x,u,a1,a2,a3,a4,b,c1,c2,varargin)
    % Output equation.
    y = [x(1);x(3)];     

    
    % State equations.
    dx = [x(2);             
          a4/(b-1)*sin(x(1)) + a3/(b-1)*(x(2)+c1*tanh(c2*x(2))) - a1*b/(b-1)*x(3) + a2*b/(b-1)*u(1);   
         -a4/(b-1)*sin(x(1)) - a3/(b-1)*(x(2)+c1*tanh(c2*x(2))) + a1/(b-1)*x(3) - a2/(b-1)*u(1)];
       
end