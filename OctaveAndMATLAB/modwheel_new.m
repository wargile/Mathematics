function h = modwheel_new(notenumber, plotline)
%MODWHEEL_NEW Plots modwheel changes.
%
%   Usage: h = MODWHEEL_NEW(<notenumber>, [plotline color/linetype]) 

    global mod_wheel_counter;
    global new_controller_value;
    
    FIG_NAME = 'Modwheel Curve';

    if nargin == 0
        notenumber = 56;
        plotline = 'b-';
    end
    
    if notenumber > 127 || notenumber < 0
        error 'Notenumber must be between 0 and 127.';
    end
    
    new_controller_value = 0;
    mod_wheel_counter = 0;
    % controller_values = [0:127,126:-1:0];
    dac_values1 = zeros(1, 4000);
    dac_values2 = zeros(1, 4000);
    x = 0;
    
    % Increasing amplitude
    for p = 1:(length(dac_values1) / 20):(length(dac_values1))
        for i = 1:(length(dac_values1) / 20)
            dac_values1((i - 1) + p) = ...
                modwheel_change(notenumber, x);
        end
        
        x = x + 1; % Increase controller value
    end
    
    % Decreasing amplitude
    for p = 1:(length(dac_values2) / 20):(length(dac_values2))
        for i = 1:(length(dac_values2) / 20)
            dac_values2((i - 1) + p) = ...
                modwheel_change(notenumber, x);
        end
        
        x = x - 1; % Decrease controller value
    end

    % Plot graph, create a new named figure
    createfigure(FIG_NAME, true);

    % To get a black plot background and white grid:
    %if ismatlab()
    %  colordef black
    %end
    
    % Get all active figures
    %figs = get(0, 'Children');
    % Get active figure in array
    %active_array = (figs' == gcf); % [0 1 0 0]
    % Close all but the active figure
    %close(figs(figs ~= gcf));
    % Find all figures
    %findall(0, 'Type', 'figure');
    
    if ishold()
        clf;
        cla;
        hold off;
    end
    
    if ismatlab() % Check if we're in MatLab. Code in ismatlab.m
        colordef white; % Use standard plot colors (error in Octave)
    end
    
    set(gca, 'Color', [1 1 1])
    set(gca, 'FontSize', 8);
    
    % h_plot = plot([dac_values1, dac_values2], plotline);
    stairs([dac_values1, dac_values2], plotline);
    
    %if ismatlab()
    %  set(h_plot, 'LineSmoothing', 'off');
    %end
    
    xlabel('Phase/Time', 'FontSize', 8);
    ylabel('Pitch', 'FontSize', 8);
    title('Modwheel Curve', 'FontWeight', 'bold', 'FontSize', 11)
    %set(gca, 'Color', [1 1 1])
    legend('Pitch', 'Location', 'NorthEast');
    set(gca, 'Color', [0.90 0.97 0.95])
    set(gca, 'YGrid', 'on')
    set(gca, 'XGrid', 'off')
    box off;
    % Add a little space above and below on the y-axis
    set(gca, 'YLim', [min(dac_values2) - 10, max(dac_values2) + 10]);

    % Return data to caller
    if nargout > 0
        h = struct; % Define h as a struct (not actually needed)
        h.dac_values = [dac_values1, dac_values2];
        h.notenumber = notenumber;
    end
end

function h = modwheel_change(note_value, controller_value)
    % NOTE: Global or persistent: Not same effect here. Use global.
    global mod_wheel_counter;
    global new_controller_value;
    
    REF_VOLTAGE = 5.0;
    DAC_12_BIT = 4095.0; % NOTE: 4095 creates a curve value error?
    VOLT_PR_NOTE = 0.08333334;
    MAX_MIDI_NOTE = 127.0;
    AMP_OFFSET = 12.0; % Max one octave amplitude variation
    INTERVAL = 0.01;
    
    if (mod_wheel_counter < (2 * pi))
        mod_wheel_counter = mod_wheel_counter + INTERVAL;
    else
        mod_wheel_counter = 0;
    end
    
    % Gives a somewhat smoother curve for low amplitudes
    if (mod_wheel_counter == 0)
        new_controller_value = controller_value;
    end
    
    mod_wheel_offset = sin(mod_wheel_counter) * ...
        ((new_controller_value / MAX_MIDI_NOTE) * (AMP_OFFSET / 2.0));
    voltage_out = ((note_value + mod_wheel_offset) * VOLT_PR_NOTE);
    DAC_value = floor((voltage_out + 1.0) * (DAC_12_BIT / REF_VOLTAGE));
    
    h = DAC_value;
end
