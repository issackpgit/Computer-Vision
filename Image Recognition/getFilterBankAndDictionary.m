 function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.
    alpha =20;
     filterBank  = createFilterBank();
%    interval =5;
%     load('../data/traintest.mat'); 
%     train_imagenames = train_imagenames(1:interval:end); %testing to be deleted
%     imPaths = strcat(['../data/'],train_imagenames);
    
     outputResponses = zeros(length(imPaths), length(filterBank)* 3);
%     outputResponses = zeros(1, length(filterBank)* 3);
    
     for i=1 : length(imPaths)
        
        Image = imread(imPaths{i});
        
           if size(Image, 3) == 1
           Image = repmat(Image, 1, 1, 3);
           end
    
    imgResponses = extractFilterResponses(Image, filterBank);
    indices = randperm(size(imgResponses, 1), alpha);
     outputResponses((i-1)*alpha+1:i*alpha,:) = imgResponses(indices, :);
%     outputResponses(1:alpha,:) = imgResponses(indices, :);
    
     end

    
K = 100;
[~, dictionary] = kmeans(outputResponses, K, 'EmptyAction', 'drop');

dictionary = dictionary';

 end
