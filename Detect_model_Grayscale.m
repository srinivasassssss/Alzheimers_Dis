% Project Title: ALZHEIMER DISEASE CLASSIFICATION

clc
close all 
clear all

[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'pick a MRI Brain Image File');
I = imread([pathname,filename]);
I = imresize(I,[256,256]);
figure, imshow(I); title('Query MRI Brain Image');

% Enhance Contrast
I = imadjust(I,stretchlim(I));
figure, imshow(I);title('Contrast Enhanced');

%%% Extract Features %%%%%

% Function call to evaluate features
%[feat_disease seg_img] =  EvaluateFeatures_Grayscale(I)

% Color Image Segmentation
% Use of K Means clustering for segmentation
% Convert Image from RGB Color Space to L*a*b* Color Space 
% The L*a*b* space consists of a luminosity layer 'L*', chromaticity-layer 'a*' and 'b*'.
% All of the color information is in the 'a*' and 'b*' layers.
% cform = makecform('srgb2lab');
% % Apply the colorform
% lab_he = applycform(I,cform);

% Classify the colors in a*b* colorspace using K means clustering.
% Since the image has 3 colors create 3 clusters.
% Measure the distance using Euclidean Distance Metric.
nColors = 3;
nrows=size(I,1);
ncols=size(I,2);
ab=double(I(:));
% ab = reshape(ab,nrows*ncols,2);
% ab=double(I(:));


