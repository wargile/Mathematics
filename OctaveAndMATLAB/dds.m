function [freq_reg, phase_reg, output_amplitude] = ...
		 dds(frequency, phase_radians = 0)
%DDS calculates the frequency register and phase register values
%for the AD9883 circuit.
%
%
% FOUT = (M (REFCLK)) / 2^N
% Where: FOUT = the output frequency of the DDS
%        M = the binary tuning word
%        REFCLK = the internal reference clock frequency
%        N = The length in bits of the phase accumulator
%
%Usage: DDS(<frequency in Hz>, [phaseshift in radians])

  if nargin == 0
	 error 'Usage: DDS(<frequency in Hz>, [phaseshift in radians])'
  end

  MCLK = 1000000; % The oscillator (DDS external clock input) in Hz
  ACCUMULATOR_BIT_LENGTH = 28;

  % Calculate freq reg value based on desired frequency input (in Hz)
  freq_reg = round((frequency * 2^ACCUMULATOR_BIT_LENGTH) / MCLK)

  % Calculate phase_reg value based on desired phase shift (in radians)
  phase_reg = round((phase_radians * 4096) / (2 * pi))

  % Calculate output amplitude
  format long;

  output_amplitude = sin((pi * frequency) / MCLK) / ...
					 ((pi * frequency) / MCLK)

  format short;
