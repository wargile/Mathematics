## Copyright (C) 2011 tbak
## 
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## sine_test

## Author: tbak <tbak@EG11233>
## Created: 2011-08-30

function [ ret ] = sine_test ()
	a = sin(0:0.25:pi*2);
	plot(a, 'bo-');
	
	len = length(a);
	old_val = 0;
	
	for counter = 2:len
		fprintf("Sin: %f, Diff: %d\n", a(counter), ...
			a(counter - 1) < a(counter));
	end
	
end
