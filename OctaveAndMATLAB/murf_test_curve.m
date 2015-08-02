function [ret] = murf_test_curve()
	createfigure('MuRF Pot Pos Curve');
	clf;
	
	curve = 50 - (([50:-1:1 1:50].^2) / 50);
	plot((curve), 'b-');
	hold on;
	curve = 50 - (([50:-1:1 1:50].^2) / 70);
	grid;
	plot((curve), 'r-');
	hold off;
	xlim([1, 100]);
	enhancefigure('MuRF Pot Pos Curve', 'Time/Counter', 'Curve Percent');
end

function [ret] = murf_test_curve_t()
	createfigure('MuRF Pot Pos Curve');
	clf;
	
	max_pot_pos = 10;
	
	curve = (5 - (([5:-1:1 1:5].^2) / 5)) * max_pot_pos;
	plot((curve), 'b-');
	hold on;
	curve = (5 - (([5:-1:1 1:5].^2) / 7)) * max_pot_pos;
	grid;
	plot((curve), 'r-');
	hold off;
	xlim([1, 10]);
	enhancefigure('MuRF Pot Pos Curve', 'Time/Counter', 'Curve Percent');
end

