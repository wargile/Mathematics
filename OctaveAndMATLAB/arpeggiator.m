function [scale, xlabels, trace_out] = arpeggiator(varargin) 
%ARPEGGIATOR Creates a scale of notes from a voltage curve.
%
%   ARPEGGIATOR([curve_type],[transposed],[octave],
%     [rounds],[selected notes],[min_voltage],[max_voltage],
%     [do_chord],[selected_chord])
%
%   Parameters:
%     curve_type: Select 'tri' or 'saw' curve types. Triangle
%       is default if curve type is not specified.
%     transposed: Set starting note, values 0 to 11.
%     octave: Set start octave.
%     rounds: Set number of rounds to repeat pattern.
%     selected notes: Array with 12 elements. 1 = selected,
%       0 = not selected
%     min_voltage: minimum voltage, default 0
%     max_voltage: maximum voltage, default 5
%     do_chord: true: Do chord, false: Do generic arpeggiate
%       based on settings in selected_notes array
%     selected_chord: Select chord type 1 - 8
%
%   Example:
%     arpeggiator('saw', 8, 3, 2, [1 1 1 0 1 1 1 0 1 1 0 1],
%       0, 5, true, 4); 
%
%   Returns:
%     scale: Note values
%     xlabels: The x-axis note name labels
%     trace_out: Note info. Tip: Use trace_out{:} to list all.
%
%   TODO: - RAMP mode (reverse)
%         - Ability to select 'repeat yes/no' of first/last note for PND
%
%   See also: ARPEGGIATOR_TEST

