function ret = modwheel(controllervalue, voltoffset)
%MODWHEEL Creates a modulation curve
%
%   MODWHEEL creates a modulation curve for the modulation
%   wheel MIDI controller (controller no. 176)
%
%   Usage: MODWHEEL(<controllervalue (0-127)>, [offset (0-5)]

    FIG_NAME = 'Modwheel Amplitude';
    
    if nargin < 1
        error('Usage: MODWHEEL(<controllervalue (0-127)>, [offset (0-5)]');
    end

    if nargin == 1
        voltoffset = 0;
    end
    
    if isnumeric(controllervalue) == false || ...
            isnumeric(voltoffset) == false
        error('Invalid input value(s).');
    end
    
    if controllervalue < 0 || controllervalue > 127
        error('Valid controllervalues are 0 to 127.');
    end
        
    b = ((sin(0 : 0.05 : 2 * pi) * (controllervalue / 127.0)) * 6) + ...
        voltoffset;
    
    a = zeros(length(b));
    
    for c = 1:length(b)
        a(c) = voltoffset;
    end

    % For more than one subplot, use: for i = 1:4 subplot(2, 2, i);
    
    % Create a new named figure
    createfigure(FIG_NAME);
    
    if ~ishold()
        clf;
        cla;
        hold off;
    end
    
    h_plot = plot(a, 'b--', 'LineWidth', 1);
    
    if ismatlab()
      set(h_plot, 'LineSmoothing', 'on');
    end
      
    hold on;
    h_plot = plot(b, 'r-');

    if ismatlab()
      set(h_plot, 'LineSmoothing', 'on');
    end
    
    set(gca, 'FontSize', 8);
    set(gca, 'YGrid', 'on')
    set(gca, 'XGrid', 'off')
    set(gca,'Color', [0.92 0.95 0.95])
    set(gca, 'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3]);
    set(gca, 'FontWeight', 'bold');
    box off;
    title('Modwheel Curve', 'FontWeight', 'bold', 'FontSize', 11)

    ylabel('Amplitude', 'FontWeight', 'bold');
    xlabel('Time', 'FontWeight', 'bold');
    set(gca, 'YLim', [(-6.5) + voltoffset, 6.5 + voltoffset]);
    set(gca, 'XLim', [0, length(a) + 1]);
    
    % Copy figure to clipboard (not possible in Octave?)
    if ismatlab()
        print -dmeta
    end
    
    ret.a = a;
    ret.b = b;
end
