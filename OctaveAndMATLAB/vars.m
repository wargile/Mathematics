% Script for handy constants and calculations.
% Usage from command line: run 'C:\coding\octave\vars.m'
%
% Save loaded vars to file:
% save -mat variables.mat REF_VOLTAGE DAC* VOLT* max* rand* volt*
% 
% TIP: find out if a variable is in memory:
% ismember('MAX_MIDI_NOTE', who())

%% Some constants
MAX_MIDI_NOTE = 127;
SEMITONES_IN_OCT = 12.0;
VOLT_PR_NOTE = 1.0 / SEMITONES_IN_OCT; % Using 1V/OCT as standard
REF_VOLTAGE_MIDI_RANGE = (MAX_MIDI_NOTE + 1) * VOLT_PR_NOTE;
REF_VOLTAGE = 5.0;
DAC_TEN_BIT = (2^10) - 1; % hex2dec('0x3ff'); 
DAC_TWELVE_BIT = (2^12) - 1; % hex2dec('0xfff'); 
DAC_SIXTEEN_BIT = (2^16) - 1; % hex2dec('0xffff'); 
TMR8_OVERFLOW = (2^8) - 1;
TMR16_OVERFLOW = ((TMR8_OVERFLOW + 1)^2) - 1;
PITCH_CONCERT_A = 440;
NOTENUMBER_CONCERT_A = 69;
F_OSC = 8000000;
T_OSC = F_OSC / 4;

max_voltage_out = REF_VOLTAGE; 
max_dac_value_10bit = (max_voltage_out * (DAC_TEN_BIT / REF_VOLTAGE)); 
max_dac_value_12bit = (max_voltage_out * (DAC_TWELVE_BIT / REF_VOLTAGE)); 
max_dac_value_16bit = (max_voltage_out * (DAC_SIXTEEN_BIT / REF_VOLTAGE));

%% Various anonymous functions
% The frequency in Hz for a MIDI note number
F_NOTE_FREQUENCY = @(x) (2 ^ ((x - NOTENUMBER_CONCERT_A) / ...
	SEMITONES_IN_OCT)) * PITCH_CONCERT_A;
	
% The note number in the octave
F_NOTE_NO_IN_OCT = @(x) mod(x, SEMITONES_IN_OCT) + 1;

% DAC value for a given voltage
F_DAC10_VALUE_FOR_VOLTAGE = @(x) round(x * (DAC_TEN_BIT / REF_VOLTAGE));
F_DAC12_VALUE_FOR_VOLTAGE = @(x) round(x * (DAC_TWELVE_BIT / REF_VOLTAGE));
F_DAC16_VALUE_FOR_VOLTAGE = @(x) round(x * (DAC_SIXTEEN_BIT / REF_VOLTAGE));

% DAC value for a MIDI note number
F_DAC10_VALUE_FOR_NOTE_NO = @(x) round((x * VOLT_PR_NOTE) * ...
	(DAC_TEN_BIT / REF_VOLTAGE_MIDI_RANGE));
F_DAC12_VALUE_FOR_NOTE_NO = @(x) round((x * VOLT_PR_NOTE) * ...
	(DAC_TWELVE_BIT / REF_VOLTAGE_MIDI_RANGE));
F_DAC16_VALUE_FOR_NOTE_NO = @(x) round((x * VOLT_PR_NOTE) * ...
	(DAC_SIXTEEN_BIT / REF_VOLTAGE_MIDI_RANGE));
    
% Bit get/set functions
GET_BIT = @(val, bit) bitand(bitshift(val, -(bit - 1)), 1);
% NOTE: Set bit to 1 only
SET_BIT = @(number, bit) bitor(number, bitshift(1, (bit - 1)));

% Smart way to generate PI (NOTE: MATLAB/Octave only!):
% PI = abs(log(-1));
% The natural logarithm of a number x is the power to which e would have
% to be raised to equal x. e = 2.718281828 (Euler's number, which is NOT
% the same as Euler's constant).
% Example: log(7.38905609893065) is 2, because e^2 = 7.38905...

%% Radians/degrees conversion (1 radian = 57.295779513082323 degrees)
radian = 1 * (180 / pi);
radians_to_degrees = @(radian) radian * (180 / pi); 
degrees_to_radians = @(degrees) degrees / (180 / pi);

%% Random numbers 1-8
randomnumbers = zeros(1, 8);

for i = 1:8
	if ~ismatlab
		randomnumbers(i) = ceil(rand * 8);
	else
		randomnumbers(i) = randi(8);
	end
end

%% Plot equation
%a = 1:10;
%b = '3 * a + 10';
%xlabel('A = 1:10');
%ylabel('B = 3 * A + 10');
%plot(a, eval(b), '-*r');
%plot(randomnumbers, '-or');
%grid('on');
%grid('minor');

%% A simple toascii() macro, since it oddly doesen't exist in MatLab...
% toascii = @(a) (a + 0);
% Can also do: double('A'); ans = 65

%% Finding the magnitude of a vector
% Vector magnitude is the square root of the vector's dot product.
% (Dot product is multiplying with itself or another vector's same element)
mag = @(v) sqrt(sum(v.*v));

%% Cross product of two vectors
v1 = [1.53, 0.22, 0.65];
v2 = [-0.82, -1.88, -1.04];
v3 = cross(v1, v2);

%% Finding the determinant of a matrix
v1 = [1, 2; 3, 4];
determinant = det(v1); % d = (1*4)-(2*3)

volt_array = (1:MAX_MIDI_NOTE);

for i = 1:MAX_MIDI_NOTE + 1
    voltage_out = (i - SEMITONES_IN_OCT) * VOLT_PR_NOTE;
    volt_array(i) = floor((voltage_out + 1) * (DAC_TWELVE_BIT / ...
		REF_VOLTAGE_MIDI_RANGE));
end    

%% Save most of what we've got
save -mat variables.mat REF_VOLTAGE DAC* VOLT* max_* random* volt* TMR* ...
	NOTENUM* PITCH* SEMI*
