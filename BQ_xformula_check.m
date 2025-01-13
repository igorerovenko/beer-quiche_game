% This script generates Figure 3 from the Beer-Quiche game paper

% flag whether to save graphs as EPS files
print_to_eps = false;

% generate one million random sets of values of the model parameters
% for each value of x between 0 and 1 with step 0.01
x_values = 0:0.01:1;
trials = 1000000;
values = rand(length(x_values), trials, 8);
results = zeros(length(x_values), 1);

for i = 1:length(x_values)
    x = x_values(i);
    valid_count = 0;
    % assign random values to the parameters while respecting relations
    for iter = 1:trials
        s111 = values(i, iter, 1);
        s121 = values(i, iter, 2) * s111; % s111 > s121
        s112 = values(i, iter, 3) * s121; % s121 > s112
        s122 = values(i, iter, 4) * s112; % s112 > s122
        s221 = values(i, iter, 5);
        s211 = values(i, iter, 6) * s221; % s221 > s211
        s222 = values(i, iter, 7) * s211; % s211 > s222
        s212 = values(i, iter, 8) * s222; % s222 > s212
        quantity = ((s211-s222) * (1-x) - (s111-s122) * x) / ...
            (((s211-s222) * (1-x) - (s111-s122) * x) + ...
            ((s221-s212) * (1-x) - (s121-s112) * x));
        if (quantity > 0) && (quantity < 1)
            valid_count = valid_count + 1;
        end
    end
    results(i) = valid_count / trials; % proportion of valid values
end

% visualize the simulation results
figure(1)
box on;
hold on;
plot(x_values, results, 'LineWidth', 2, 'Color', [0 0 0]);
ylim([0 1]);
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4, 3]);
set(gca, 'FontSize', 11)
ax = gca;
ax.TickLabelInterpreter = 'latex';
xlabel('Fraction $x$ of $T_1$ type Senders', 'Interpreter', 'latex')
ylabel('Probability of valid $\beta$', 'Interpreter', 'latex')

if print_to_eps
    print('formula325.eps', '-depsc')
end



%