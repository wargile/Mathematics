% Some matrix stuff....

A = [2,3,-3; 1,4,2; 5,1,4] %#ok<*NOPTS>
% Find the determinant
det_A = det(A)
% Find the adjugate
adj_A1 = pinv(A)*det_A

% Create a Hilbert matrix
% http://en.wikipedia.org/wiki/Hilbert_matrix)
% http://mathworld.wolfram.com/HilbertMatrix.html
hilbsizeRows = 8;
hilbsizeCols = 12;
M = ones(hilbsizeRows, hilbsizeCols);

for i = 1:hilbsizeRows
    for j = 1:hilbsizeCols
        M(i, j) = 1 / (i + j - 1);
    end
end

figure();
plot(M);
title('Hilbert Matrix');

figure();
image(M * 255);
title('Hilbert Matrix Coloured');
%M

        
