function [scale, note_name] = ...
    chord_generator_test(chord_number, transposed, bars, run_direction)
%CHORD_GENERATOR Creates chords/arpeggiator patterns
%
%   CHORD_GENERATOR
%     ([chord_number],[transposed],[bars],[run_direction],
%      [show_octaves])
%
%   Example:
%     CHORD_GENERATOR(8, 4, 4, 3, true)
%
%   Returns:
%     scale:                Note values
%     note_name:            Note names
%     chord_notes_selected: Chord notes
%
%   See also: arpeggiator, arpeggiator_test

%   Copyright (C) T. Bakkelokken 2011
%   http://www.8notes.com/piano_chord_chart/Em9.asp
%
%   TODO: Direction modes REV, RND
%   TODO: Make sure the tonic is repeated in chords with more
%   than four notes

    if nargin < 4
        error(['Usage: CHORD_GENERATOR <chord_number>,' ...
            '<transposed>,<bars>,<run_direction>,<show_octaves>)']);
    end
    
    FIGURE_NAME = 'Chord Generator';
    SEMI_TONES = 12;
    FWD = 1; REV = 2; PND = 3; RND = 4; %#ok<NASGU>
    
    if nargin < 1
        chord_number = 1;
    end

    if nargin < 2
        transposed = 0;
    end

    if nargin < 3
        bars = 2;
    end

    if nargin < 4
        direction = FWD; %#ok<NASGU>
    end

    if transposed > SEMI_TONES - 1 || transposed < 0
        error 'Valid transpose values are 0 to 11.'
    end
    
    % NOTE: Chord_notes must be long datatype in C
    chord_notes = ...
    [
        bin2dec('000010010001'), ...           % 1:  major
        bin2dec('001010010001'), ...           % 2:  major6
        bin2dec('000010001001'), ...           % 3:  m
        bin2dec('010010010001'), ...           % 4:  7
        bin2dec('100010010010001'), ...        % 5:  9
        bin2dec('001010001001'), ...           % 6:  m6
        bin2dec('010010001001'), ...           % 7:  m7
        bin2dec('100010010001001'), ...        % 8:  m9
        bin2dec('1000100010010001001'), ...    % 9:  m11
        bin2dec('1001000100010010001001'), ... % 10: m13
        bin2dec('001001001001'), ...           % 11: dim7
        bin2dec('100010010001'), ...           % 12: maj7
        bin2dec('000010100001'), ...           % 13: sus4
        bin2dec('010010100001'), ...           % 14: 7sus4
        bin2dec('000010000101'), ...           % 15: sus2
        bin2dec('000100010001') ...            % 16: aug5
    ];

    MAX_CHORDS = numel(chord_notes);

    if chord_number > MAX_CHORDS
        error (['Max chord number is ', num2str(MAX_CHORDS), '.']);
    end

    chord_names = {'', '6', 'm', '7', '9', 'm6', 'm7', 'm9', 'm11', ...
        'm13', 'dim7', 'maj7', 'sus4', '7sus4', 'sus2', 'aug5' };

    chord_lengths = [3, 4, 3, 3, 5, 4, 4, 5, 6, 7, 4, 4, 3, 4, 3, 3];
    chord_lengths_bin = [12, 12, 12, 12, 15, 12, 12, 15, 19, 22, ...
        12, 12, 12, 12, 12, 12];

    noteletters = { 'C', 'Db', 'D', 'Eb', 'E', 'F', ...
        'Gb', 'G', 'Ab', 'A', 'Bb', 'B' };
		
    chord_notes_selected = ...
        zeros(1, chord_lengths(chord_number));
    direction = run_direction;
    p = 0;
    counter = 1;
    
    % Find selected notes
    while (true)
        if bitget(chord_notes(chord_number), counter)
            p = p + 1;
            chord_notes_selected(p) = counter + ...
                floor(counter / SEMI_TONES);
        end
        
        if counter == chord_lengths_bin(chord_number)
            break;
        else
            counter = counter + 1;
        end
    end

    if direction == PND
        scale = zeros(1, (p * 2) * bars);
        note_name = cell(1, (p * 2) * bars);
    else
        scale = zeros(1, p * bars);
        note_name = cell(1, p * bars);
    end

    p = 1;
    %note_counter = 1;
    
    for bar_counter = 1:bars
        counter = 1;
        
        while counter <= chord_lengths(chord_number)
            octave_no = ceil(max(scale) / SEMI_TONES);  

            scale(p) = (chord_notes_selected(counter) + transposed) ...
                * (octave_no + 1);

            note_name{p} = ...
                [noteletters{mod((chord_notes_selected(counter) - 1 + ...
                transposed), SEMI_TONES) + 1}, num2str(octave_no)];

            counter = counter + 1;
            p = p + 1;
        end
    end

    createfigure(FIGURE_NAME);

    h = bar(scale);
    hold off;
    
    set(h, 'FaceColor', [0.46 0.67 0.88]);
    set(h, 'EdgeColor', 'blue');
    set(h, 'BarWidth', 0.5);
  
    set(gca, 'XTickLabel', note_name);
    set(gca, 'YGrid', 'on');
	
    set(gca, 'XTick', 1:numel(chord_notes_selected) * bars);
    xlim([0, (numel(chord_notes_selected) + 1) * bars]);

    ytick_interval = ceil(max(scale) / SEMI_TONES);
    set(gca, 'YTick', 1:ytick_interval:max(scale));
    ylim([0, max(chord_notes_selected) + 1]);        
    
    box off;
	
    the_title = strcat(FIGURE_NAME, ' [', ...
        noteletters{transposed + 1}, ...
        chord_names{chord_number}, ']');

    enhancefigure(the_title, strcat( ...
        noteletters{transposed + 1}, chord_names{chord_number}, ...
        ' chord'), 'Note number');
end
