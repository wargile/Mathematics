function [step_values, step_status, step_info, direction, note_length] = ...
  four_channel_sequencer(varargin)
%FOUR_CHANNEL_SEQUENCER creates a 4 channel sequencer pattern from input data.
%  Parameters:
%    direction (1=FWD,2=REV,3=PND,4=RND), step_status (1x8 array),
%    max_steps, step_min, step_max, next_step (1x8 array),
%    note_length (1x8 array)
%
%  Returns:
%    [step_values, step_status, step_info, direction, note_length]
%
%  TODO: Manual GOTO code?
  
  %% Set constant values and assign defaults to variables
  global FORWARD = 1;
  global REVERSE = 2;
  global PENDULUM = 3;
  global RANDOM = 4;
  global RUN = 1;
  global SKIP = 2;
  global RESET = 4;
  global STOP = 8;
  global DIRECTION_FORWARD = 1;
  global DIRECTION_REVERSE = -1;
  STEPS_STANDARD = 8;
  FIG_NAME = 'Sequencer';

  global MAX_CHANNELS = 4;

  global step_min = 1;
  global step_max = 8;
  global max_steps = 8;
  global direction = [REVERSE, FORWARD, FORWARD, FORWARD];
  global step_status = zeros(MAX_CHANNELS, max_steps);
  global next_step = zeros(MAX_CHANNELS, max_steps);
  global note_length = zeros(MAX_CHANNELS, max_steps);
  global step_at_step = zeros(MAX_CHANNELS, max_steps);
  global step_change = zeros(1, MAX_CHANNELS);
  global current_step = zeros(1, MAX_CHANNELS);
  global is_stop_at_step = zeros(1, MAX_CHANNELS);
  global reset = zeros(1, MAX_CHANNELS);

  directions = [FORWARD, REVERSE, PENDULUM, RANDOM];
  directions_display = {'FORWARD', 'REVERSE', 'PENDULUM', 'RANDOM'};

  x_ticklabels = cell(1, max_steps);
  step_values = zeros(4, max_steps);

  for p = 1:MAX_CHANNELS
	for i = 1:step_max
	  step_status(p, i) = RUN;
	  next_step(p, i) = i + 1;
	  note_length(p, i) = 4;
	  step_at_step(p, i) = 1;
	end
	
	next_step(p, step_max) = 1;
	
	is_stop_at_step(p) = 0;
	reset(p) = 0;
	
	if direction(p) == FORWARD || direction(p) == PENDULUM
      step_change(p) = DIRECTION_FORWARD;
      current_step(p, 1) = step_min - 1;
	else
      step_change(p) = DIRECTION_REVERSE;
      current_step(p, 1) = step_max + 1;
	end

	fprintf('\nDirection: %d:%d\n', p, direction(p));
	fprintf('\nDirection: %s\n', directions_display{direction(p)});
  end

  %is_matlab = ~isempty(strfind(version, '2010'));
  
  %% Validate input params, other init
  if nargin > 0
    if ~ismember(varargin{1}, directions)
      error(['Invalid direction. Use values 1 (FORWARD), ', ...
        '2 (REVERSE), 3 (PENDULUM), 4 (RANDOM).']);
    end
    
  	direction = varargin{1};
  end

  if nargin > 1
    if numel(varargin{2}) < step_max
      error('Invalid step value array.');
    end
    
    step_status = varargin{2};
  end

  if nargin > 2
    if varargin{3} > 64 || varargin{3} < step_max
      error('Invalid max number of steps value.');
    end

    max_steps = varargin{3};
  end
  
  if nargin > 3
    step_min = varargin{4};
  end
  
  if nargin > 4
    step_max = varargin{5};
  end
  
  if step_max <= step_min || step_max > numel(step_status)
    error('Invalid min/max step values.');
  end

  if nargin > 5
    if numel(varargin{6}) < step_max
      error('Invalid next step value array.');
    end
      
    next_step = varargin{6};
  end
  
  step_info = cell(MAX_CHANNELS, max_steps);

  for i = 1:MAX_CHANNELS
	is_stop_at_step(i) = 0;
	reset(i) = 0;
	
	if direction(i) == FORWARD || direction(i) == PENDULUM
      step_change(i) = DIRECTION_FORWARD;
      current_step(i) = step_min - 1;
	else
      step_change(i) = DIRECTION_REVERSE;
      current_step(i) = step_max + 1;
	end
  end

  
  %% Test to see if any step_status have RUN status. If not, bail out
  
  % C way:
  % run_status_found = 0;
  
  % for i = 1:step_max
  %   if step_status(i) == RUN
  %     run_status_found = 1;
  %     break;
  %   end
  % end
  
  % if run_status_found == 0
  %   error('No step_status found with RUN status!');
  % end
  
  % MATLAB way:
  for p = 1:MAX_CHANNELS
	if ~ismember(step_status(p), RUN)
      error('No step_status found with RUN status!');
	end
  end

  %% For loop with next step check
  for p = 1:MAX_CHANNELS
	for i = 1:max_steps

      %% Display info and assign to return vars
      if step_change(p) == 1
		dir_sign = '>>';
      else
		dir_sign = '<<';
      end

      if direction(p) == RANDOM
		dir_sign = '<>';
      end

	  % Find next step for selected channel
	  find_next_step(p);

      if current_step(p) >= step_min && current_step(p) <= step_max && ...
        (step_status(p, current_step(p)) == RUN || ...
        step_status(p, current_step(p)) == STOP)
		step_values(p, i) = current_step(p);

		if max_steps > 24
          x_ticklabels{i} = sprintf('%d', current_step(p));
		else
          x_ticklabels{i} = sprintf('%d%s', current_step(p), dir_sign);
		end

		step_info{p, i} = sprintf('%d:[%d] %s', i, current_step(p), dir_sign);
		fprintf('%2d:[%d] %s ', i, current_step(p), dir_sign);
      end

      if mod(i, 8) == 0
		fprintf('\n\n');
      end
	end % End for i = 1:max_steps

	if mod(i, 8) ~= 0
      fprintf('\n\n');
	end
  end % End for p = 1:MAX_CHANNELS
  
  
  %% Plot the pattern
  
  % Create a new named figure. Code in createfigure.m
  createfigure(FIG_NAME, false);

  h = bar(step_values);

  set(gca, 'FontSize', 8, 'FontWeight', 'normal');
  ylabel('Steps');
  xlabel(['The sequencer pattern (direction: ', ...
    directions_display{direction}, ', ', ...
	int2str(max_steps), ' steps selected)']);
  set(h, 'FaceColor', [0.16 0.68 0.60]);
  set(h, 'EdgeColor', 'black', 'LineWidth', 1, 'LineStyle', '-');
  set(gca, 'Color', [0.92, 0.99, 0.95]);
  set(gca, 'YTick', 1:STEPS_STANDARD);
  set(gca, 'XTick', 1:max_steps);
  set(gca, 'XTickLabel', x_ticklabels);
  set(gca, 'YLim', [0, STEPS_STANDARD]);

  title(FIG_NAME, 'FontWeight', 'bold', 'FontSize', 11, ...
    'Color', 'black')
  grid off;
  box off;
  set(gca, 'YGrid', 'off');
  
