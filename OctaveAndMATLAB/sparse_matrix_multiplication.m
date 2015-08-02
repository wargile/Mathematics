function [result] = sparse_matrix_multiplication()
% Trying some sparse matrix/vector multiplication...!
% http://en.wikipedia.org/wiki/Sparse_matrix
% http://www.johnmyleswhite.com/notebook/2011/10/31/using-sparse-matrices-in-r/
    
    % Atest = [2,-1, 0, 0; -1, 2, -1, 0; 0, -1, 2, -1; 0, 0, -1, 2];
    % Xtest = [2.0, 8.0, -1.0, 5.0];
    % disp(Atest);
    % disp(Xtest);
    % disp(Atest * Xtest');

    % Some examples of cell manipulation:
    % A_sparse = {[0, 2.0; 1, -1.0], [0, -1.0; 1, 2.0; 2, -1.0], ...
    %    [1, -1.0; 2, 2.0; 3, -1.0;], [2, -1.0; 3, 2.0]};
    % A_sparse{1}(1,1);
    % A_sparse{2}(3,2);
    % sum(A_sparse{2}(2) * 10);
    % length(A_sparse{2});
    % A_in(A_in ~= 0)
    % A{2}(2,1:2) = [5,5];

    % Try it out!
    cell_vals = randi(10); % Number of cells that have a value
    [AA, xx] = create_matrix_and_vector(6, 6, cell_vals, 10, 100);
    disp('AA and xx:');
    disp(AA);
    disp(xx);
    
    A_sparse2 = create_sparse_matrix(AA);
    disp('Creating sparse matrix:');
    disp(A_sparse2);
    
    result = sparse_matrix_mult(A_sparse2, xx);
    disp('Result of sparse matrix and vector multiplication:');
    disp(result);
    disp(AA * xx');
    
    % Example: Create a covariance matrix
    % Returns: [mean_vector, cov_matrix]
    create_covariance_matrix()
end

function [rowsum] = sparse_matrix_mult(A, x)
    % {sum({v * x[i] : (i,v) in row}) : row in A};
    rowsum = zeros(1, length(A));
    %disp('Displaying A:');
    %disp(size(A{1}));
   
    for i = 1:length(A)
        %disp(i);
        for j = 1:size(A{i},1)
            rowsum(i) = rowsum(i) + (A{i}(j,2) * x(A{i}(j,1)+1));
        end
    end
end

function [row_data] = create_sparse_matrix(A)
    %row_data = {};
    row_data = cell(1, size(A, 1)); % Better to preallocate cell array

    for i = 1:size(A, 1)
        counter = 1;
        for j = 1:length(A(i,:))
            if A(i,j) ~= 0
                row_data{i}(counter, 1) = j - 1;
                row_data{i}(counter, 2) = A(i, j);
                counter = counter + 1;
            end
        end
    end
end

function [A, x] = create_matrix_and_vector(rows, cols, value_cells, ...
    min_num, max_num)
    A = zeros(1, rows * cols);
    x = randi([min_num, max_num], 1, cols);

    numbers = randi([min_num, max_num], 1, value_cells + 1);
    cells = randi([1, numel(A)], 1, value_cells + 1);
    
    for counter = 1:numel(cells)
        A(cells(counter)) = numbers(counter);
    end
    
    A = reshape(A, rows, cols);
end

function [mean_vector, cov_matrix] = create_covariance_matrix()
    A = [1,2,3,4;5,6,7,8];
    n = 4;
    mean_vector = (1/n) * (A * ones(1,n)');
    mean_matrix = ones * mean_vector';
    cov_matrix = (1/n) * (A - mean_matrix')' * (A - mean_matrix');
end
