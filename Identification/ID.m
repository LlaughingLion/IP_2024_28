flywheelpendfcn(0.5,1,1,1,1)
sys = idgrey(flywheelpendfcn,[])
function [A, B, C, D] = flywheelpendfcn(beta1,a1,a2,a3,a4)
    A = [0, 1, 0;
        a4/(beta1-1), a3/(beta1-1), -1* a1 * beta1 /(beta1-1);
        -1*a4/(beta1-1), -1*a3/(beta1-1), a1*(beta1-1)];
    B = [0;
        a2*beta1/(beta1-1);
        -a2/(beta1-1)];
    C = [1,0,0;
        0,0,1;
        0,0,0];
    D = [0;
        0;
        1];
end