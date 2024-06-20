clc; clear; close all;

x = -1:0.001:1;
a = 1;
b = 0.4;

figure('Position', [10, 10, 810, 310]); hold on;
subplot(1,2,1); hold on;
plot(x, x, "LineStyle","-","LineWidth",2);
plot(x, const_comp_fric(x, a, b), "LineStyle",":","LineWidth",2);
plot(x, return_to_linear(x, a, b), "LineStyle","--","LineWidth",2);
xline(0); yline(0);
legend(["Proportional", "Constant offset", "Local nonlinearity"], "Location","northwest");
ylabel("$f_\theta(\dot{\theta})$", "Interpreter","latex", "FontSize",15);
xlabel("$\dot{\theta}$", "Interpreter", "latex", "FontSize",15);
title("Proposed friction functions");
ylim([-1,1]);

subplot(1,2,2); hold on;
plot(x, x, "LineStyle","-","LineWidth",2);
plot(x, tanh_fric_neg(x, a, b, 20, -20), "LineStyle",":","LineWidth",2);
plot(x, tanh_fric(x, a, b, 20, 2), "LineStyle","--","LineWidth",2);
xline(0); yline(0);
legend(["Proportional", "c_3 < 0", "c_3 > 0"], "Location","northwest");
ylabel("$f_\theta(\dot{\theta})$", "Interpreter","latex", "FontSize",15);
xlabel("$\dot{\theta}$", "Interpreter", "latex", "FontSize",15);
title("Tanh friction function");
ylim([-1,1]);

tightfig;

saveas(gcf, "0 - Figures Liam/" + "tanh_friction_functions" + ".pdf");



function y = const_comp_fric(x, a, b)
    y = a*x + sign(x) * b;
end

function y = return_to_linear(x, a, b)
    y = zeros(1, length(x));
    for i = 1:length(x)
        if(abs(a*x(i)) < b)
            y(i) = sign(x(i)) * b;
        else
            y(i) = a*x(i);
        end
    end
end

function y = tanh_fric(x, a, b, c, d)
    y = a*x + b * (tanh(c*x) - tanh(d*x));
end

function y = tanh_fric_neg(x, a, b, c, d)
    y = a*x + b * .5 * (tanh(c*x) - tanh(d*x));
end