end % End function


function find_next_step(channel)
  %% Set constant values and assign defaults to variables
  global FORWARD = 1;
  global REVERSE = 2;
  global PENDULUM = 3;
  global RANDOM = 4;
  global RUN = 1;
  global SKIP = 2;
  global RESET = 4;
  global STOP = 8;
  global DIRECTION_FORWARD = 1;
  global DIRECTION_REVERSE = -1;
  STEPS_STANDARD = 8;
  FIG_NAME = 'Sequencer';

  global MAX_CHANNELS = 4;

  global step_min = 1;
  global step_max = 8;
  global max_steps = 8;
  global direction = [REVERSE, FORWARD, FORWARD, FORWARD];

  global step_status;
  global next_step;
  global note_length;
  global step_at_step;
  global step_change;
  global current_step;
  global is_stop_at_step;
  global reset;

  %printf("Step status: %d", step_status(2,1));

    breakout_counter = 0;

    % START Copy this code for checking a single step
    if direction(channel) == RANDOM
      while true
        % current_step = randi(step_max); % NOTE: MATLAB only
        current_step(channel) = floor(rand(1) * step_max) + 1;

        if step_status(channel, current_step(channel)) == RUN
          break;
        end
      end
    else    
      while true
        breakout_counter = breakout_counter + 1;

        % To prevent eternal loops...
        if breakout_counter > (step_max * 2)
          break;
        end

        % Do next_step check only if we're in FORWARD mode
        if direction(channel) == FORWARD && current_step(channel) > 0 && ...
            (step_status(channel, current_step(channel)) ~= SKIP && ...
            step_status(channel, current_step(channel)) ~= STOP)
          %if next_step(current_step) ~= current_step
            current_step = next_step(channel, current_step(channel));
          %end
        else
		  if is_stop_at_step(channel) == 0
			current_step(channel) = current_step(channel) + step_change(channel);
        end
		  
		end

        if current_step(channel) > step_max
          if direction(channel) == PENDULUM && reset(channel) == 0
            current_step(channel) = step_max;
            step_change(channel) = DIRECTION_REVERSE;
          else
            current_step(channel) = step_min;
          end
        end

        if current_step(channel) < step_min
          if direction(channel) == PENDULUM && reset(channel) == 0
            current_step(channel) = step_min;
            step_change(channel) = DIRECTION_FORWARD;
          else
            current_step(channel) = step_max;
          end
        end

        if step_status(channel, current_step(channel)) == STOP || ...
            step_status(channel, current_step(channel)) == RUN
          if step_status(channel, current_step(channel)) == STOP
            is_stop_at_step(channel) = 1;
          end

          break;
        end

        if step_status(channel, current_step) == RESET
          if direction(channel) == FORWARD
            current_step(channel) = step_min - 1;
          else
            current_step(channel) = step_max + 1;
          end

          % Set reset flag for correct PENDULUM mode handling
          reset(channel) = 1;
        end
      end % End while true
    end % End if direction ~= RANDOM
    % END Copy this code for checking a single step
end
