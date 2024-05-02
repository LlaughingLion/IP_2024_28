t = control_input.Time;
data = [t, control_input.Data, theta.Data, phi_dot.Data, current.Data];
save("data/disk_test_-8.mat", "data");