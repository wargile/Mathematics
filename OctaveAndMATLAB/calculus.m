function calculus()
%CALCULUS Just testing some calculus stuff...
%
% Check out: http://www.coolmath.com/index.html, Wolfram Alpha

  the_run = 90;
  the_rise = 45;

  createplots(the_run, the_rise);

  getderivative; % TODO

  fprintf('Slope of (-2, 10) and (1, -5) is %.2f.\n', ...
    getslope(-2, 10, 1, -5));

  fprintf('The hypotenuse for triangle lengths %d and %d is %d.\n', ...
    the_run, the_rise, int8(gethypotenuse(the_run, the_rise)));

  % 1 radian = 57 degrees (57.2958). 360/57.2958/2 gives pi as result.
  % Circumference = 2 pi r. Area is pi r^2. 
  fprintf('Radians of %.4f degrees is %.15f.\n', ...
    57.2958, deg2rad(57.2958));
  fprintf('Degrees of %.4f radians is %.4f.\n', ...
    deg2rad(57.2958), rad2deg(deg2rad(57.2958)));

  fprintf('Average of [25, -50, 50] is: %.4f.\n', ...
    mean_test([25, -50, 50]));
  fprintf('StdDev of [-45 45] is: %.4f.\n', std_test([-45 45]));
end

function createplots(the_run, the_rise)
  % Get the slope of a line
  % Slope = rise / run. Run = x-axis, rise = y-axis

  FIG_NAME_1 = 'Calculus1';
  FIG_NAME_2 = 'Calculus2';
  FIG_NAME_3 = 'Calculus3';

  createfigure(FIG_NAME_1);

  hold off;
  clf;

  rows = 2;
  cols = 2;
 
  subplot(rows, cols, 1);
  % h = subplot(2, 3, 1);
  % p = get(h, 'Position');
  plot(0:the_rise/the_run:the_rise, 'r-');
  set(gca, 'FontSize', 8);
  hold on;
  plot(0:the_run, 'b-');
  axis square;
  axis tight;
  box off;
  grid;
  set(gca, 'YLim', [0, the_run + 10]);
  set(gca, 'XTick', floor(linspace(0, the_run + 10, 6)));
  set(gca, 'YTick', floor(linspace(0, the_run + 10, 6)));
  %text(p(1), p(2) - 16, sprintf('The slope = %.2f/%.2f', ...
  %  the_rise/the_rise, the_rise/the_run), 'FontSize', 8);
  legend(sprintf('Slope: %.2f', the_rise/the_run), ...
    sprintf('Slope: %.2f', the_rise/the_rise));
  title('Graphs...', 'FontSize', 11);
    
  subplot(rows, cols, 2);
  plot(-10:10, plotfunction1(-10:10, 2), 'b-');
  axis square;
  axis tight;
  set(gca, 'FontSize', 8);
  legend('f(x) = x^2');
  box off;
  grid;

  subplot(rows, cols, 3);
  plot(-10:10, plotfunction1(-10:10, -2), 'b-');
  axis square;
  axis tight;
  set(gca, 'FontSize', 8);
  legend('f(x) = x^-2)');
  box off;
  grid;

  subplot(rows, cols, 4);
  plot(-9:9, plotfunction2(-9:9), 'b-');
  axis square;
  axis tight;
  set(gca, 'FontSize', 8);
  legend('f(x) = |x|'); % |x| = abs(x)
  box off;
  grid;

  createfigure(FIG_NAME_2);

  subplot(rows, cols, 1);
  plot(plotfunction3(-10:10), -10:10, 'b-');
  axis square;
  axis tight;
  set(gca, 'FontSize', 8);
  legend('f(x) = y3 - 5y2');
  % NOTE: Not a function
  box off;
  grid;
    
  h = subplot(rows, cols, 2);
  p = get(h, 'Position');
  plot(-2:2, plotfunction4(-2:2, 2), 'r-');
  hold on;
  maxval = max(plotfunction4(-2:2, 3)); % for ytick
  plot(-2:2, plotfunction4(-2:2, 3), 'bo-');
  axis square;
  axis tight;
  set(h, 'YTick', linspace(0, maxval, 10));
  set(gca, 'FontSize', 8);
  legend('x=2: f(x) = 2x','x=2.2: f(x) = 2x'); % exp
  text(p(1), p(2), 'NOTE: Intersects at (0, 1)', 'FontSize', 8);
  box off;
  grid;
    
  subplot(rows, cols, 3);
  plot(plotfunction5(-10:0.2:10), 'b*');
  axis square;
  axis tight;
  set(gca, 'FontSize', 8);
  legend('X+2*X-5/X-3*X+1');
  box off;
  grid;

  subplot(rows, cols, 4);
  [y1, y2] = plotfunction6(1:10);
  plot(y1, 'b-');
  hold on;
  plot(y2, 'r-');
  set(gca, 'FontSize', 8);
  xlabel('Time');
  ylabel('Speed/average speed');
  axis square;
  axis tight;
  legend('Speed', 'Average speed');
  box off;
  grid;

  createfigure(FIG_NAME_3);

  subplot(rows, cols, 1);
  %axis manual;
  %axis 'auto y';
  xlim([-30 30]);
  ylim([-2 10]);
  plot(plotfunction7(-3:0.2:1), 'r-');
  hold on;
  axis([-30 30 0 10]);
  plot(plotfunction1(1:0.1:3, 2), 'b-');
  %axis square;
  grid;

  hold off;
