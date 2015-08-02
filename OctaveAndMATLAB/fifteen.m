function num_out = fifteen(number)
%FIFTEEN Creates a 15Puzzle number array.
%
%   FIFTEEN creates a random array. If possible, a matrix is created.
%   Usage: [ret_value = ] fifteen(<number>);
%   <number> must be a positive integer value.

	x = 1;
    
	if nargin == 0
    disp('No input value given, using default value of 16.');
	  maxnum = 16;
	else
    % try
      if isnumeric(number) == 0 || number < 1
        error('Input argument must be a number larger than zero.');
      else
        maxnum = number;
      end
    % catch % exception
      % error('Invalid input argument. Usage: fifteen(<number>)');
      % error(strcat('Invalid input argument: ', exception.message));
      % rethrow(exception);
    % end
	end

	if mod(sqrt(maxnum), 1) == 0
	  num_out = zeros(sqrt(maxnum));
	else
	  num_out = zeros(1, maxnum);
	end

	while x <= maxnum
	  num = floor(rand(1) * maxnum) + 1;
    
	  for n = 1:x
		if num == num_out(n)
		  break;
		end
      
		if n >= x
		  num_out(x) = num;
		  x = x + 1;
		end
	end
  end

    

