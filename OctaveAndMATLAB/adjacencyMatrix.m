% Create an adjacency matrix
A = [0,0,1,0,0,1,0,0; ...
     0,0,1,0,0,0,0,0; ...
     1,1,0,1,0,0,0,0; ...
     0,0,1,0,1,1,1,0; ...
     0,0,0,1,0,0,0,1; ...
     1,0,0,1,0,0,0,0; ...
     0,0,0,1,0,0,0,1; ...
     0,0,0,0,1,0,1,0];

% Get the number of neigbours each node has
B = diag(A * A');
B
