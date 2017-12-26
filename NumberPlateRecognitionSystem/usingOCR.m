function [ output_args ] = usingOCR( input_args )
%USINGOCR Summary of this function goes here
%   Detailed explanation goes here


% Perform OCR
results = ocr(input_args);
words = [];
% Display one of the recognized words
for i = 1 : size(results.Words,1)
    words = [words results.Words{i}];
end


file = fopen('number_Plate_using_ocr.txt', 'wt');
    fprintf(file,'%s\n',words);
    fclose(file);                     
    winopen('number_Plate_using_ocr.txt')

end

