function algebra()
%ALGEBRA Just testing some simplifications...

  x = 2;
  
  a = (x - 5)^2;
  b = x^2 - (10 * x) + 25;
  a, b %#ok<*NOPRT>

  a = (x + 4)^2;
  b = x^2 + (8 * x) + 16;
  a, b
  
  a = (x^2 - 14)^2;
  b = x^4 - (28 * x^2) + 196;
  a, b

  a = (x + 8)^4;
  b = (x^2 + (16 * x) + 64) * (x^2 + (16 * x) + 64);
  a, b

  a = (x + 8)^3;
  b = (x + 8) * (x^2 + (16 * x) + 64);
  a, b

  a = (x + 8)^5;
  b = (x + 8) * (x^2 + (16 * x) + 64) * (x^2 + (16 * x) + 64);
  a, b
  
  a = x^2 - 25;
  b = (x + 5) * (x - 5);
  c = x^2 - (5 * x) + (5 * x) - 25;
  a, b, c

  a = x^2 - (10 * x) - 11
  b = (x - 11) * (x + 1)
  a, b

  % a = x^2 + 25; % Hmmm... can't factor that one...
end
