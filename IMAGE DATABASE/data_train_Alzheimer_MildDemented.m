% Training Part	 - Alzheimer MildDemented
clear all
clc
close all
for i=1:896
    disp(['Processing frame no.',num2str(i)]);

 %% give path name, locating to the images
    img=imread(['D:\ALZHEIMERS DISEASE CLASSIFICATION\ALZHEMIERSDISEASE\IMAGE DATABASE\DATASET\MildDemented\mildDem_ (',num2str(i),').jpg']);
     
    img = imresize(img,[256,256]);
    img = imadjust(img,stretchlim(img));
    imshow(img);title('Alzheimer MildDemented');
    [feat_disease seg_img] =  EvaluateFeatures_Grayscale(img);
    
    Alzheimer_MildDemented(i,:) = feat_disease;
     close all 
   
end
clear feat_disease
clear img
clear seg_img
clear i
clear valueSet
save Alzheimer_MildDemented;


% % Training Part