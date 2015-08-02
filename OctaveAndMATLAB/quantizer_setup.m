function [current_menu, current_value, note_value, chord_value] = ...
	quantizer_setup(current_menu, current_value, note_value, chord_value)
%QUANTIZER_SETUP Test of possible LCD menu system for Quantizer module.	
	CHORD_MENU = 3;
	% TRANSPOSE_MENU = 2;
	MAX_VALUES = [10, 11, 20, 4]; % menu value range
	MIN_VALUES = [0, 0, 1, 1]; % menu value range
	
	the_menu = {'Octave', 'Transpose', 'Chord', 'Direction'};
	MAX_MENUS = length(the_menu); % main menus, TODO: Use constant/#define
	
	% chord_notes = [1, 4, 8, 0; 1, 4, 8, 11]; 
	
	chords = { 'm', 'm7', 'm9', 'maj7', 'maj9', 'sus4', '7sus4', ...
		'aug5', '7aug5', 'dim7', '7', '13' };	

	noteletters = { 'C', 'C#', 'D', 'D#', 'E', 'F', ...
		'F#', 'G', 'G#', 'A', 'A#', 'B' };	

	if current_menu < 1
		current_menu = MAX_MENUS;
	end
		
	if current_menu > MAX_MENUS
		current_menu = 1;
	end

	if current_value > MAX_VALUES(current_menu) || ...
		current_value < MIN_VALUES(current_menu)
		warning(1, 'Invalid menu value: %d', current_value);
	end
	
	fprintf('\nMenu: %s, value: %d\n', the_menu{current_menu}, ...
        current_value);
	fprintf('Value range: MIN = %d, MAX = %d\n\n', ...
        MIN_VALUES(current_menu), MAX_VALUES(current_menu));
		
	if current_menu == CHORD_MENU
		fprintf('Chord: %s%s\n', noteletters{note_value}, ...
            chords{chord_value});
	end
end
