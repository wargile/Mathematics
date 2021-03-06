function [scale, scale_inc, note_name] = ...
    chord_generator(chord_number, transposed, bars, ...
    notes_in_bar, run_direction, show_octaves)
%CHORD_GENERATOR Creates chords/arpeggiator patterns
%
%   CHORD_GENERATOR
%     ([chord_number],[transposed],[bars],[notes_in_bar],[run_direction],
%      [show_octaves])
%
%   Example:
%     CHORD_GENERATOR(8, 4, 1, 2, 3, true)
%
%   Returns:
%     scale:     Note values within one octave
%     scale_inc: Note values in all included octaves
%     note_name: Note names
%
%   See also: arpeggiator, arpeggiator_test

%   Copyright (C) T. Bakkelokken 2011
%   http://www.8notes.com/piano_chord_chart/Em9.asp
%   http://digitalmedia.oreilly.com/2006/06/29/secrets-of-the-arpeggiator.html
%
%   TODO: Direction modes REV, RND
%   TODO: Make sure the tonic is repeated in chords with more than four notes

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
        notes_in_bar = 4;
    end

    if nargin < 5
        direction = FWD; %#ok<NASGU>
    end

    if nargin < 6
        show_octaves = false;
    end
    
    if transposed > SEMI_TONES - 1 || transposed < 0
        error 'Valid transpose values are 0 to 11.'
    end
    
    % NOTE: chord_notes must be long datatype in C
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

    chord_lengths = [12 12 12 12 15 12 12 15 19 22 12 12 12 12 12 12];

    noteletters = { 'C', 'Db', 'D', 'Eb', 'E', 'F', ...
        'Gb', 'G', 'Ab', 'A', 'Bb', 'B' };
		
    direction = run_direction;
    p = 1;
    note_found = 0;

    len = notes_in_bar * bars;
		
    if direction == FWD || direction == REV
        scale = zeros(1, len);
        scale_inc = scale;
        note_name = cell(1, len);
    else
        scale = zeros(1, len * 2);
        scale_inc = scale;
        note_name = cell(1, len * 2);
    end
	
    counter = 0;
    change = 1;
    turn_around = false;
    
    if direction == REV
        note_counter = 1;
    else
        note_counter = 0;
    end
    
    while (true)
        counter = counter + change;
        fprintf('C: %d, NC: %d, NF: %d, TA: %d Change: %d L: %d\n', ...
            counter, note_counter, note_found, turn_around, change, len);
		
        if bitget(chord_notes(chord_number), mod((p - 1), ...
            chord_lengths(chord_number)) + 1) == 1
            note_found = note_found + 1;
            
            if direction == REV && turn_around == false
                % Wait...
            else
                note_counter = note_counter + 1;
            end

            if note_found > len && turn_around == false
                if direction == FWD
                    break;
                else
                    change = -1;
                    turn_around = true;
                end
            end
						
            if turn_around == true && counter == 1
                break;
            end
						
            octave_no = floor((SEMI_TONES + counter + ...
                transposed - 1) / SEMI_TONES);  
            
            if show_octaves == true
                if direction == REV && turn_around == false
                    % Wait...
                else
                    scale_inc(note_counter) = (mod((counter - 1 + ...
                        transposed), SEMI_TONES) + 1) + ...
                        ((octave_no - 1) * SEMI_TONES);
                end
            end
            
            if direction == REV && turn_around == false
                % Wait...
            else
                scale(note_counter) = mod((counter - 1 + transposed), ...
                    SEMI_TONES) + 1;

                note_name{note_counter} = [noteletters{mod((counter - 1 + ...
                    transposed), SEMI_TONES) + 1}, num2str(octave_no)];
            end
        end

        if turn_around == true && counter == 1
            break;
        end

        % TODO: Counter problem (one too much) in REV and PND mode
        %   with chords that have an odd number of notes.
        % TODO: Make sure that tonic is always repeated after two octaves?
        if turn_around == false
            if p == chord_lengths(chord_number)
                p = (chord_lengths(chord_number) - SEMI_TONES) + 1;
            else
                p = p + 1;
            end
        else
            if p == (chord_lengths(chord_number) - SEMI_TONES) + 1
                p = chord_lengths(chord_number);
            else
                p = p - 1;
            end				
        end
    end

    createfigure(FIGURE_NAME);

    if show_octaves == true
        h1 = bar(scale_inc);
        hold on;
    end
    
    h2 = bar(scale);
    hold off;
    
    if show_octaves == true
        set(h1, 'FaceColor', [0.46 0.67 0.88]);
        set(h1, 'EdgeColor', 'blue');
        set(h1, 'BarWidth', 0.75);
    end

    if show_octaves == true
        set(h2, 'FaceColor', [0.82 0.97 0.97]);
    else
        set(h2, 'FaceColor', [0.46 0.67 0.88]);
    end
    
    set(h2, 'EdgeColor', 'blue');
    set(h2, 'BarWidth', 0.5);
  
    set(gca, 'XTickLabel', note_name);
    set(gca, 'YGrid', 'on');
	
    if direction == FWD
        set(gca, 'XTick', 1:len);
        xlim([0, len + 2]);
    elseif direction == REV
        if mod(length(note_name), 2) > 0
            set(gca, 'XTick', 1:len + 1);
        else
            set(gca, 'XTick', 1:len);
        end
    
        xlim([0, len + 2]);
    else
        set(gca, 'XTick', 1:((len * 2) + mod(numel(note_name), 2)));
        xlim([0, (len * 2) + 2]);
    end
	
    if show_octaves == true
        set(gca, 'YTick', 0:12:max(scale_inc) + 1);
        ylim([0, max(scale_inc) + 1]);
    else
        set(gca, 'YTick', 1:SEMI_TONES);
        ylim([0, SEMI_TONES]);        
    end
    
    box off;
	
    the_title = strcat(FIGURE_NAME, ' [', ...
        noteletters{transposed + 1}, ...
        chord_names{chord_number}, ']');

    enhancefigure(the_title, strcat( ...
        noteletters{transposed + 1}, chord_names{chord_number}, ...
        ' chord'), 'Note number');
end

%function number = reverse_bits(number, len)
%	ret_number = 0;
%	p = 1;
%	
%	for i = len:-1:1
%			ret_number = bitset(ret_number, p, bitget(number, i));
%			p = p + 1;
%	end
%
%	fprintf('Num: %d, reversed: %d\n', number, ret_number);
%end
