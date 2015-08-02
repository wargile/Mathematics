function result = linspacetest(minval, maxval, elements)
%LINSPACETEST My take on the built-in LINSPACE function
%   Syntax: linspacetest(min, max, elements)
    
    result = zeros(1, elements);
    step = (maxval - minval) / (elements - 1);
    % NOTE: Creates positive or negative step
    result(1) = minval;

    for counter = 2:elements
        result(counter) = result(counter - 1) + step;
    end
end

function a = linspacetest_old(min, max, elements)
    if nargin < 2 || nargin > 3
        error('Usage: linspacetest(min, max, [elements])');
    end

    if nargin == 3
        elements = floor(elements);
    end

    if nargin == 2
        elements = 100;
        a = 1:elements;
        if min == max
            for i = 1:elements
                a(i) = max;
            end
        else
            a(1) = min;
            a(100) = max;
            for i = 2:elements - 1
                a(i) = min + (((max - min) / (elements - 1)) + ...
                    (((max - min) / (elements - 1)) * (i - 2))); 
            end
        end
    end

    if nargin < 2
        a = max;
    elseif nargin == 3
        if elements <= 1
            a = max;
        else
            temp = (max - min) / (elements - 1);
            a = 1:elements;

            % Set first and last element value
            a(1) = min;
            a(elements) = max;

            % a(2) = min + temp; % Set next element
            for i = 2:elements - 1
                a(i) = min + (temp * (i - 1));
            end
        end
    end
end

