function trig()
%TRIG Just some trig code....
  
  % The unit circle
  % Find the cos and sin values of the 30/60/90 triangle sides.
  % Compare to the (sqrt(3))/2 and 1/2 unit circle constants
	
  format long;
  
  % Get the radian value for the 30 degree angle
  the_radian = 30 * (pi / 180);
  cos_value = cos(the_radian);
  sin_value = sin(the_radian);
  
  fprintf(['Find the cosine and sine values of the 30/60/90', ...
		   ' unit circle triangle.\n\n']);
  fprintf('cos: %.18f, sin: %.2f, sqrt(3)/2 = %.18f, 1/2 = %.2f\n', ...
		  cos_value, sin_value, (sqrt(3))/2, 1/2);
  
  format short;
end
