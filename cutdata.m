data = load("raw_data/disk_test_-8.mat");
plot(data.data(1:200,4));
cut_data = data.data(2:95,:);
save("cut_data/disk_test_up_-8.mat", "cut_data");
plot(cut_data(:,4));