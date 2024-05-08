t = control_input.Time;
data = [t, control_input.Data, theta.Data, phi_dot.Data, current.Data];
save("sysid_data/prbs_pos_3_long.mat", "data");