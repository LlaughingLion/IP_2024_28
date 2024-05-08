function [A, B, C, D] = flywheelpendfcn(b, a1, a2, a3, a4, Ts)
    A = [0, 1, 0;
        a4/(b-1), a3/(b-1), -a1*b/(b-1);
        -a4/(b-1), -a3/(b-1), a1/(b-1);
        ];
    B = [0;
        a2*b/(b-1);
        -a2/(b-1)];
    C = [1, 0, 0;
        0, 0, 1];
    D = zeros(2,1);
end