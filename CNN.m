close all; clear all; clc;
%% Charge la BDD
% currentFolder = pwd;
% digitDatasetPath = [currentFolder '\BDD'];
digitDatasetPath = 'BDD';
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
% inclu les sub folders, les label dépendent du nom des dossiers de la BDD

%% Resize toutes les images en resize * resize
% resize = 256
% imds.ReadSize = numpartitions(imds);
% imds.ReadFcn = @(loc)imresize(imread(loc),[220,220]);

%% Affiche quelques images
% figure;
% perm = randperm(numpartitions(imds),20);
% for i = 1:20
%     subplot(4,5,i);
%     imshow(imds.Files{perm(i)});
% end

%% Compte le nombre d'images par catégorie
labelCount = countEachLabel(imds)
labelCountSize = size(labelCount, 1);

%% Taille des images
img = readimage(imds,1);
s = size(img)

%% Séparation des images d'entrainement/de test + mélange de toutes les images
numTrainFiles = floor(min(labelCount.Count)*3/4) % nombre d'images d'entrainement par catégorie
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%% Augmente le nombre d'images avec des transformations
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true,...
    'RandYReflection',true,...
    'RandRotation',[0,360], ...
    'RandXScale',[1 2],...
    'RandYScale',[1 2])
%     'RandXTranslation',[-30 30], ...
%     'RandYTranslation',[-30 30])
    
imdsTrain = augmentedImageDatastore([s(1) s(2) 3],imdsTrain, 'DataAugmentation',imageAugmenter);

%% Architecture du réseau de neuronnes
filterNumber = 64;
layers = [
    imageInputLayer([s(1) s(2) 3]) % size1 size2 nCouleurs
    %%%
    % conv - 64
    convolution2dLayer(3,filterNumber,'Padding',1)
    batchNormalizationLayer
    reluLayer
    
    % maxpool
    maxPooling2dLayer(2,'Stride',2)
    
    %%%
    % conv - 128
    convolution2dLayer(3,filterNumber*2,'Padding',1)
    batchNormalizationLayer
    reluLayer
    
    % maxpool
    maxPooling2dLayer(2,'Stride',2)
    
    %%%
    % conv - 256
    convolution2dLayer(3,filterNumber*4,'Padding',1)
    batchNormalizationLayer
    reluLayer
    
    % maxpool
    maxPooling2dLayer(2,'Stride',2)
    
    %%%
    % conv - 512
    convolution2dLayer(3,filterNumber*8,'Padding',1)
    batchNormalizationLayer
    reluLayer
    
    % maxpool
    maxPooling2dLayer(2,'Stride',2)
    
    %%%
%     fullyConnectedLayer(labelCountSize*20)
    fullyConnectedLayer(labelCountSize*100)
    fullyConnectedLayer(labelCountSize)
    softmaxLayer
    classificationLayer];

%% Options d'entrainement
% options = trainingOptions('sgdm', ...
%     'MaxEpochs',40, ...
%     'ValidationData',imdsValidation, ...
%     'ValidationFrequency',30, ...
%     'Verbose',false, ...
%     'LearnRateSchedule','piecewise',... %none or piecewise to update learning rate
%     'InitialLearnRate',0.01,...
%     'LearnRateDropFactor',0.9,... % drop * learnRate
%     'LearnRateDropPeriod',1,...  % nb d'époques à partir dequels le learnrate est mult par le drop factor
%     'MiniBatchSize',64,... % 128 par défault
%     'Plots','training-progress');

options = trainingOptions('sgdm',...
      'LearnRateSchedule','piecewise',...
      'InitialLearnRate',0.01,...
      'LearnRateDropFactor',0.9,... % drop * learnRate
      'LearnRateDropPeriod',1,...  % nb d'époques à partir dequels le learnrate est mult par le drop factor
      'MiniBatchSize',64,... % 128 par défault
      'MaxEpochs',15);
  
%       'MiniBatchSize',200,...

%% Entrainement!!
net = trainNetwork(imdsTrain,layers,options);

%% Mesure la précision
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)

%% Sauvegarde
netInsect1 = net;
save netInsect1
% 
% %% Generation d'une fonction
% genFunction(net, 'insectClassificationNet','MatrixOnly','yes');
