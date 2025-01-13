% testing the script on known computations

global s111 s112 s121 s122 s211 s212 s221 s222 
global r111 r112 r121 r122 r211 r212 r221 r222 
global x alpha1 alpha2 alpha3 alpha4 beta1 beta2 beta3 beta4

% Define symbols for sender's payoffs
syms s111 s112 s121 s122 s211 s212 s221 s222
% Define symbols for receiver's payoffs
syms r111 r112 r121 r122 r211 r212 r221 r222
% Define the proportion of senders of type 1
syms x
% Define mixed strategy probabilities for sender
syms alpha1 alpha2 alpha3 alpha4
% Define mixed strategy probabilities for receiver
syms beta1 beta2 beta3 beta4

% Define the entries of the payoff matrix for the senders
a11 = s111*x + s222*(1-x);
a12 = s112*x + s222*(1-x);
a13 = s111*x + s221*(1-x);
a14 = s112*x + s221*(1-x);

a21 = s111*x + s211*(1-x);
a22 = s112*x + s212*(1-x);
a23 = s111*x + s211*(1-x);
a24 = s112*x + s212*(1-x);

a31 = s122*x + s222*(1-x);
a32 = s122*x + s222*(1-x);
a33 = s121*x + s221*(1-x);
a34 = s121*x + s221*(1-x);

a41 = s122*x + s211*(1-x);
a42 = s122*x + s212*(1-x);
a43 = s121*x + s211*(1-x);
a44 = s121*x + s212*(1-x);

% Define the payoff matrix S for the senders
S = [a11, a12, a13, a14;
     a21, a22, a23, a24;
     a31, a32, a33, a34;
     a41, a42, a43, a44];

% Define the entries of the payoff matrix for the receivers
b11 = r111*x + r222*(1-x);
b12 = r112*x + r222*(1-x);
b13 = r111*x + r221*(1-x);
b14 = r112*x + r221*(1-x);

b21 = r111*x + r211*(1-x);
b22 = r112*x + r212*(1-x);
b23 = r111*x + r211*(1-x);
b24 = r112*x + r212*(1-x);

b31 = r122*x + r222*(1-x);
b32 = r122*x + r222*(1-x);
b33 = r121*x + r221*(1-x);
b34 = r121*x + r221*(1-x);

b41 = r122*x + r211*(1-x);
b42 = r122*x + r212*(1-x);
b43 = r121*x + r211*(1-x);
b44 = r121*x + r212*(1-x);

% Define the R matrix for the receiver
R = [b11, b12, b13, b14;
     b21, b22, b23, b24;
     b31, b32, b33, b34;
     b41, b42, b43, b44];

% Define vectors alphas and betas corresponding to mixed strategies
alphas = [alpha1, alpha2, alpha3, alpha4];
betas = [beta1, beta2, beta3, beta4];

% Display matrices S and R for verification
disp('Sender''s Payoff Matrix (S):');
disp(S);

disp('Receiver''s Payoff Matrix (R):');
disp(R);

% Define the vectors of pure strategies used by senders
sender_strategies_used = [
    1, 1, 1, 0
];

% Define the vectors of pure strategies used by receivers
receiver_strategies_used = [
    1, 1, 0, 1
];

% Verify that all sender and receiver strategies have the correct length
expected_strategy_length = 4; % Each strategy should have 4 components

% Check sender strategies
for i = 1:size(sender_strategies_used, 1)
    assert(length(sender_strategies_used(i, :)) == expected_strategy_length, ...
        sprintf('Invalid sender strategy length: %s', mat2str(sender_strategies_used(i, :))));
end

% Check receiver strategies
for i = 1:size(receiver_strategies_used, 1)
    assert(length(receiver_strategies_used(i, :)) == expected_strategy_length, ...
        sprintf('Invalid receiver strategy length: %s', mat2str(receiver_strategies_used(i, :))));
end

