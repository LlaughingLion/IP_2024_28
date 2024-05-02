data = load("cut_data/disk_test_8.mat");


inputVals = [-8, -6, -4, -2, 2, 4, 6, 8]';

alpha_1_results = zeros(size(inputVals));
for i = 1:length(inputVals)
    dataPath = "cut_data/disk_test_" + inputVals(i) + ".mat";
    disp(dataPath);
    data = load(dataPath);
    alpha_1_results(i) = fitDiskTest(data, true);
end


disp(alpha_1_results);
alpha_1 = mean(alpha_1_results);
disp(alpha_1);


function alpha_1 = fitDiskTest(data, doPlot)
    t = data.cut_data(:,1) - data.cut_data(1,1);
    phi_dot = data.cut_data(:,4);
    
    startPoints = [1, phi_dot(1),phi_dot(end)];
    fitfun = fittype(@(alpha_1, c_1, c_2, x) c_1 * exp(-alpha_1 * x) + c_2);
    [fitted_curve, ~] = fit(t, phi_dot, fitfun,"Start", startPoints);
    coeffvals = coeffvalues(fitted_curve);
    alpha_1 = coeffvals(1);

    if doPlot
        figure(); hold on;
        scatter(t, phi_dot, 'r+');
        plot(t,fitted_curve(t));
    end
end