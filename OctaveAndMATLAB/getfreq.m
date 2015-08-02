function frequency = getfreq(varargin)
%Gets the frequency and BPM for a time value.
%   Syntax: getfreq(unit('us' or 'ms' or 's'), time value, [osc in Mhz])
%
%   GETFREQ gets the frequency and BPM for a time value. The osc parameter
%   is not mandatory.
% 
%   http://eng-serve.com/pic/pic_timer.html
%
%   See also GETDELAY, GET_FREQUENCY, CALC_FREQUENCY

  if nargin < 2 || nargin > 3
    error(['Usage: getfreq(unit(''us''|''ms''|''s''), ', ...
           'time value, [osc in Mhz])']);
  end

  osc = 0;
  unit = varargin{1};
  time = varargin{2};

  if nargin == 3
    osc = varargin{3};
    t_unit = 1 / (osc / 4); % Get TCY value if osc parameter is present
  else
    t_unit = 1; 
  end

  if strcmp(unit, 'us') == 1
    frequency = (1 / (time * t_unit)) * 1000000;
  elseif strcmp(unit, 'ms') == 1
    frequency = (1 / ((time * 1000) * t_unit)) * 1000000;
  elseif strcmp(unit, 's') == 1
    frequency = (1 / ((time * 1000000) * t_unit)) * 1000000;
  else
    error('Invalid time unit. Valid values are: s, ms, us');
  end

  if nargin == 3
    fprintf('%.2fMhz oscillator gives FCY=%.3fus, TCY=%.3fus.\n', ...
            osc, (1 / osc), t_unit);
  end

  if frequency > 999999
    fprintf('Frequency for a %.2f%s time value is: %.2fMhz (%.2f BPM).\n', ...
            time, unit, frequency / 1000000, frequency * 60);
  elseif frequency > 999
    fprintf('Frequency for a %.2f%s time value is: %.2fKhz (%.2f BPM).\n', ...
            time, unit, frequency / 1000, frequency * 60);
  else
    fprintf('Frequency for a %.2f%s time value is: %.2fHz (%.2f BPM).\n', ...
            time, unit, frequency, frequency * 60);
  end
end
