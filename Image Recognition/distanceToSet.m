function histInter = distanceToSet(wordHist, histograms)
% Compute distance between a histogram of visual words with all training image histograms.
% Inputs:
% 	wordHist: visual word histogram - K * (4^(L+1) − 1 / 3) × 1 vector
% 	histograms: matrix containing T features from T training images - K * (4^(L+1) − 1 / 3) × T matrix
% Output:
% 	histInter: histogram intersection similarity between wordHist and each training sample as a 1 × T vector

	% TODO Implement your code here
	
    wordHist = wordHist';
    T = size(histograms,2);
%     When k= 100 and alpha = 200
%    Accuracy at its best 54.375%
     histInter = sum(bsxfun(@min,histograms,repmat(wordHist,1,T)));
%    Accuracy reduced to 52.5
%    histInter =-pdist2(histograms', wordHist', 'spearman');
%    Accuracy reduced to 42.5
%    histInter = -pdist2(histograms', wordHist', 'correlation');
%    Accuracy got reduced to 32.5
%    histInter = -pdist2(histograms', wordHist', 'seuclidean');
%    Using Bhattacharyya coefficient accuracy reduced to 53.75 
%    histInter = sum(bsxfun(@times, sqrt(histograms), repmat(sqrt(wordHist), 1, size(histograms, 2))));

    
end