function [primes_array] = getprimes(max_number)
%GETPRIMES get primes.
%	GETPRIMES gets prime numbers up to and including the given number.

	primes_counter = 0;
	
	for counter = 2:max_number
		if mod(sqrt(counter), 1) > 0
			primes_counter = primes_counter + 1;
		end
	end
	
	primes_array = zeros(1, primes_counter);
	primes_counter = 1;
	
	for counter = 2:max_number
		if mod(sqrt(counter), 1) > 0
			primes_array(primes_counter) = counter;
			primes_counter = primes_counter + 1;
		end
	end	
end
