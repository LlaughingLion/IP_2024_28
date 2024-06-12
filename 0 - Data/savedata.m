%data = [t, control_input.Data, theta.Data, phi_dot.Data, current.Data];
t = data_u.Time;
u = data_u.Data;
y = data_y.Data;
xhat = data_xhat.Data;

save("0 - Data/NLMPC/samp01pred2cont2.mat", "t", "u", "y", "xhat");