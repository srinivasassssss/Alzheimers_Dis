% Training Part	 - Alzheimer ModerateDemented
clear all
clc
close all
for i=1:64
    disp(['Processing frame no.',num2str(i)]);

 %% give path name, locating to the images
    img=imread(['D:\ALZHEIMERS DISEASE CLASSIFICATION\ALZHEMIERSDISEASE\IMAGE DATABASE\DATASET\ModerateDemented\moderateDem_  (',num2str(i),').jpg']);     
    img = imresize(img,[256,256]);
    img = imadjust(img,stretchlim(img));
    imshow(img);title('Alzheimer ModerateDem');
    [feat_disease seg_img] =  EvaluateFeatures_Grayscale(img);
    
    Alzheimer_ModerateDemented(i,:) = feat_disease;
     close all 
   
end
clear feat_disease
clear img
clear seg_img
clear i
save Alzheimer_ModerateDemented;


% % Training Part