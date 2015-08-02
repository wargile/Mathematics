% Terje's custom startup parameters

if ismatlab
    set(0, 'DefaultFigureWindowStyle', 'docked'); % Always dock figures
end

% dbstop if error; % Always stops at error line in code if error

userpath='C:/coding/Octave';
chdir 'c:/coding/Octave'
clc
if ~ismatlab
    graphics_toolkit('fltk');
end
