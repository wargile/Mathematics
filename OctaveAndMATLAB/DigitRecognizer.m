function [data] = DigitRecognizer()

    %printf('Reading CSV file...');
    %X = csvread('C:/coding/Kaggle/Titanic/R/train.csv');
    %printf('\nSave data to MAT file...');
    %save('C:/coding/Kaggle/Titanic/R/train.mat', 'X');
    
    % Open training file
    filename = 'C:/coding/Kaggle/Titanic/R/train.csv';
    fh_train = fopen(filename, 'rt');
    
    A = importdata(filename, ',', 1);
    disp(A.colheaders{1, 1});
    disp(A.data(:, 1));
    
    % Get header line
    header = fgetl(fh_train);
    fields = strsplit(header, ',');
    numcols = length(fields);
    numrows = 891;
    data = cell(numrows, numcols);
    rowcounter = 0;
    
    % Get the rest
    while ~feof(fh_train)
        rowcounter = rowcounter + 1;
        data = fgetl(fh_train);
        data = strrep(data, ', ', '; ');
        data = strrep(data, '"', '#');
        data = strrep(data, ',,', ',#,');
        fields = strsplit(data, ',');
        
        for counter = 1:numcols
            fields(counter) = strrep(fields(counter), '#', '');
            fields(counter) = strrep(fields(counter), '; ', ', ');
            % Add to cell-array
            data(rowcounter, counter) = fields(counter);
        end
    end

    %line = textscan(fh_train, '%d,%d,%q,%s,%f,%d,%d,%d,%d,%f,%s,%s', ...
    %'Delimiter', ',', 'MultipleDelimsAsOne', 0);
 
    % Close training file
    fclose(fh_train);

    %printf('Digit value: %s\n', C_data(1));
    
    % Turn very long cellarray vector into data for each digit
    %C_data = reshape(C_data{:}, 28*28+1, numel(C_data{:})/(28*28+1));
    
    % Get digit value
    %digit_value = C_data(1,:);
    %printf('Digit value: %d\n', digit_value);
    
    % Get all 42000 digit images into a uint8 28x28x42000 array
    %digit_image = uint8(permute(reshape(C_data(2:end,:), [28 28 size(C_data,2)]), [2 1 3]));
    
    % Display 4th image
    %imagesc(squeeze(digit_image(:,:,4)), [0 255]); colormap(gray)
end
