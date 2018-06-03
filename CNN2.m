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
numTrainFiles = min(floor(min(labelCount.Count)*3/4)) % nombre d'images d'entrainement par catégorie
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%% Augmente le nombre d'images avec des transformations
% imdsTrain = augmentedImageSource([s(1) s(2) 3],imdsTrain)

%% Architecture du réseau de neuronnes
layers = [
    imageInputLayer([s(1) s(2) 3])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    fullyConnectedLayer(5)
    softmaxLayer
    classificationLayer];

%% Options d'entrainement
% options = trainingOptions('sgdm', ...
%     'MaxEpochs',4, ...
%     'ValidationData',imdsValidation, ...
%     'ValidationFrequency',30, ...
%     'Verbose',false, ...
%     'Plots','training-progress');

options = trainingOptions('sgdm',...
      'LearnRateSchedule','piecewise',...
      'InitialLearnRate',0.01,...
      'LearnRateDropFactor',0.9,... % drop * learnRate
      'LearnRateDropPeriod',1,...  % nb d'époques à partir dequels le learnrate est mult par le drop factor
      'MiniBatchSize',64,... % 128 par défault
      'MaxEpochs',15);
  
      %'MiniBatchSize',200,...

%% Entrainement!!
net = trainNetwork(imdsTrain,layers,options);

%% Mesure la précision
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)

%% Sauvegarde
netInsect2 = net;
save netInsect2
% 
% %% Generation d'une fonction
% genFunction(net, 'insectClassificationNet','MatrixOnly','yes');
