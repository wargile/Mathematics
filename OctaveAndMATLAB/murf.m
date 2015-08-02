function [curve_data, raw_data] = murf(interval)
%MURF Plot MuRF sine curve pattern data
%   See also MURF_ENVELOPE, MURF_ENVELOPE_NEW.

    MAX_CHANNELS = 8;
    
    if nargin == 0
        interval = 0.2;
    end
    
    curve = -pi:interval:pi*2;
    curve_data = floor(round(sin(curve) * (MAX_CHANNELS - 1)) / 2.01) + 4;
    raw_data = ((sin(curve) * (MAX_CHANNELS - 1)) / 2.01) + 4;
    
    plot(sin(curve), 'b-');
    hold on;
    stairs(curve_data, 'ro-');
    hold off;
    enhancefigure('MuRF Curve', 'Curve Data', 'Channels');

    ylim([-1, 8]);
    xlim([0, length(curve) + 1]);
    %set(gca, 'xgrid', 'on');
end