end

function h = getderivative()
% Derivative: The slope of the tangent line is equal to the
%             derivative of the function at the marked point.
%
% http://en.wikipedia.org/wiki/Derivative
        
  h = 1; % TODO: Placeholder so far!
end

function h = gethypotenuse(a, b)
% The hypotenuse is always the diagonal of a right triangle

  h = sqrt((a^2) + (b^2));
end

function s = getslope(x1, y1, x2, y2)
% The slope of graph with points (x1,y1) and (x2,y2)
% The line changes s units for each 1-unit change from left to right
% Negative s-value is a falling slope, positive is a rising slope.

  s = ((y1) - (y2)) / ((x1) - (x2));
end

function y = plotfunction1(x, z)
% A function: f(x) - "Function of x". The result of f(x) = y. Y = the
% dependent variable. The value of y depends on how x
% changes/increases. X is the independent variable. We know the range of
% x, and we want to find the value of y.

% Example: y = 4x + 30
% Write as: f(x) = 4x + 30

% Composite function:
% f(x) = x^2
% g(x) = 5x - 8
% Write as: f(g(3)) = 49

  y = zeros(1, length(x));

  for i = 1:length(y)
    y(i) = x(i) ^ z;
  end
end

function y = plotfunction2(x)
% y = |x|

  y = zeros(1, length(x));

  for i = 1:length(y)
    y(i) = abs(x(i));
  end
end

function y = plotfunction3(x)
% y = x3 - 5x2 + 10
% NOTE: Not a function, fails the single vertical line test

  y = zeros(1, length(x));

  for i = 1:length(y)
    y(i) = (x(i) ^ 3) - (5 * (x(i) ^ 2));
  end
end

function y = plotfunction4(x1, x2)
  y = zeros(1, length(x1));

  for i = 1:length(y)
    y(i) = (x2 ^ x1(i));
  end
end

function y = plotfunction5(x)
  y = zeros(1, length(x));

  for i = 1:length(y)
    if ((x(i) - 3) * (x(i) + 1)) ~= 0 % Avoid DIV/0 warning
      y(i) = ((x(i) + 2) * (x(i) - 5)) / ((x(i) - 3) * (x(i) + 1));
    else
      y(i) = y(i - 1);
    end
  end
end

function [y1, y2] = plotfunction6(t)
% Graph speed change from falling ball
% 
% Speed (or rate) = distance / time (t)
% Average speed = total distance / total time
% NOTE: 16 = chosen constant, distance the ball falls in 1 second
    
  y1 = zeros(1, length(t));
  y2 = zeros(1, length(t));

  for i = 1:length(y1)
    y1(i) = 16 * (t(i) ^ 2); % speed
    y2(i) = sum(y1) / i; % average speed
  end
end

function y = plotfunction7(x)
  y = zeros(1, length(x));
    
  for i = 1:length(y)
    y(i) = x(i) + 3;
  end
end

function r = deg2rad(d)
% Convert from degrees to radians
    
  r = d * (pi / 180.0);
end
    
function d = rad2deg(r)
% Convert from radians to degrees
    
  d = r * (180.0 / pi);
end

function y = mean_test(x)
% Calculate average
  y = (1 / length(x)) * sum(x);
end

function y = std_test(x)
% Calculate stddev
  temp = 0;
   
  for i = 1:length(x)
    temp = temp + ((x(i) - mean_test(x)) ^ 2);
  end
  
  if length(x) > 1
    y = sqrt((1 / (length(x) - 1)) * temp);
  else
    y = 0;
  end
end
