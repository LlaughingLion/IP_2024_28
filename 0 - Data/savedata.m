%data = [t, control_input.Data, theta.Data, phi_dot.Data, current.Data];
t = data_u.Time;
u = data_u.Data;
y = data_y.Data;
xhat = data_xhat.Data;
raw_theta = data_raw_theta.Data;

save("0 - Data/Swingup/swingup4.mat", "t", "u", "y", "xhat", "raw_theta");