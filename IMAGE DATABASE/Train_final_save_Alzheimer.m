clc
close all
clear all

    
load('Alzheimer_MildDemented.mat');
load('Alzheimer_ModerateDemented.mat');
load('Alzheimer_NonDemented.mat');
load('Alzheimer_VeryMildDemented.mat');

 
X = [Alzheimer_MildDemented(1:10,:); Alzheimer_ModerateDemented(1:10,:);Alzheimer_NonDemented(1:10,:); Alzheimer_VeryMildDemented(1:10,:);];
y = [ones(10,1); 2*ones(10,1);3*ones(10,1); 4*ones(10,1)];


% No of diseases
keySet = [1 2 3 4];

% Disease names
valueSet = {'Alzheimer_MildDemented', 'Alzheimer_ModerateDemented', 'Alzheimer_NonDemented','Alzheimer_VeryMildDemented'};

M = containers.Map(keySet,valueSet);
DBName='DATASET';


% clearing the temporary filesd & contents

clear keySet
clear Alzheimer_MildDemented.mat
clear Alzheimer_ModerateDemented.mat
clear Alzheimer_NonDemented.mat
clear Alzheimer_VeryMildDemented.mat

clear feat_disease
clear img
clear seg_img
clear i
clear valueSet

% Saving the Final training dataset file
save Alzheimer_Training_Data;

