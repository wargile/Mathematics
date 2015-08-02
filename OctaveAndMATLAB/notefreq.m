function h = notefreq()
%NOTEFREQ Plots freq_array graph for all MIDI notes.
%
%   See also GETFREQ, GET_FREQUENCY, CALC_FREQUENCY, GETFREQ, GETKEYNAME

    FIG_NAME = 'MIDI';
    concertpitchhertz = 440;
    concertpitchnote = 69;
    freq_array = 1:128;

    % Calculate the frequency in Hz
    for n = 0:length(freq_array) - 1
        freq_array(n + 1) = (2 ^ ((n - concertpitchnote) / 12)) * ...
            concertpitchhertz;
    end

    %plot(freq_array, 'or');
    %plot(freq_array, '-bs','LineWidth', 1, ...
    %    'MarkerEdgeColor', 'k', ...
    %    'MarkerFaceColor', 'c', ...
    %    'MarkerSize', 6)  
    %grid on;
    %title('MIDI note 0-127 frequency');
    %xlabel('Note number');
    %ylabel('Hz');
    %legend('Hz curve');
    %legend('boxoff');
    %legend('location', 'north');
    %gtext('MIDI note numbers');

    % Create a new named figure
    createfigure(FIG_NAME, true);
    
    % Create axes
    axes1 = axes();
    box('on');
    grid('on');
    %hold('all');
    hold on;
    %colordef white;

    % Create plot
    if ismatlab
        plot(freq_array, 'Parent', axes1, 'MarkerFaceColor', ...
            [0.50 0.90 0.95], 'MarkerEdgeColor', [0 0 1], ...
            'Marker', 'square', 'LineWidth', 1, 'Color', [0 0 1], ...
            'DisplayName', 'Frequency in kHz', 'MarkerSize', 4, ...
            'LineStyle', 'none');
    else
        h = plot(freq_array, 'ms');
        set(h, 'MarkerSize', 3);
        set(h, 'MarkerEdgeColor', 'blue');
        set(h, 'LineStyle', 'none');
    end
        
    set(axes1, 'YTick', (0 : 1000 : max(freq_array) + 1000));
    set(axes1, 'YTickLabel', (0 : 1 : (max(freq_array) + 1000) / 1000));
    set(axes1, 'Color', [0.92 0.99 0.95]);
	set(gca(), 'FontSize', 8);
    
    title('MIDI note 0-127 frequency', 'FontWeight', 'bold', ...
        'FontSize', 11);
    xlabel('Note number');
    ylabel('Frequency in kHz');
    
    if ismatlab
        legend1 = legend(axes1, 'show');
        set(legend1, 'Location', 'North');
    else
        legend('Notes', 'Location', 'North');
        legend('boxon');
    end

    set(gca, 'YGrid', 'on')
    set(gca, 'XGrid', 'off')
    
    % Return kHz frequency array to caller
    h = freq_array;
end
