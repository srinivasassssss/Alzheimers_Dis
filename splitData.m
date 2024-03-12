function [XTrain XTest yTrain yTest] = splitData(X1, y1,trp,tsp)

% Splits the data into training and testing
% trp & tsp are training and tesing percentages
% trp=cast(trp1,'int8');
% Useful Variables
totalEgs = size(X1,1);
numTrain = int8((trp/100)*totalEgs); % 80% data reserved for training
numTest = int8((tsp/100)*totalEgs); % 20% reserved for testing
numLabels = unique(y1); % how many unique labels present
TrainPerLable = numTrain/length(numLabels); % how many egs per lable in training
TestPerLable = numTest/length(numLabels);  % how many egs per lable in test

for i=1:length(numLabels)
    temp = (y1==numLabels(i,1)); % find out where each label is present
    idx = find(temp==1); % get the index of that row where the lable is present
    Xtemp = X1(idx(:,1),:); % get values of X stored at that particular index
    
%     idxTemp = (randperm(size(Xtemp,1)))'; % randomly choose rows to put into train
    idxTemp=(1:size(Xtemp,1))';
    
    XTrainTemp = Xtemp(idxTemp(1:TrainPerLable,1),:);
    yTrainTemp = (ones(TrainPerLable,1))*i; 
    XTestTemp = Xtemp(idxTemp(TrainPerLable+1:end),:); % select remaining rows for testing
    yTestTemp = (ones(TestPerLable,1))*i;
    
    if i==1 % set up first input to train and test
        XTrain = XTrainTemp;
        yTrain = yTrainTemp;
        XTest = XTestTemp;
        yTest = yTestTemp;
    else % keep adding new egs to the training and testing sets
        XTrain = [XTrain; XTrainTemp];
        yTrain = [yTrain; yTrainTemp];
        XTest = [XTest; XTestTemp];
        yTest = [yTest; yTestTemp];
    end
end