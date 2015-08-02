function B = plotstuff()
%PLOTSTUFF Plots sine/cosin, bessel, pentagon etc.

    hold off; % Clear previous plot
    clf;
    
    % BesselJ curve
    subplot(2, 2, 1);
    a = 1:0.2:50;
    B = besselj(0, a);
    plot(B, 'b-');
    hold on;

    %% BesselY curve
    a = 0:0.2:50;
    B = bessely(0, a);
    plot(B, 'm-');

    %% Sine wave
    B = 0:0.1:8*pi;
    %max_y = max(B);
    %min_y = min(B);
    plot(sin(B), 'r-');

    %% Cosine wave
    plot(cos(B), 'g-');
    grid off;
    box off;
    ylim([-1.3, 1.3]);
    axis tight;
    hold off;
    
    %% Plot a pentagon
    % (Nicked from: Mathematica doc Visualization and Graphics, page 41)
    subplot(2, 2, 2);
    n = 0:5; % > 6 elements: Graph line goes round and round...
    a = sin(2 * pi * (n / 5));
    b = cos(2 * pi * (n / 5));
    area(a * 5, b * 5); % 'Faces', 'c', 'Vertices', 'm');
    hold on;
    area((a * 2) + 5, (b * 2) + 5); % 'Faces', 'c', 'Vertices', 'm');
    hold off;
    %plot(a, b, 'bo-');
    axis equal;

    %% Plot a hexagon
    % (Nicked from: Mathematica doc Visualization and Graphics, page 53)
    subplot(2, 2, 3);
    n = 0:6; % > 6 elements: Graph line goes round and round...
    a = sin(pi / 3 * n);
    b = cos(pi / 3 * n);
    area(a * 5, b * 5); % 'Faces', 'c', 'Vertices', 'm');
