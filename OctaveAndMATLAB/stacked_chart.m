function stacked_chart
%STACKED_CHART Stacked chart example.

	data = [18 19 23 45; 22 8 44 66; 15 16 17 18; 22 47 81 53];
	
	createfigure('Stacked Chart', false);

	subplot(1,2,1);
	barh(data, 0.5, 'stacked');
	enhancefigure('Stacked Chart Example', 'ages', 'age groups');
	
    if ismatlab
        set(gca, 'yticklabel', {'gr1', 'gr2', 'gr3', 'gr4'});    
    else
        set(gca, 'yticklabel', {'', 'gr1', 'gr2', 'gr3', 'gr4', ''});
    end
    
	grid;
	
	subplot(1,2,2);
	pie([22 44 55 76 32], [1 1 1 1 1], {'a', 'b', 'c', 'd', 'e'});
	enhancefigure('Exploded Pie Chart Example');
	
	if ~ismatlab % Pie axis always off in MatLab
		axis off;
	end
end
