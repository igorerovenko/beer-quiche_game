% This script illustrates why the pairing consisting of a mixture
% of S1 and S4 playing against a mixture of R1 and R4
% is not a Nash equilibrium for the Beer-Quiche game

function BQ_investigate_S1S4R1R4

    print_to_eps = false;

    % define the Beer-Quiche game payoff values as in Figure 1
    s111 = 3;
    s112 = 1;
    s121 = 2;
    s122 = 0;
    
    s211 = 2;
    s212 = 0;
    s221 = 3;
    s222 = 1;
    
    % BQ_interpret_NE script showed that alpha doesn't depend on these
    % r111 = 1;
    % r112 = 0;
    % r121 = 1;
    % r122 = 0;
    
    % r211 = 0;
    % r212 = 1;
    % r221 = 0;
    % r222 = 1;

    % let's check if S2 does better than S1+S4 against R1+R4 for x small
    % define sender strategies
    % we already know alpha = 0.5 for beer-quiche game payoffs
    alpha = 0.5;

    % the case when x is small
    % define small values of x
    x_small = 0:0.01:0.25;

    % compute payoff matrix S for senders
    S_small = zeros(4, 4, length(x_small));
    for i = 1:length(x_small)
        [a11, a12, a13, a14, a21, a22, a23, a24, ...
            a31, a32, a33, a34, a41, a42, a43, a44] = ...
            compute_payoffs_S(s111, s112, s121, s122, ...
            s211, s212, s221, s222, x_small(i));
        S_small(:, :, i) = [a11, a12, a13, a14;
                     a21, a22, a23, a24;
                     a31, a32, a33, a34;
                     a41, a42, a43, a44];
    end

    % define receiver strategies
    beta_small = ((s211-s222)*(1-x_small) - (s111-s122)*x_small) ./ ...
        ((s211-s222)*(1-x_small) - (s111-s122)*x_small + ...
        (s221-s212)*(1-x_small) - (s121-s112)*x_small);

    % compute payoffs to senders playing a mixture of S1 and S4
    sender_payoffs_small = zeros(1, length(x_small));
    for i = 1:length(x_small)
        sender_payoffs_small(1, i) = [1-alpha, 0, 0, alpha] * ...
            S_small(:, :, i) * [1-beta_small(i); 0; 0; beta_small(i)];
            
    end
    
    % compute payoffs to senders playing S2
    alt_sender_payoffs_small = zeros(1, length(x_small));
    for i = 1:length(x_small)
        alt_sender_payoffs_small(1, i) = [0, 1, 0, 0] * ...
            S_small(:, :, i) * [1-beta_small(i); 0; 0; beta_small(i)];
            
    end

    % visualize the results
    figure(1)
    box on;
    hold on;
    plot(x_small, sender_payoffs_small, 'LineWidth', 2, ...
        'LineStyle', '--', 'Color', [0 0 0]);
    plot(x_small, alt_sender_payoffs_small, 'LineWidth', 2, ...
        'Color', [0 0 0]);
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4, 3]);
    set(gca, 'FontSize', 11)
    ylim([1.4 2.4]);
    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    xlabel('Fraction $x$ of surly visitors', 'Interpreter', 'latex')
    ylabel('Payoff to visitors', 'Interpreter', 'latex')

    if print_to_eps
        print('bqxsmall.eps', '-depsc')
    end


    % the case when x is large
    % define large values of x
    x_large = 0.75:0.01:1;

    % compute payoff matrix S for senders
    S_large = zeros(4, 4, length(x_large));
    for i = 1:length(x_large)
        [a11, a12, a13, a14, a21, a22, a23, a24, ...
            a31, a32, a33, a34, a41, a42, a43, a44] = ...
            compute_payoffs_S(s111, s112, s121, s122, ...
            s211, s212, s221, s222, x_large(i));
        S_large(:, :, i) = [a11, a12, a13, a14;
                     a21, a22, a23, a24;
                     a31, a32, a33, a34;
                     a41, a42, a43, a44];
    end

    % define receiver strategies
    beta_large = ((s211-s222)*(1-x_large) - (s111-s122)*x_large) ./ ...
        ((s211-s222)*(1-x_large) - (s111-s122)*x_large + ...
        (s221-s212)*(1-x_large) - (s121-s112)*x_large);

    % compute payoffs to senders playing a mixture of S1 and S4
    sender_payoffs_large = zeros(1, length(x_large));
    for i = 1:length(x_large)
        sender_payoffs_large(1, i) = [1-alpha, 0, 0, alpha] * ...
            S_large(:, :, i) * [1-beta_large(i); 0; 0; beta_large(i)];
            
    end
    
    % compute payoffs to senders playing S3
    alt_sender_payoffs_large = zeros(1, length(x_large));
    for i = 1:length(x_large)
        alt_sender_payoffs_large(1, i) = [0, 0, 1, 0] * ...
            S_large(:, :, i) * [1-beta_large(i); 0; 0; beta_large(i)];
            
    end

    % visualize the results
    figure(2)
    box on;
    hold on;
    plot(x_large, sender_payoffs_large, 'LineWidth', 2, ...
        'LineStyle', '--', 'Color', [0 0 0]);
    plot(x_large, alt_sender_payoffs_large, 'LineWidth', 2, ...
        'Color', [0 0 0]);
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 4, 3]);
    set(gca, 'FontSize', 11)
    ylim([1.4 2.4]);
    ax = gca;
    ax.TickLabelInterpreter = 'latex';
    xlabel('Fraction $x$ of surly visitors', 'Interpreter', 'latex')
    ylabel('Payoff to visitors', 'Interpreter', 'latex')

    if print_to_eps
        print('bqxlarge.eps', '-depsc')
    end

    % this auxiliary function computes the payoffs to Senders
    function [a11, a12, a13, a14, a21, a22, a23, a24, ...
            a31, a32, a33, a34, a41, a42, a43, a44] = ...
            compute_payoffs_S(s111, s112, s121, s122, ...
            s211, s212, s221, s222, x)
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
    end

end



%