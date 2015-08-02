function [trig_signals, counter] = accelerator(max_value)
%ACCELERATOR Create an accelerating trigger signal curve
%   ACCELERATOR creates a trigger curve that is accelerating and
%   de-accelerating from 4 to parameter MAX_VALUE. For best results,
%   use a MAX_VALUE between 5 and 25.
%
%   See also: simple_clock

%   Copyright (C) Terje B. 2011

	if nargin == 0
		fprintf('Using default max_value of 16.\n');
		max_value = 16;
	end
	
	if nargin == 1 && (max_value < 5 || max_value > 25)
		fprintf('For best results, use a max_value between 5 and 25.\n');
		fprintf('Adjusting value to default 16.\n');
		max_value = 16;
	end
	
    FIG_NAME = 'Accelerator';

	createfigure(FIG_NAME, false);

	[trig_signals_temp, counter] = do_accelerator(1, max_value);
	trig_signals = trig_signals_temp;
	subplot(2, 1, 1);
	stairs(trig_signals_temp, 'Color', [0.56, 0.18, 0.56]);
	hold on;
	
	[trig_signals_temp, counter] = do_accelerator(-1, max_value);
	trig_signals = [trig_signals, trig_signals_temp];
	
	stairs(trig_signals_temp + 150, 'Color', [0.18, 0.56, 0.56]);
	enhancefigure('Accelerator', 'Phase/time', 'Triggers'); 
	xlim([0, counter + 1]);
    box off;
	hold off;

	subplot(2, 1, 2);
	stairs(trig_signals); % Plot complete graph
	enhancefigure('', 'Phase/time', 'Triggers'); 
	xlim([0, (counter * 2) + 1]);
    box off;
end

function [trig_signals, counter] = do_accelerator(direction, max_value)
    MAX_INTERVALS = 5;
    VAL = 2; % NOTE: Minimum value = 2
    MAX_STEPS = VAL * 16;
	MAX_VALUE = max_value;
	counter = 1;
    
    trig_signals = zeros(1, MAX_VALUE * MAX_INTERVALS);
    %steps = [VAL, VAL * 2, VAL * 4, VAL * 8, VAL * 16];
    step_values = [VAL * 32, VAL * 16, VAL * 8, VAL * 4, VAL * 2];

	if direction == 1
		start = 4;
		stop = MAX_VALUE;
	else
		start = MAX_VALUE;
		stop = 4;
	end
	
	for maxcount = start:direction:stop
		for p = 1:MAX_INTERVALS
			for cc = 1:maxcount
				if cc > round(maxcount / 2) % Trig off
					trig_signals(counter) = step_values(p) * -1;
				end
				
				if cc <= round(maxcount / 2) % Trig on
					trig_signals(counter) = step_values(p);
				end

				counter = counter + 1;
			end
		end
	end
end