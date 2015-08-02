function [step_values, step_status, step_info, direction] = ...
  sequencer(varargin)
%SEQUENCER creates a sequencer pattern from input data.
%  Parameters:
%    direction (1=FWD,2=REV,3=PND,4=RND), step_status (1x8 array),
%    max_steps, step_min, step_max, next_step (1x8 array)
%
%  Returns:
%    [step_values, step_status, step_info, direction]
%
%  TODO: Manual GOTO code
  
  %% Set constant values and assign defaults to variables
  FORWARD = 1;
  REVERSE = 2;
  PENDULUM = 3;
  RANDOM = 4;
  RUN = 1;
  SKIP = 2;
  RESET = 4;
  STOP = 8;
  DIRECTION_FORWARD = 1;
  DIRECTION_REVERSE = -1;
  STEPS_STANDARD = 8;
  FIG_NAME = 'Sequencer';

  step_min = 1;
  step_max = 8;
  max_steps = 8;
  direction = FORWARD;
  step_status = [SKIP, RUN, RUN, SKIP, RUN, RESET, RUN, RUN];
  next_step = [2, 3, 4, 5, 6, 7, 8, 1];
  directions = [FORWARD, REVERSE, PENDULUM, RANDOM];
  directions_display = {'FORWARD', 'REVERSE', 'PENDULUM', 'RANDOM'};
  x_ticklabels = cell(1, max_steps);
  step_values = zeros(1, max_steps);
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
  
  step_info = cell(1, max_steps);

  fprintf('\nDirection: %s\n\n', directions_display{direction});
  
  if direction == FORWARD || direction == PENDULUM
    step_change = DIRECTION_FORWARD;
    current_step = step_min - 1;
  else
    step_change = DIRECTION_REVERSE;
    current_step = step_max + 1;
  end
  
  is_stop_at_step = 0;
  reset = 0;
  
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
  if ~ismember(step_status, RUN)
    error('No step_status found with RUN status!');
  end
    
  %% For loop with next step check
  for i = 1:max_steps
    breakout_counter = 0;

    % START Copy this code for checking a single step
    if direction == RANDOM
      while true
        % current_step = randi(step_max); % NOTE: MATLAB only
        current_step = floor(rand(1) * step_max) + 1;

        if step_status(current_step) == RUN
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
        if direction == FORWARD && current_step > 0 && ...
            (step_status(current_step) ~= SKIP && ...
            step_status(current_step) ~= STOP)
          %if next_step(current_step) ~= current_step
            current_step = next_step(current_step);
          %end
        else
          if is_stop_at_step == 0
            current_step = current_step + step_change;
          end
        end

        if current_step > step_max
          if direction == PENDULUM && reset == 0
            current_step = step_max;
            step_change = DIRECTION_REVERSE;
          else
            current_step = step_min;
          end
        end

        if current_step < step_min
          if direction == PENDULUM && reset == 0
            current_step = step_min;
            step_change = DIRECTION_FORWARD;
          else
            current_step = step_max;
          end
        end

        if step_status(current_step) == STOP || ...
            step_status(current_step) == RUN
          if step_status(current_step) == STOP
            is_stop_at_step = 1;
          end

          break;
        end

        if step_status(current_step) == RESET
          if direction == FORWARD
            current_step = step_min - 1;
          else
            current_step = step_max + 1;
          end

          % Set reset flag for correct PENDULUM mode handling
          reset = 1;
        end
      end % End while true
    end % End if direction ~= RANDOM
    % END Copy this code for checking a single step

    %% Display info and assign to return vars
    if step_change == 1
      dir_sign = '>>';
    else
      dir_sign = '<<';
    end

    if direction == RANDOM
      dir_sign = '<>';
    end

    if current_step >= step_min && current_step <= step_max && ...
        (step_status(current_step) == RUN || ...
        step_status(current_step) == STOP)
      step_values(i) = current_step;
      if max_steps > 24
        x_ticklabels{i} = sprintf('%d', current_step);
      else
        x_ticklabels{i} = sprintf('%d%s', current_step, dir_sign);
      end
      step_info{i} = sprintf('%d:[%d] %s', i, current_step, dir_sign);
      fprintf('%2d:[%d] %s ', i, current_step, dir_sign);
    end

    if mod(i, 8) == 0
      fprintf('\n\n');
    end
  end % End for i = 1:max_steps
  
  if mod(i, 8) ~= 0
    fprintf('\n\n');
  end
  
  %% Plot the pattern
  
  % Create a new named figure. Code in createfigure.m
  createfigure(FIG_NAME, true);

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
