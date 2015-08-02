function res = getpres(varargin)
%GETPRES Gets the total resistance for a variable number of resistors
%   in a parallell connection.
%
%   Syntax: getpres(res1, res2, .. resN)
%
%   GETPRES gets the total resistance for a variable number of resistors
%   in a parallell connection.
%
%   See also GETSRES

    res = 0;

    if nargin == 0
        error('Usage: getpres(res1, res2, .. res<n>)');
    end

    for n = 1:length(varargin)
        res = res + (1 / varargin{n});
    end

    res = 1.0 / res;

	if res > 999999
        fprintf(['Total resistance for %d parallell resistors ', ...
            'is %.2f Mohms\n'], length(varargin), res / 1000000);
    elseif res > 999
        fprintf(['Total resistance for %d parallell resistors ', ...
            'is %.2f Kohms\n'], length(varargin), res / 1000);
    else
        fprintf(['Total resistance for %d parallell resistors ', ...
            'is %ld ohms.\n'], length(varargin), res);
    end
