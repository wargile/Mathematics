function res = getsres(varargin)
%GETSRES Gets the total resistance for a variable number of resistors in
%   a serial connection.
%
%   Syntax: getsres(res1, res2, .. resN)
%
%   GETSRES gets the total resistance for a variable number of resistors
%   in serial connection.
%
%   See also GETPRES

    if nargin == 0
        error('Usage: getsres(res1, res2, .. resN)');
    end

    res = 0;

    for n = 1:length(varargin)
        res = res + varargin{n};
    end

    if res > 999999
        fprintf(['Total resistance for %d serial resistors ', ...
            'is %.2f Mohms\n'], length(varargin), res / 1000000);
    elseif res > 999
        fprintf(['Total resistance for %d serial resistors ', ...
            'is %.2f Kohms\n'], length(varargin), res / 1000);
    else
        fprintf(['Total resistance for %d serial resistors ', ...
            'is %ld ohms.\n'], length(varargin), res);
    end
end