%   Copyright (C) T. Bakkelokken 2010-2011

  REF_VOLTAGE = 5;
  FIG_NAME = 'Arpeggiator';
  
  max_voltage = 5;
  min_voltage = 0;
  curve_type = 'saw';
  rounds = 1;
  transposed = 0;
  octave = 1;
  notes_selected = [1 1 1 0 1 0 1 1 0 1 1 1];
  selected_chord = 4;

  % TODO: Use 12-bit values to indicate which notes should sound
  chords = { '', '6', 'm', '7', '9', 'm7', 'm9', 'dim7', 'maj7', ...
    'sus4', '7sus4', 'aug5' };

  chord_notes = ...
  [
    bin2dec('000000010010001'), ... % major
    bin2dec('000001010010001'), ... % major6
    bin2dec('000000010001001'), ... % m
    bin2dec('000010010010001'), ... % 7
    bin2dec('100010010010001'), ... % 9
    bin2dec('000001010001001'), ... % m6
    bin2dec('000010010001001'), ... % m7
    bin2dec('100010010001001'), ... % m9
    bin2dec('000001001001001'), ... % dim7
    bin2dec('000100010010001'), ... % maj7
    bin2dec('000000010100001'), ... % sus4
    bin2dec('000010010100001'), ... % 7sus4
    bin2dec('000000100010001') ... % aug5
  ];
  
  if nargin > 0
    curve_type = varargin{1};
  end
  
  if nargin > 1
    transposed = varargin{2};
  end
  
  if nargin > 2
    octave = varargin{3};
  end
  
  if nargin > 3
	if varargin{4} < 1
      error('Rounds value must be larger than zero.');
	end

    rounds = varargin{4};
  end
  
  if nargin > 4
    if numel(varargin{5}) ~= 12
      error('notes_array element count error.');
    end
    
    notes_selected = varargin{5};
  end
  
  if nargin > 5
    min_voltage = varargin{6};
  end
  
  if nargin > 6
    max_voltage = varargin{7};
  end
  
  if nargin > 7
    do_chord = varargin{8};
  end
  
  if nargin > 8
    selected_chord = varargin{9};
  end
  
  if transposed > 11 || transposed < 0
    error('Invalid transposed value. Valid tranpose values are 0 to 11.');
  end
  
  if octave > 9 || octave < -2
    error('Invalid octave value. Valid octave values are -2 to 9.');
  end

  semi_tones = 12;
  step = REF_VOLTAGE / semi_tones;
  old_current_note = 0;
  counter = 1;
  interval = 0.2;
  noteletters = { 'C', 'Db', 'D', 'Eb', 'E', 'F', ...
    'Gb', 'G', 'Ab', 'A', 'Bb', 'B' };
  
  if strcmp(curve_type, 'saw') > 0
    volt_range = min_voltage:interval:max_voltage;
    scale = zeros(1, rounds * semi_tones);
    xlabels = cell(1, rounds * semi_tones);
    trace_out = cell(1, rounds * semi_tones);
  else
    volt_range = [min_voltage:interval:max_voltage, ...
      max_voltage:-interval:min_voltage];
    scale = zeros(1, rounds * (semi_tones + (semi_tones - 1)));
    xlabels = cell(1, rounds * (semi_tones + (semi_tones - 1)));
    trace_out = cell(1, rounds * (semi_tones + (semi_tones - 1)));
  end
  
  % Init the xlabels
  for i = 1:numel(xlabels)
    xlabels{i} = '-';
  end

  for p = 1:rounds
    for i = 1:length(volt_range)
      current_note = ceil(volt_range(i) / step);
		
      if current_note ~= old_current_note && current_note > 0
        if (current_note + transposed) <= semi_tones
          display_note = mod(current_note + transposed, semi_tones + 1);
        else
          display_note = mod(current_note + transposed, ...
            semi_tones + 1) + 1;
        end

        disp_octave = floor(((octave * semi_tones) + current_note + ...
          transposed - 1) / semi_tones);
        
        % Let's return some debug/trace info
        trace_out{counter} = ...
          sprintf('oct:%d step:%2d trans:%d disp:%d %s', ...
          disp_octave, (current_note) + transposed, transposed, ...
            display_note, noteletters{display_note});

        if do_chord == true
            if bitget(chord_notes(selected_chord), current_note) == 1
                scale(counter) = current_note;
            end
        else
            if notes_selected(display_note) == 1
				scale(counter) = current_note;
            end
        end
        
        %xlabels{counter} = sprintf('%s%d', ...
          %noteletters{display_note}, disp_octave);
        xlabels{counter} = strcat(noteletters{display_note}, ...
          num2str(disp_octave));
        counter = counter + 1;
      end
		
      old_current_note = current_note;
    end
  end
  
  % Create a new named figure. Code in createfigure.m
  createfigure(FIG_NAME, true);
    
  if strcmp(curve_type, 'saw') > 0
    h = bar(1:(rounds * semi_tones), scale);
    
    if rounds < 3
      set(gca, 'XTick', 1:(rounds * semi_tones));
    end
  else
    h = bar(1:rounds * (semi_tones + (semi_tones - 1)), scale);
    %h = stem(1:rounds * (semi_tones + (semi_tones - 1)), scale);
    
    if rounds < 2
      set(gca, 'XTick', 1:((rounds * semi_tones) + ...
          (rounds * (semi_tones - 1))));
    end
  end
  
  set(h, 'FaceColor', [0.46 0.67 0.88]);
  set(h, 'EdgeColor', 'blue');
  set(gca, 'Color', [0.92, 0.99, 0.95]);
  set(gca, 'YTick', 1:semi_tones);
  
  if (rounds < 3 && strcmp(curve_type, 'saw') > 0) || ...
      (rounds < 2 && strcmp(curve_type, 'tri') > 0)
    set(gca, 'XTickLabel', xlabels);
  end
  
  the_title = 'Arpeggiator';
  
  if do_chord == true
    the_title = strcat(noteletters{transposed + 1}, ...
        chords{selected_chord}, ' Oct:', num2str(disp_octave));
  end
  
  enhancefigure(the_title, 'Selected notes', 'Octave');

  grid off;
  box off;
  ylim([0, semi_tones + 1]);
  set(gca, 'YGrid', 'on');
end
