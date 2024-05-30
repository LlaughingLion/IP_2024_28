t = data_u.Time;
%data = [t, control_input.Data, theta.Data, phi_dot.Data, current.Data];
y = data_y.Data;
xhat = data_xhat.Data;

save("0 - Data/control_data/MPC_7.mat", "t", "y", "xhat");