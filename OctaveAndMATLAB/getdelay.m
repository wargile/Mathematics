function delayvalue = getdelay(unit, delay, osc)

%GETDELAY Gets the delay value for use in PIC custom delay functions.
%   D = GETDELAY(TIME_UNIT, DELAY_VALUE, OSCILLATOR_SPEED) requires
%   three arguments:
%       TIME_UNIT: the time unit specified as 'us' or 'ms' or 's'
%       DELAY_VALUE: desired delay value
%       OSCILLATOR_SPEED: oscillator speed in Mhz
%
%   GETDELAY returns the delay value for use in PIC custom delay functions.
%
%   See also GETFREQ
%

%   Author: Terje Bakkeløkken
%   Contact: tbak8@hotmail.com
%   Version: 1.0 - 2009
%   Comments:
%

    if nargin ~= 3
        error(['Usage: getdelay(unit(''us''|''ms''|''s''), ', ...
            'delay value, osc in Mhz)']);
    end

    t_unit = 1 / (osc / 4); % Get TCY value

    if strcmp(unit, 'us') == 1
        delayvalue = delay * (1 / t_unit);
    elseif strcmp(unit, 'ms') == 1
        delayvalue = (delay * 1000) * (1 / t_unit);
    elseif strcmp(unit, 's') == 1
        delayvalue = (delay * 1000000) * (1 / t_unit);
    else
        error(['Usage: getdelay(unit(''us''|''ms''|''s''), ', ...
            'delay value, osc in Mhz)']);
    end

    fprintf('%.2fMhz oscillator gives TCY=%.3fus.\n', osc, t_unit);
    fprintf('Delay value for a %.2f%s delay is: %.0f.\n', delay, unit, ...
        delayvalue);
end
