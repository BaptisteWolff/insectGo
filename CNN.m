close all; clear all; clc;
%% Charge la BDD
% currentFolder = pwd;
% digitDatasetPath = [currentFolder '\BDD'];
digitDatasetPath = 'BDD';
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
% inclu les sub folders, les label dépendent du nom des dossiers de la BDD

%% Resize toutes les images en 220 * 220
% imds.ReadSize = numpartitions(imds);
% imds.ReadFcn = @(loc)imresize(imread(loc),[220,220]);

%% Affiche quelques images
figure;
perm = randperm(numpartitions(imds),20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
end

%% Compte le nombre d'images par catégorie
labelCount = countEachLabel(imds)
labelCountSize = size(labelCount, 1);

%% Taille des images
img = readimage(imds,1);
s = size(img)

%% Séparation des images d'entrainement/de test + mélange de toutes les images
numTrainFiles = min(min(750, numpartitions(imds)/4), min(labelCount.Count)/2) % nombre d'images d'entrainement par catégorie
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%% Architecture du réseau de neuronnes
layers = [
    imageInputLayer([s(1) s(2) 3]) % size1 size2 nCouleurs
    %%%
    % conv - 64
    convolution2dLayer(3,8,'Padding',1)
    reluLayer
    
    % conv - 64
    convolution2dLayer(3,8,'Padding',1)
    reluLayer
    
    % maxpool
    maxPooling2dLayer(2,'Stride',2)
    
    %%%
    % conv - 128
    convolution2dLayer(3,16,'Padding',1)
    reluLayer
    
    % conv - 128
    convolution2dLayer(3,16,'Padding',1)
    reluLayer
    
    % maxpool
    maxPooling2dLayer(2,'Stride',2)
    
    %%%
    % conv - 256
    convolution2dLayer(3,32,'Padding',1)
    reluLayer
    
    % conv - 256
    convolution2dLayer(3,32,'Padding',1)
    reluLayer
    
    % maxpool
    maxPooling2dLayer(2,'Stride',2)
    
    %%%
    % conv - 512
    convolution2dLayer(3,64,'Padding',1)
    reluLayer
    
    % conv - 512
    convolution2dLayer(3,64,'Padding',1)
    reluLayer
    
    % maxpool
    maxPooling2dLayer(2,'Stride',2)
    
    %%%
    fullyConnectedLayer(labelCountSize*4)
    fullyConnectedLayer(labelCountSize*4)
    fullyConnectedLayer(labelCountSize)
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
      'LearnRateDropFactor',0.2,... 
      'LearnRateDropPeriod',5,... 
      'MaxEpochs',4);

%% Entrainement!!
net = trainNetwork(imdsTrain,layers,options);

%% Mesure la précision
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)

%% Sauvegarde
netInsect1 = net;
save netInsect1