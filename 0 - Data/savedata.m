%data = [t, control_input.Data, theta.Data, phi_dot.Data, current.Data];
t = data_u.Time;
u = data_u.Data;
y = data_y.Data;
xhat = data_xhat.Data;

save("0 - Data/sysid_closed_loop/10sec.mat", "t", "u", "y", "xhat");