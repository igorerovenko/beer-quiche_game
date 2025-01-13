% This script substitutes random numeric values for parameters
% while respecting all relations between the parameters
% to check if mixed NE correspond to actual mixed strategies
% with positive weights in the Beer-Quiche game


%% Load solution data

mat_filename = 'NE_solutions.mat';

try
    data = load(mat_filename);
catch ME
    fprintf(2, 'Error loading .mat file: %s\n', ME.message);
    return;
end

if isfield(data, 'results')
    results = data.results;
else
    field_names = fieldnames(data);
    fprintf(2, 'Error: ''results'' field not found in %s.\n', mat_filename);
    fprintf(2, 'The .mat file contains the following fields: \n');
    disp(field_names);
    return;
end


%% Numerically simulate possible values of weights from solution data

% declare symbolic variables used in the solutions
syms s111 s112 s121 s122 s211 s212 s221 s222;
syms r111 r112 r121 r122 r211 r212 r221 r222;
syms x;
sym_vars = [s111 s112 s121 s122 s211 s212 s221 s222 ...
            r111 r112 r121 r122 r211 r212 r221 r222 x];

% prepare a file to store the results of the simulations
csv_filename = 'NE_analysis.csv';
header = {'Sender Strategy', 'Receiver Strategy', ...
    'Alphas All Positive', 'Betas All Positive', ...
    'Alphas and Betas All Positive'};
writetable(cell2table(header), csv_filename, 'WriteVariableNames', false);

% the number of possible NE
num_combinations = numel(results.combinations);
% number of simulations for each NE
num_iterations = 10000;

for i = 1:num_combinations  % Iterate through NE combinations
    combination = results.combinations{i};
    sender_strategy = combination.sender_strategy;
    receiver_strategy = combination.receiver_strategy;
    sender_solutions = combination.sender_solutions;
    receiver_solutions = combination.receiver_solutions;

    sender_fields = fieldnames(sender_solutions);
    receiver_fields = fieldnames(receiver_solutions);

    skip_combination = false;
    for j = 1:length(sender_fields)
        if isequal(sender_solutions.(sender_fields{j}), sym(0)) || ...
                isequal(size(sender_solutions.(sender_fields{j})),[0 1])
            skip_combination = true;
            break;
        end
    end
    if skip_combination
        continue;
    end
    for j = 1:length(receiver_fields)
        if isequal(receiver_solutions.(receiver_fields{j}), sym(0)) || ...
                isequal(size(receiver_solutions.(receiver_fields{j})), [0 1])
            skip_combination = true;
            break;
        end
    end
    if skip_combination
        continue;
    end

    % Initialize counters for this combination
    alphas_positive_count = 0;
    betas_positive_count = 0;
    alphas_betas_positive_count = 0;

    % Generate random values (uniform between 0 and 1) for parameters
    rand_values = rand(num_iterations, length(sym_vars));

    for iter = 1:num_iterations  % Iterate through simulations
        % Create numeric value substitution structure
        substitution_struct = struct;
        % Substitute random values for variables respecting relations
        s111_value = rand_values(iter, 1);
        s121_value = rand_values(iter, 2) * s111_value; % s111 > s121
        s112_value = rand_values(iter, 3) * s121_value; % s121 > s112
        s122_value = rand_values(iter, 4) * s112_value; % s112 > s122
        s221_value = rand_values(iter, 5);
        s211_value = rand_values(iter, 6) * s221_value; % s221 > s211
        s222_value = rand_values(iter, 7) * s211_value; % s211 > s222
        s212_value = rand_values(iter, 8) * s222_value; % s222 > s212
        r111_value = rand_values(iter, 9);
        r121_value = rand_values(iter, 10);
        r212_value = rand_values(iter, 11);
        r222_value = rand_values(iter, 12);
        r112_value = rand_values(iter, 13) * min([r111_value r121_value]);
        r122_value = rand_values(iter, 14) * min([r111_value r121_value]);
        r211_value = rand_values(iter, 15) * min([r212_value r222_value]);
        r221_value = rand_values(iter, 16) * min([r212_value r222_value]);
        x_value = rand_values(iter, 17);
        sym_values = [s111_value s112_value s121_value s122_value ...
            s211_value s212_value s221_value s222_value ...
            r111_value r112_value r121_value r122_value ...
            r211_value r212_value r221_value r222_value ...
            x_value];

        for k = 1:length(sym_vars)
            substitution_struct.(char(sym_vars(k))) = sym_values(k);
        end

        % Substitute random numeric values for symbols
        numeric_alphas = zeros(size(sender_fields));
        for j = 1:length(sender_fields)
            numeric_alphas(j) = ...
                double(subs(sender_solutions.(sender_fields{j}), ...
                substitution_struct));
        end

        numeric_betas = zeros(size(receiver_fields));
        for j = 1:length(receiver_fields)
            numeric_betas(j) = ...
                double(subs(receiver_solutions.(receiver_fields{j}), ...
                substitution_struct));
        end

        % Check conditions and increment counters
        if all(numeric_alphas > 0)
            alphas_positive_count = alphas_positive_count + 1;
        end
        if all(numeric_betas > 0)
            betas_positive_count = betas_positive_count + 1;
        end
        if all(numeric_alphas > 0) && all(numeric_betas > 0)
            alphas_betas_positive_count = alphas_betas_positive_count + 1;
        end
    end

    % Calculate proportions and record the results to the file
    alphas_positive_prop = alphas_positive_count / num_iterations;
    betas_positive_prop = betas_positive_count / num_iterations;
    alphas_betas_positive_prop = ...
        alphas_betas_positive_count / num_iterations;

    output_row = {mat2str(sender_strategy), ...
        mat2str(receiver_strategy), ...
        alphas_positive_prop, betas_positive_prop, ...
        alphas_betas_positive_prop};
    disp(output_row);
    writetable(cell2table(output_row), csv_filename, ...
        'WriteMode', 'append', 'WriteVariableNames', false);

end



%