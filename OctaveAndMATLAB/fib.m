function [a, b] = fib(maxnum)
%FIB Creates a sequence of fibonacci numbers.
%
%   Usage: fib(maxnum)

    if nargin == 0 || maxnum < 0
        error('Usage: fib(maxnum)');
    end
    if ischar(maxnum)
        error('Usage: fib(maxnum)');
    end

    p = 1;
    b = ones(maxnum);

    if maxnum == 0
        a = 0;
    elseif maxnum == 1
        a = [0 1];
    else
        a = 1:maxnum;
        a(1) = 0;
        a(2) = 1;
        for n = 3:maxnum
            a(n) = a(n - 1) + a(n - 2);
            prim = 1;
            for t = a(n) - 1:-1:2
                if (mod(a(n), t) == 0) && (a(n) > 1)
                    prim = 0;
                    break;
                end
            end
            if prim > 0
                b(p) = a(n);
                p = p + 1;
            end
        end
    end
end