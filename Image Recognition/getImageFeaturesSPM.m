   function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    % TODO Implement your code here
    
%     layerNum=3;

    L = layerNum-1;
    h = size(wordMap,1);
    w = size(wordMap,2);
    weight=0.5;
    hist = [];
   

 for z = L:-1:1
    cellh = floor(size(wordMap,1)/(2^z));
    cellw = floor(size(wordMap,2)/(2^z));
   
    val1 = cellh.*ones(1,2^z);
    diff = size(wordMap,1)-sum(val1);
    val1(1) = val1(1)+diff;
    
    val2 = cellw.*ones(1,2^z);
    diff2 =  size(wordMap,2)-sum(val2);
    val2(1) = val2(1)+diff2;
    
    histcell = mat2cell(wordMap,val1,val2);
    num = 2^z*2^z;
    
    histlayer = cell(1,num);
    
    for i = 1:num
        submatrix = histcell{i};
        subh = getImageFeatures(submatrix, dictionarySize);
        subh = subh';
        histlayer{i} = subh;
    end
    

    H = cell2mat(histlayer).*(weight);
    temp = weight;
    weight = weight * 0.5;
    hist = [hist H];
   
 end

% When the layer is 0
histlayer0 = getImageFeatures(wordMap, dictionarySize);
histlayer0 = histlayer0.*(temp);
H0 = histlayer0';

hist = [hist H0];

h = hist ./ sum(hist(:));

 end