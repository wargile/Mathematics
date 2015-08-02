function writewav()
%WRITEWAV Creates a WAV-file.
%
% From: http://users.rowan.edu/~shreek/networks1/music.html

    clear;

    a = sin(2 * pi * 440 * (0:0.000125:0.5));
    b = sin(2 * pi * 493.88 * (0:0.000125:0.5));
    cs = sin(2 * pi * 554.37 * (0:0.000125:0.5));
    d = sin(2 * pi * 587.33 * (0:0.000125:0.5));
    e = sin(2 * pi * 659.26 * (0:0.000125:0.5));
    fs = sin(2 * pi * 739.99 * (0:0.000125:0.5));

    line1 = [a,a,e,e,fs,fs,e,e,];
    line2 = [d,d,cs,cs,b,b,a,a,];
    line3 = [e,e,d,d,cs,cs,b,b];

    song=[line1,line2,line3,line3,line1,line2];

    wavwrite(song, 'c:\temp\song.wav'); 
end
