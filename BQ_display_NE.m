% This script displays symbolic formulas for the weights of pure strategies
% in the Nash equilibria of the Beer-Quiche game
% Not all symbolic formulas correspond to valid mixed strategies

% Load the data from the .mat file
mat_filename = 'NE_solutions.mat';
data = load(mat_filename);

% Extract the results structure
results = data.results;

% Iterate through all strategy combinations
num_combinations = numel(results.combinations);
for i = 1:num_combinations
    % Extract combination details
    combination = results.combinations{i};
    sender_strategy = combination.sender_strategy;
    receiver_strategy = combination.receiver_strategy;
    sender_solution = combination.sender_solutions;
    receiver_solution = combination.receiver_solutions;

    % Display the loaded data
    disp(['Combination ', num2str(i)]);
    disp(['Sender Strategy: ', mat2str(sender_strategy)]);
    disp(['Receiver Strategy: ', mat2str(receiver_strategy)]);
    disp('Sender Solution:');
    disp(sender_solution);
    disp('Receiver Solution:');
    disp(receiver_solution);

end


%