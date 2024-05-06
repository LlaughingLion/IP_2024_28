syms th(t) ph(t) Jd m M l L Jr g 

th_d = diff(th,t);
ph_d = diff(ph,t);
Kd = 0.5*Jd*(ph_d+th_d)^2 + 0.5*m*(L*th_d)^2;
Kr = 0.5*Jr*th_d^2;
Pd = -1*m*g*l*cos(th);
Pr = M*g*L*cos(th);

K = Kd+Kr;
P = Pd + Pr;

L = K-P;

lagr_1 = diff(diff(L,th_d),t) - diff(L,th);
lagr_2 = diff(diff(L,ph_d),t) - diff(L,ph);
