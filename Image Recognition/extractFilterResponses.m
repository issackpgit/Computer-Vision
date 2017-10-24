function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs: 
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W x H x N*3 matrix of filter responses


% TODO Implement your code here
ima=[];
doubleimage = double(img);
[L,a,b] = RGB2Lab(doubleimage(:,:,1), doubleimage(:,:,2), doubleimage(:,:,3));
 sizeimg = size(doubleimage,1)*size(doubleimage,2);

filterResponses = zeros(sizeimg, length(filterBank)*3);

for i = 1 : length(filterBank)
%   disp(filterBank{i});
    Lfilter = imfilter(L, filterBank{i});
    afilter = imfilter(a, filterBank{i});
    bfilter = imfilter(b, filterBank{i});
    filterResponses(:, i*3-2) = reshape(Lfilter, [], 1);
    filterResponses(:, i*3-1) = reshape(afilter, [],1);
    filterResponses(:, i*3) = reshape(bfilter,[],1);
    
    im = cat(3,(imfilter(L, filterBank{i})),(imfilter(a, filterBank{i})),(imfilter(b, filterBank{i})));
    ima=cat(4,ima,im);
end

%   montage(ima,[4 5]);

end
