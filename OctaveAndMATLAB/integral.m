function [area, x_coords, y_coords] = ...
  integral(f, x_min, x_max, y_min, y_max, plot_type)
%INTEGRAL Create curves from functions and integrate
%         (calulate area below graph)
%
%         Usage: integral(function, x_min, x_max, y_min, y_max, plot_type)
%
%   The derivative = The slope (m). Which is dy/dx or df(x)/dx.
%
%   For instance: When x changes from 0 to 1, y changes from 0 to 3.
%   Derivative = 3/1 = 3.
%   For instance: When x changes from 0 to 2, y changes from 0 to 1.
%   Derivative = 1/2 = 0.5.
%
%   A derivative is a measure of how much one thing changes compared
%   to another. A derivative is A RATE.
%
%   h = the run (x2-x1)
%   f'(x) = lim h->0 (f(x+h)-f(x))/h
%
%   Some stuff to memorize...:
%   1/x^3 = x^-3
%   (x+h)^2 = (x^2 + 2xh + h^2)
%   If f(x)=x then f'(x)=1
%   x^0 = 1  
%   (1/3)-1 = (-2/3) = -0.66667
%   Derivative of y=4x^3: Derivative of x^3 = 3x^2.
%   Result: 4(3x^2) = 12x^2.
%   e (approx 2.72) is the Euler constant. Important number!
 
    FIG_NAME = 'Integration Test';

    if nargin == 0
      f = 'x * 2';
      x_min = 0;
      x_max = 10;
    end
    
    %x = 1; %#ok<NASGU>
    
    %if eval(f) < 0
    %    error 'Error in function. Function must return a positive value';
    %end
    
    if (nargin == 3) && (x_min >= x_max)
      error 'Error in x range parameters.'
    end
    
    if (nargin == 5) && (y_min >= y_max)
      error 'Error in y range parameters.'
    end
    
    % Find area under curve between a and b
    
    fprintf('Working...');
    
    divisions = (x_max - x_min) / 50000; % split in tiny rectangles...
    y_coords = zeros(1, floor((x_max - x_min) / divisions));
    x_coords = zeros(1, floor((x_max - x_min) / divisions));
    
    area = 0;
    p = 1;
    x = x_min; %#ok<NASGU>
    x_coords(1) = x_min;
    y_coords(1) = eval(f);
    
    for x = x_min:divisions:x_max
      area = area + (divisions * (eval(f)));

      if mod(p, 2000) == 0
        fprintf('.');
      end

      if (p > 1)
        x_coords(p) = x_coords(p - 1) + divisions;
        y_coords(p) = eval(f);
      end
        
      p = p + 1;
    end
    
    % Create a new named figure
    createfigure(FIG_NAME, false);

    if nargin == 6
      plot(x_coords, y_coords, plot_type);
    else
      plot(x_coords, y_coords, '-b');
    end
    
    %set(h_plot, 'LineSmoothing', 'on');

    xlim([min(x_coords) - 0.2 max(x_coords) + 0.2]);

    if nargin == 5
      ylim([y_min y_max]);
    else
      if max(y_coords) < 1000
        ylim([min(y_coords) - 1 max(y_coords) + 1]);
      else
        ylim([min(y_coords) - 1 1000]);
      end
    end
    
    title(['Graph for function ', f, ' for limits ', ...
           num2str(x_min), ', ', num2str(x_max), ...
           '. The area is: ', num2str(area)]);
    xlabel('x');
    ylabel('f(x)');
    box off;
    grid;

    fprintf('\nDone!\n');
end