% Store all possible combinations of receiver and sender strategies
strategy_combinations_used = cell(size(receiver_strategies_used, 1) * size(sender_strategies_used, 1), 2);
index = 1;
for i = 1:size(receiver_strategies_used, 1)
    for j = 1:size(sender_strategies_used, 1)
        strategy_combinations_used{index, 1} = receiver_strategies_used(i, :);
        strategy_combinations_used{index, 2} = sender_strategies_used(j, :);
        index = index + 1;
    end
end

% Display the total number of strategy combinations and verify them
disp(['Total strategy combinations: ', num2str(size(strategy_combinations_used, 1))]);
for i = 1:size(strategy_combinations_used, 1)
    receiver = strategy_combinations_used{i, 1};
    sender = strategy_combinations_used{i, 2};
    disp(['Combination ', num2str(i), ': Receiver - ', mat2str(receiver), ', Sender - ', mat2str(sender)]);
end

% Helper function to compute actual mixed strategies
function result = mixed_strategy(strategy_vector, symbols_vector)
    % Ensure both inputs are row vectors
    strategy_vector = reshape(strategy_vector, 1, []);
    symbols_vector = reshape(symbols_vector, 1, []);
    
    % Verify that the vectors have the same length
    if length(strategy_vector) ~= length(symbols_vector)
        error('Strategy and symbol vectors must have the same length.');
    end
    
    % Compute the mixed strategy by element-wise multiplication
    result = strategy_vector .* symbols_vector; % Element-wise multiplication
end

% Example: Actual mixed sender and receiver strategies for the first combination
sample_receiver_strategy = receiver_strategies_used(1, :); % 1st receiver strategy
sample_sender_strategy = sender_strategies_used(1, :);   % 1st sender strategy

% Assuming 'alphas' and 'betas' are row vectors already defined
actual_sender_strategy = mixed_strategy(sample_sender_strategy, alphas);
actual_receiver_strategy = mixed_strategy(sample_receiver_strategy, betas);

% Display the results
disp('Actual sender strategy:');
disp(actual_sender_strategy);

disp('Actual receiver strategy:');
disp(actual_receiver_strategy);

%%

% Initialize the structure to store results
results = struct();
results.combinations = {};

% Cycle through all 18 combinations
index = 1;
for i = 1:size(receiver_strategies_used, 1)
    for j = 1:size(sender_strategies_used, 1)
        receiver = receiver_strategies_used(i, :);
        sender = sender_strategies_used(j, :);
        
        % Get actual mixed strategies for sender and receiver
        actual_sender = mixed_strategy(sender, alphas);
        actual_receiver = mixed_strategy(receiver, betas);
        
        % Compute payoffs and solve for NE
        sender_payoffs = S * actual_receiver.';
        receiver_payoffs = (actual_sender * R).';
        unknowns_sender = actual_sender(sender==1);
        unknowns_receiver = actual_receiver(receiver==1);
        equations_sender = {};
        equations_receiver = {};
        equation_number = 1;
        for second_equation = 2:4
            if sender(second_equation) == 1
                equations_sender{equation_number} = sender_payoffs(1) - sender_payoffs(second_equation) == 0
            end
            if receiver(second_equation) == 1
                equations_receiver{equation_number} = receiver_payoffs(1) - receiver_payoffs(second_equation) == 0
            end
            equation_number = equation_number + 1;
        end
        equations_sender{equation_number} = sum(unknowns_receiver) == 1;
        equations_receiver{equation_number} = sum(unknowns_sender) == 1;
        
        try
            alphas_solution = solve(equations_receiver, unknowns_sender)
        catch
            alphas_solution = 'No solution';
        end

        try
            betas_solution = solve(equations_sender, unknowns_receiver)
        catch
            betas_solution = 'No solution';
        end
        
        disp(alphas_solution.alpha1)
        % disp(alphas_solution.alpha4)
        disp(betas_solution.beta1)
        % disp(betas_solution.beta4)

    end
end




%