function [result1, result2] = machine_learning(y)
% Coursera Machine Learning course
%
% Generate some random y's: y = abs(randn(20, 1) * 10)

    % x = sort(abs(randn(20, 1) * 10));
    p = zeros(0, length(y));
    pos = 1;
    theta1_start = -.5;
    theta1_end = 3;
    best_theta1 = 0;
    old_theta1 = theta1_end;

    for i = theta1_start:0.1:theta1_end % theta1 value range to check
        p(pos) = machine_learning_sub(i, y);
    
        if p(pos) < old_theta1 % Save the theta1 value with best fit
            best_theta1 = i;
        end
    
        old_theta1 = p(pos);
        pos = pos + 1;
    end

    best_fit_theta1 = best_theta1;
    
    % intercept = 0;
    % intercept = sum(y) - (best_fit_theta1 * sum(x));
    
    % Create plot of theta1 values

    createfigure('Machine Learning Week 1');
    subplot(1, 2, 1);
    h = plot(p, 'bo-');
    title(sprintf('Cost function J (theta1=%.2f)', best_fit_theta1));

    if ismatlab
        set(h,'MarkerEdgeColor','b','MarkerFaceColor','c');
    end
    
    grid();

    subplot(1, 2, 2);
    h = plot(y, 'bo');
    
    if ismatlab
        set(h,'MarkerEdgeColor','b','MarkerFaceColor','c');
    end
    
    hold on;
    plot((1:length(y)) * best_fit_theta1, 'r');
    hold off;
    title('Scatterplot and regression line');
    grid();

    %xtick(-2:2)
    %set (gca, 'xticklabel', -10:10);
    result1 = p;
    
    % When n is not too large, use normal equation:
    X = [1,1,1,1;2104,1416,1534,852;5,3,3,2;1,2,2,1;45,40,30,36];
    Xrow = transpose(X);
    Xrow = Xrow(1,:);
    result2 = pinv(transpose(Xrow) * Xrow) * transpose(Xrow) * y';
    % result2 = pinv(Xrow' * Xrow) * Xrow' * y';
end

function [result] = machine_learning_sub(theta1, y)
    elements = length(y);
    temp = 0;

    for i=1:elements
        temp = temp + (((i * theta1) - y(i))^2);
    end

    result = (1 / (2 * elements)) * temp;
end

%function gradient_decent_algorithm()
% Learning rate = size of step in gradient decent
% Do for theta0 and theta1 simultaneously

%temp0 = theta0 - learning_rate * derivative_formula
%temp1 = theta1 - learning_rate * derivative_formula

% TODO understanding:
% derivative_formula = (d / (d * theta0)) * J(theta0, theta1)
% = d/dx f(x)

% That means: a NEGATIVE derivative (tangent, slope is negative), gives:
% learning rate - (-derivative) = learning_rate + derivative,
% the descent moves RIGHT towards minimum
% That means: a POSITIVE derivative (tangent, slope is positive), gives:
% learning rate - derivative = learning_rate . derivative,
% the descent moves LEFT towards minimum

%theta0 = temp0
%theta1 = temp1
% NOTE: Simultaneously update theta0 (y-intercept) and theta1 (slope)
%end

% https://code.google.com/p/randomforest-matlab/
% B = TreeBagger(ntrees,X,Y)
% http://www.mathworks.se/help/stats/treebagger.html

