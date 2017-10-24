function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

	load('dictionary.mat');
	load('../data/traintest.mat');

    layerNum = 3;
	% TODO create train_features
    N = length(train_imagenames);

    train_features = zeros((4^(layerNum)-1)/3 * size(dictionary, 2), N);

    for i = 1: N
        load(strrep(['../data/', train_imagenames{i}],'.jpg','.mat'))
        train_features(:,i) = getImageFeaturesSPM(layerNum,wordMap,size(dictionary,2));
    end
    
	save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');

end
