function ret = median_test(data)
    if nargin == 0
		error('Invalid call to median_test.');
    end
    
    temp = size(data);
    array_size = temp(1);
    element_length = temp(2);
	ret = zeros(1, array_size);
    p = 0;
    
    if array_size == 1
        my_data = data;
        
        if mod(length(my_data), 2) > 0
            ret = data((length(my_data) + 1) / 2);
        else
            middle = length(my_data) / 2;
            ret = (my_data(middle) + my_data(middle + 1)) / 2;
        end
    else
        for i = 1:array_size:((element_length * array_size) - ...
                (array_size - 1))
            p = p + 1;
            my_data = sort(data(i:i + (array_size - 1)));

            if mod(length(my_data), 2) > 0
                ret(p) = my_data((length(my_data) + 1) / 2);
            else
                middle = length(my_data) / 2;
                ret(p) = (my_data(middle) + my_data(middle + 1)) / 2;
            end
        end
    end
 end
