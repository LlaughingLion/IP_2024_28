t = control_input.Time;
data = [t, control_input.Data, theta.Data, phi_dot.Data, current.Data];
%save("sysid_data_cal/prbs_rand_1_25.mat", "data");