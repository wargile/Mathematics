function baud = getbaud(osc, baudrate, bits)
%Gets the SPRBG value for setting baud rate in serial communication setup.
%   Syntax: getbaud(<osc in Mhz 1-100>, <baud rate 300-115200>, <bits 8|16>)
%
%   GETBAUD gets the SPRBG value for setting baud rate in
%   serial communication setup.

    if nargin ~= 3
        error(['Syntax: getbaud(osc in Mhz (1-100), baud rate ', ...
            '(300-115200), bits (8|16))']);
    end
    if osc > 100 || baudrate > 115200 || baudrate < 300 || ...
            (bits ~= 8 && bits ~= 16)
        error(['Syntax: getbaud(osc in Mhz (1-100), baud rate ', ...
            '(300-115200), bits (8|16))']);
    end

    F_OSC = osc * 1000000.0;
    var = 64.0;

    if bits == 16
        var = 16.0;
    end

    baud = ((F_OSC / baudrate) / var) - 1.0;

    calculatedbaud = F_OSC / (var * (round(baud) + 1));
    errorrate = ((calculatedbaud - baudrate) / baudrate) * 100;

    fprintf(['\nSPRBG value for osc %d Mhz, baud rate %d, %d bits: ' ...
             'SPBRG = %d\n'], osc, baudrate, bits, round(baud));
    fprintf('Calculated baud rate for SPRBG = %d (%.2f) is %.2f\n', ...
             round(baud), baud, calculatedbaud);
    fprintf('Error rate is %.4f %%\n', errorrate);
end