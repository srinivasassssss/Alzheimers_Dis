% Training Part	 - Alzheimer NonDemented
clear all
clc
close all
for i=1:10
    disp(['Processing frame no.',num2str(i)]);

 %% give path name, locating to the images
    img=imread(['D:\Softwares\ALZHEIMERS DISEASE CLASSIFICATION\ALZHEIMERSDISEASE\IMAGE DATABASE\DATASET\NonDemented\nonDem_ (',num2str(i),').jpg']);
     
    img = imresize(img,[256,256]);
    img = imadjust(img,stretchlim(img));
    imshow(img);title('Alzheimer NonDemented');
    [feat_disease seg_img] =  EvaluateFeatures_Grayscale(img);
    
    Alzheimer_NonDemented(i,:) = feat_disease;
     close all 
   
end
clear feat_disease
clear img
clear seg_img
clear i
save Alzheimer_NonDemented;


% % Training Part