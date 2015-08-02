function createsinuscurve()
%CREATESINUSCURVE Creates and plot a sinus curve

    %n = 0:0.1:2*pi;
    %plot(sin(n), 'ob-');
    %grid on;
    %grid minor;

    t = 0:.001:1;       % independent (time) variable
    A = 1;              % amplitude
    f = zeros(1, 6);    % odd frequencies
    s = zeros(1, 101);   % empty 'signal' vector to start with
    %s = 0;

    figure

    % for each frequency, create the signal and add it into s(t)
    for count = 1:6
        s = s + A * sin(2 * pi * f(count) * t) / f(count);
        subplot(6, 1, count)
        plot(t, s);
        ylabel('Amplitude')
    end

    subplot(6, 1, 1)
    title('Cumulatively summing sine waves')
    subplot(6, 1, 6)
    xlabel('Time (s)')
