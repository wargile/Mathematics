function [ret] = sqrt_numbers(max_number)
	p = 1;
    
    if (nargin == 0)
        max_number = 48;
    end
 	
    % Determine size of array
	for i = 2:max_number
		if mod(sqrt(i), 1) == 0
			p = p + 1;
		end
	end

	ret = zeros(1, p - 1);
	p = 1;

    for i = 2:max_number
        if mod(sqrt(i), 1) == 0
			ret(p) = i;
			p = p + 1;
			fprintf('%d, ', i);
        end
    end
    
    fprintf('\n');
end
    
