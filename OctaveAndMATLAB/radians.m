function radians()
%RADIANS Display radians for clock minutes
%   This indented text is what shows up when you type HELP, above line
%   shows up in the LOOKFOR command.

    FIG_NAME = 'Radians';
    iX_Center = 0;
    iY_Center = 0;
    dAspectRatio = 1;
    iRadius = 57;

    % Plot graph, create a new named figure
    createfigure(FIG_NAME, true);
    
    hold on;

    for m = 1:60
        dRadian = ((m * (360 / 60)) + 90) * (pi / 180.0);
        iX1 = iX_Center; % - floor(cos(dRadian));
        iY1 = iY_Center; % - floor((sin(dRadian) * dAspectRatio));
        iX2 = iX_Center - floor((cos(dRadian) * ...
            (iRadius - (iRadius / 6))));
        iY2 = iY_Center - floor((sin(dRadian) * ...
            (iRadius - (iRadius / 6)) * dAspectRatio));

        pos1 = [iX1 iX2];
        pos2 = [iY1 iY2];

        h = line(pos1, pos2);
        
        if ismatlab()
          set(h, 'LineSmoothing', 'on');
        end
    end

    axis square
    title('The clock... sorta...');
end
