function resvalue = getvarresval(voltin, voltout, res1)
%GETVARRESVAL Gets the variable resistor value needed to obtain the
%   necessary gain in an op-amp.
%
%   Syntax: getvarresval(voltin, voltout, fixedresistor)
%
%   GETVARRESVAL gets the variable resistor value needed to obtain
%   the necessary gain in an op-amp.

  if nargin ~= 3
    error('Usage: getvarresval(voltin, voltout, fixedresistor)');
  end

  gain = voltout / voltin;

  resvalue = round(gain * res1);

  fprintf(['To obtain a gain of %.2f you need a variable ', ...
    'resistor set to %d ohms\n'], gain, resvalue);
  fprintf(['(Accurate ohm value is %.2f ohms. ', ...
    'Error rate is %.6f%%.)\n'], gain * res1, ...
  (abs(voltout - (voltin * (resvalue / res1))) / voltout) * 100);
end
