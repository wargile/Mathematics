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

## mandelbrot

## Author: tbak <tbak@EG11233>
## Created: 2011-08-10

function [ ret ] = mandelbrot ()
	maxIterations = 500;
	gridSize = 1000;
	xlim = [-0.748766713922161, -0.748766707771757];
	ylim = [ 0.123640844894862,  0.123640851045266];

	% Setup
	t = tic();
	x = linspace( xlim(1), xlim(2), gridSize );
	y = linspace( ylim(1), ylim(2), gridSize );
	[xGrid,yGrid] = meshgrid( x, y );
	z0 = xGrid + 1i*yGrid;
	count = zeros( size(z0) );

	% Calculate
	z = z0;
	for n = 0:maxIterations
		z = z.*z + z0;
		inside = abs( z )<=2;
		count = count + inside;
	end
	count = log( count+1 );

	% Show
	cpuTime = toc( t );
	set( gcf, 'Position', [200 200 600 600] );
	imagesc( x, y, count );
	axis image
	colormap( [jet();flipud( jet() );0 0 0] );
	title( sprintf( '%1.2fsecs (without GPU)', cpuTime ) );
endfunction
