function resvalue = getresval(varargin)
% GETRESVAL Returns resistor value for given color bands
%   Syntax: getresval('color band 1', 'color band 2', 'color band 3')
%
%   Valid color names are: black, brown, red, orange, yellow
%                          green, blue, violet, gray, white

    if nargin ~= 3
        error(['Usage: getresval(''colorband1'', ''colorband2'', ', ...
            '''colorband3'')']);
    end

    colorbands = { 'black', 'brown', 'red', 'orange', 'yellow', ...
        'green', 'blue', 'violet', 'gray', 'white' };
    
    validcolors_band1 = [0 1 1 1 1 1 1 1 1 1];
    validcolors_band2 = [1 1 1 1 1 1 1 1 1 1];
    validcolors_band3 = [1 1 1 1 1 1 1 0 0 0];

    firstno = -1;
    secondno = -1;
    multiplier = -1;

    for n = 1:length(colorbands)
        if strcmp(varargin(1), colorbands{n}) == 1
            if validcolors_band1(n) == 1
                firstno = (n - 1) * 10;
            else
                error(['Invalid color for band no. 1. ', ...
                    displayvalidcolorbands(colorbands, ...
                    validcolors_band1)]);
            end
        end
        if strcmp(varargin(2), colorbands{n}) == 1
            if validcolors_band2(n) == 1
                secondno = (n - 1);
            else
                error(['Invalid color for band no. 2. ', ...
                    displayvalidcolorbands(colorbands, ...
                    validcolors_band2)]);
            end
        end
        if strcmp(varargin(3), colorbands{n}) == 1
            if validcolors_band3(n) == 1
                multiplier = (10 ^ (n - 1));
            else
                error(['Invalid color for band no. 3. ', ...
                    displayvalidcolorbands(colorbands, ...
                    validcolors_band3)]);
            end
        end
    end

    if firstno == -1 || secondno == -1 || multiplier == -1
        error('Invalid colorband(s)!');
    end

    resvalue = (firstno + secondno) * multiplier;

    if resvalue > 999999
        fprintf('\nResistor value is %ld ohms (%.1f Mohms).\n', ...
            resvalue, resvalue / 1000000);
    elseif resvalue > 999
        fprintf('\nResistor value is %ld ohms (%.1f Kohms).\n', ...
            resvalue, resvalue / 1000);
    else
        fprintf('\nResistor value is %ld ohms.\n', resvalue);
    end
end


function ret = displayvalidcolorbands(colorbands, validcolors)
    ret = 'Valid colorbands are:';
    
    for n = 1:length(colorbands)
        if validcolors(n) == 1
            ret = horzcat(ret, ' ', colorbands{n}); %#ok<AGROW>
        end
    end
end