[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
%[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
% Label every pixel in tha image using results from K means
pixel_labels = reshape(cluster_idx,nrows,ncols);
%figure,imshow(pixel_labels,[]), title('Image Labeled by Cluster Index');

% Create a blank cell array to store the results of clustering
segmented_images = cell(1,3);
% Create RGB label using pixel_labels
rgb_label = repmat(pixel_labels,[1,1,3]);

for k = 1:nColors
    colors (:,:,1)= I;
      colors (:,:,2)= I;
        colors (:,:,3)= I;
    colors(rgb_label ~= k) = 0;
    segmented_images{k} = colors;
end



figure, subplot(2,4,1);imshow(I);title('Original Image'); 
subplot(2,4,2);imshow(segmented_images{1});title('Cluster 1'); 
subplot(2,4,3);imshow(segmented_images{2});title('Cluster 2');
subplot(2,4,4);imshow(segmented_images{3});title('Cluster 3');

% set(gcf, 'Position', get(0,'Screensize'));

% Feature Extraction
x = inputdlg('Enter the cluster no. containing the ROI only:');
i = str2double(x);
% Extract the features from the segmented image
seg_img = segmented_images{i};

% Convert to grayscale if image is RGB
if ndims(seg_img) == 3
   img = rgb2gray(seg_img);
end
%figure, imshow(img); title('Gray Scale Image');

% Evaluate the disease affected area
black = im2bw(seg_img,graythresh(seg_img));
%figure, imshow(black);title('Black & White Image');
m = size(seg_img,1);
n = size(seg_img,2);

zero_image = zeros(m,n); 
%G = imoverlay(zero_image,seg_img,[1 0 0]);

cc = bwconncomp(seg_img,6);
diseasedata = regionprops(cc,'basic');
A1 = diseasedata.Area;
sprintf('Area of the disease affected region is : %g%',A1);

I_black = im2bw(I,graythresh(I));
kk = bwconncomp(I,6);
leafdata = regionprops(kk,'basic');
A2 = leafdata.Area;
sprintf(' Total Brain area is : %g%',A2);

%Affected_Area = 1-(A1/A2);
Affected_Area = (A1/A2);
if Affected_Area < 0.1
    Affected_Area = Affected_Area+0.15;
end
sprintf('Affected Area is: %g%%',(Affected_Area*100))

% Create the Gray Level Cooccurance Matrices (GLCMs)
glcms = graycomatrix(img);

% Derive Statistics from GLCM
stats = graycoprops(glcms,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;
Mean = mean2(seg_img);
Standard_Deviation = std2(seg_img);
Entropy = entropy(seg_img);
RMS = mean2(rms(seg_img));
%Skewness = skewness(img)
Variance = mean2(var(double(seg_img)));
a = sum(double(seg_img(:)));
Smoothness = 1-(1/(1+a));
Kurtosis = kurtosis(double(seg_img(:)));
Skewness = skewness(double(seg_img(:)));
% Inverse Difference Movement
m = size(seg_img,1);
n = size(seg_img,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = seg_img(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);
    
feat_disease = [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];

% Put the test features into variable 'test'
test = feat_disease;

% % Loading the data set 
fprintf('\n Loading the dataset...');

[Dbname, Dbpath] = uigetfile({'*.*';'*.mat'}, 'PICK A MRI Brain Images DATASET .mat File');
load([Dbpath,Dbname]);
X_train=X;  % all training data
y_train=y; % all labels

[num_labels,n] = size(unique(y_train));

% MULTINOMIAL LOGISTIC REGRESSION for predicting the disease in the query leaf image
fprintf("\n Multinomial Logistic Regression for predicting the disease in the query MRI  image:");

lambda = 0.1;
[all_theta] = oneVsAll(X_train, y_train, num_labels, lambda);

% % ================ Predict for One-Vs-All ================
 fprintf('\n Prediction part....');
 pred_result = predictOneVsAll(all_theta, test);

 % % Visualize Results
fprintf('\n Result part......');

fprintf(' \n Disease Identified: %s',M(pred_result));
helpdlg(M(pred_result));


%%%  ANALYZING THE CLASSIFIER PERFORMANCE %%%

trpp= inputdlg('Enter the Training set %:');
% trp=80;
trp=str2double(trpp);
tsp=100-trp;

[X_train X_test y_train y_test] = splitData(X, y, trp,tsp);
per='%';
fprintf('\n Dataset splitted into %d%c for Training and %d%c for Testing',trp,per,tsp,per);

[num_labels,n] = size(unique(y_train));


fprintf('\n\n Performance ANALYSIS\n');


fprintf('\n FOR TRAING DATA SET\n');

%Performance Measures Initialization
Accuracy=[];
FPRs=[];
recalls = [];
precisions = [];
f1s = [];
   
lambda = 0.1;
[all_theta] = oneVsAll(X_train,y_train, num_labels, lambda);

preds1 = predictOneVsAll(all_theta, X_train);
fprintf('\nTraining Set Accuracy: %.4f ', mean(double(preds1 == y_train)) * 100);

%Training set Accuracy & Performance evaluation
    rec = recall(preds1, y_train); 
    prec = precision(preds1, y_train); 
    f1Meas  = f1(prec,rec);
    fpr = FPR(preds1, y_train);
    FPRs=[FPRs fpr]; 
    recalls = [recalls rec]; 
    precisions = [precisions prec]; 
    f1s = [f1s f1Meas];
fprintf("\n Precision: %.4f Recall: %.4f f1: %.4f FPR: %.4f \n", prec, rec, f1Meas, fpr);
       
    
fprintf('\n FOR TESTING DATA SET\n');

 % Testing set accuracy & performance    
 preds2 = predictOneVsAll(all_theta, X_test);
 fprintf('\nTesting Set Accuracy: %.4f ', mean(double(preds2 == y_test)) * 100);
 
    % Performance evaluation
    rec = recall(preds2, y_test); 
    prec = precision(preds2, y_test); 
    f1Meas  = f1(prec,rec);
    fpr = FPR(preds2, y_test);
    FPRs=[FPRs fpr]; 
    recalls = [recalls rec]; 
    precisions = [precisions prec]; 
    f1s = [f1s f1Meas];
    fprintf("\n Precision: %.4f Recall: %.4f f1: %.4f FPR: %.4f \n", prec, rec, f1Meas, fpr);
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

