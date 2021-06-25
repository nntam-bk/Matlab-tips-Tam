% function net=train_model_num(fp,fn,siz)
fp='D:\Personal\LVThS';
fn='Data CNN';
% fp='E:\temp\Ng Mai\License-plate-detection';
% fn='Traindata';
siz=[227, 227];
imagepath = fullfile(fp, fn );
imds = imageDatastore(imagepath,...
    'Includesubfolders',true,...
    'LabelSource', 'FolderNames');
imds.ReadFcn = @(loc)imresize(imread(loc),siz);
[imgs, label] = imds2array1(imds);

% Convolutional Neural Network

% imgs=[227 227];
height  = size(imgs,1);
width   = size(imgs,2); 
channel = size(imgs,3);
% sla=[12 12];
% sla1=[6 6];
num_filt1=6;
num_filt2=3;
num_filt3=3;
size_filt1=[3, 3];
size_filt2=[3, 3];
size_filt3=[3, 3];
fc=9;
lgraph = [
    imageInputLayer([height width channel],"Name","imageinput")
    convolution2dLayer(size_filt1,num_filt1,'Padding','same') 
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',1)
    convolution2dLayer(size_filt2,num_filt2,'Padding','same') 
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',1)
    convolution2dLayer(size_filt3,num_filt3,'Padding','same') 
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',1)
    fullyConnectedLayer(fc)
    softmaxLayer
    classificationLayer];

% fn='SaiGon sap xep';
% imagepath = fullfile(fp, fn ) ;
% imds = imageDatastore(imagepath,'Includesubfolders',true, 'LabelSource', 'FolderNames');
% 
% imds.ReadFcn = @(loc)imresize(imread(loc),imgs);
% 
% [trainDS,valDS] = splitEachLabel(imds,0.95,0.05,'randomized');

opts=trainingOptions('sgdm','InitialLearnRate',1e-4,...
    'MaxEpochs',20, ...
    'MiniBatchSize',10);

net=trainNetwork(imgs,label,lgraph,opts);
% end
% save('NetDetect.mat','net')