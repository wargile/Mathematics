function h = plotnotefreq()
%PLOTNOTEFREQ Plots freq_array graph for all MIDI notes.
%
%   See also GETFREQ

    FIG_NAME = 'MIDI';
    concertpitchhertz = 440;
    concertpitchnote = 69;
    freq_array = 1:128;

    % Calculate the frequency in Hz
    for n = 0:length(freq_array) - 1
        freq_array(n + 1) = (2 ^ ((n - concertpitchnote) / 12)) * ...
            concertpitchhertz;
    end
    
    ylabels = cell(1, int8(max(freq_array) + 2000) / 1000);
    
    for n = 1:int8((max(freq_array) + 2000) / 1000)
        ylabels{n} = strcat(num2str(n), '  kHz');
    end
    
    % Create a new named figure
    createfigure(FIG_NAME, true);

    box('on');
    grid('on');
    %hold('all');
    
    % Create plot
    plot(freq_array, '-bo','LineWidth', 1, ...
        'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'c', ...
        'MarkerSize', 6) 
    set (gca, 'YTick', (0 : 1000 : max(freq_array) + 1000));

    set (gca, 'YTickLabel', ylabels);
    
    enhancefigure('MIDI note 0-127 frequency', 'Note number', ...
        'Frequency in kHz');
    
    legend('Frequency', 'Location', 'North');
    
    set(gca, 'YGrid', 'on')
    set(gca, 'XGrid', 'off')
    
    % Return kHz frequency array to caller
    h = freq_array;
    