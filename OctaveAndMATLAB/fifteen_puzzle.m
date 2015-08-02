% Fifteen puzzle

boardsize = 16;
EMPTY = boardsize; 
data = fifteen(boardsize) %#ok<*NASGU>

[row, col] = find(data == EMPTY);
% Equivalent to:
[row, col] = ind2sub(size(data), find(data == EMPTY));
[row, col]
data(row,:)
data(:,col)

move = 6;
onrow = find(data(row,:) == move)
oncol = find(data(:,col) == move)

if (~isempty(onrow))
    disp 'On row!'
    data(row, col) = data(onrow, col);
    data(onrow, col) = EMPTY;
    data
end

if (~isempty(oncol))
    disp 'On col!'
end

% TODO: Put this in function to shift elements left or right
% Use for row/col, assign to vector, shift, and replace row/col with
% updated vector
a = data(:,row);
a
b = 13;
emptypos = find(a == EMPTY); 
pos = find(a == b);

if (emptypos > pos) % We should shift right
   a(pos + 1:emptypos) = a(pos:emptypos - 1);
   a(pos) = EMPTY;
else % We should shift left
   temp = a(emptypos + 1:pos);
   a(pos) = EMPTY;
   a(emptypos:pos - 1) = temp;
end

a
