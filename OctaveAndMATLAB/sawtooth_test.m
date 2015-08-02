function h = sawtooth_test(numrange, freq)
%SAWTOOTH_TEST Plots a sawtooth wave from a numeric range
%
% http://en.wikipedia.org/wiki/Sawtooth_wave
    
    FIG_NAME = 'Sawtooth';
    
    if nargin == 0
        numrange = 1:100;
        freq = 15;
    end
    
    a = zeros(1, length(numrange));
    
    for t = 1:length(numrange)
        % a(t) = (t / freq) - floor(t / freq);
        a(t) = 2 * ((t / freq) - floor((t / freq) + (1 / 2)));
    end
    
    % Create a new named figure
    createfigure(FIG_NAME, true);

    h_plot = plot(a);
    
    if ismatlab()
      set(h_plot, 'LineSmoothing', 'on');
    end

    h = a;
end

