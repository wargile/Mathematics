function set_gridcolor()
% Hack for fixing the terrible MatLab default grid color...
% But this messes up the magnification/zoom!
    if ismatlab()
        set(gca,'Xcolor',[0.85 0.85 0.85])
        set(gca,'Ycolor',[0.85 0.85 0.85])
        c_axes = copyobj(gca, gcf);
        set(c_axes, 'color', 'none', 'xcolor', 'k', 'xgrid', 'off', ...
            'ycolor','k', 'ygrid','off');
    end
end
