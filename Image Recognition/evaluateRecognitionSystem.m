     function [conf] = evaluateRecognitionSystem(numCores)
% Evaluates the recognition system for all test-images and returns the confusion matrix

 if nargin < 1
     %default to 1 core
    numCores = 1;
 end

 try
    fprintf('Closing any pools...\n');
    parpool close; 
catch ME
    disp(ME.message);
 end

fprintf('Starting a pool of workers with %d cores\n', numCores);
parpool('local',numCores);


	load('vision.mat');
	load('../data/traintest.mat');

	% TODO Implement your code here
    
    conf = zeros(length(mapping));  
    N = length(test_imagenames);
    
    
mapping = mapping;
test_imagenames = test_imagenames;
test_labels = test_labels;


if(numCores>1)
    parfor i = 1 : N
        filename = ['../data/' test_imagenames{i}];
        disp(filename);
        guessedvalue = find(strcmp(guessImage(filename), mapping));
        truth = test_labels(i);
        temp = zeros(length(mapping));
        temp(truth, guessedvalue) = 1;
        conf = conf + temp;
    end
else
    for i = 1 : N
        filename = ['../data/' test_imagenames{i}];
        disp(filename);
        guessedvalue = find(strcmp(guessImage(filename), mapping));
        truth = test_labels(i);
        temp = zeros(length(mapping));
        temp(truth, guessedvalue) = 1;
        conf = conf + temp;
    end
end

 
    accuracy= (100 * (trace(conf) / sum(conf(:))));
    disp(accuracy);
    
    save('conf.mat','conf','accuracy');
    
    if numCores > 1
    %close the pool
    fprintf('Closing the pool\n');
    delete(gcp('nocreate'));
    end
 end