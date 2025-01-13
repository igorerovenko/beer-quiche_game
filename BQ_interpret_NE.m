% This script interprets Nash equlibria from the general signaling game 
% in the context of specific payoffs for the Beer-Quiche game


%% Set up

% flag whether to save graphs as EPS files
print_to_eps = false;

% define specific payoffs for the Beer-Quiche game as shown in Figure 1
s111 = 3;
s112 = 1;
s121 = 2;
s122 = 0;

s211 = 2;
s212 = 0;
s221 = 3;
s222 = 1;

r111 = 1;
r112 = 0;
r121 = 1;
r122 = 0;

r211 = 0;
r212 = 1;
r221 = 0;
r222 = 1;


%% Investigate the mixture of S1 and S2 versus the mixture of R1 and R2

% quantity for formula (3.1)
x31 = (r212 - r211) / ((r212 - r211) + (r111 - r112));
disp(['formula (3.1) quantity is ', num2str(x31)])

% quantity for formula (3.2)
x32 = (r222 - r221) / ((r222 - r221) + (r121 - r122));
disp(['formula (3.2) quantity is ', num2str(x31)])

% quantity for formula (3.16), it depends on x
% for this NE, x should be less than x31
x_values_316 = 0:0.01:x31;
alpha316 = 1 - x_values_316 ./ (1 - x_values_316) ...
    * (r111 - r112) / (r212 - r211);
% visualize the results
figure(1)
box on;
hold on;
plot(x_values_316, alpha316, 'LineWidth', 2, 'Color', [0 0 0]);
ylim([0 1]);
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4, 3]);
set(gca, 'FontSize', 11)
ax = gca;
ax.TickLabelInterpreter = 'latex';
xlabel('Fraction $x$ of surly visitors', 'Interpreter', 'latex')
ylabel(['Proportion $\alpha$ of strategy $S_1$'], 'Interpreter', 'latex')

if print_to_eps
    print('formula316.eps', '-depsc')
end

% quantity for formula (3.20)
beta320 = (s222 - s212) / (s211 - s212);
disp(['value of beta given by formula (3.20) is ', num2str(beta320)])


%% Investigate S3 versus the mixture of R3 and R4

% quantity for formula (3.7)
beta37 = (s111 - s121) / (s111 - s112);
disp(['minimum value of beta given by formula (3.7) is ', num2str(beta37)])


%% Investigate the mixture of S1 and S4 versus the mixture of R1 and R4

% small x formula (3.30)
x330 = (s211 - s222) / ((s211 - s222) + (s111 - s122));
disp(['upper bound on x from formula (3.30) is ', num2str(x330)])
% large x formula (3.31)
x331 = (s221 - s212) / ((s221 - s212) + (s121 - s112));
disp(['lower bound on x from formula (3.31) is ', num2str(x331)])

% beta value from formula (3.27)
x_values = 0:0.01:1;
beta327 = ((s211-s222)*(1-x_values) - (s111-s122)*x_values) ./ ...
    ((s211-s222)*(1-x_values) - (s111-s122)*x_values + ...
    (s221-s212)*(1-x_values) - (s121-s112)*x_values);
% alpha value from formula (3.35)
alpha335 = ((r111-r112)*x_values + (r222-r221)*(1-x_values)) ./ ...
    ((r111-r112+r121-r122)*x_values + (r222-r221+r212-r211)*(1-x_values));
% this value is equal to 0.5 regardless of x

% visualize the results
figure(2)
box on;
hold on;
plot(x_values, beta327, 'LineWidth', 2, 'Color', [0 0 0]);
ylim([0 1]);
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4, 3]);
set(gca, 'FontSize', 11)
ax = gca;
ax.TickLabelInterpreter = 'latex';
xlabel('Fraction $x$ of surly visitors', 'Interpreter', 'latex')
ylabel('Proportion $\beta$ of strategy $R_4$', 'Interpreter', 'latex')

if print_to_eps
    print('formula327.eps', '-depsc')
end



%