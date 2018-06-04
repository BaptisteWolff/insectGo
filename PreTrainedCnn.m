close all; clear all; clc;
%% Charge la BDD
% currentFolder = pwd;
% digitDatasetPath = [currentFolder '\BDD'];
digitDatasetPath = 'BDD';
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
% inclu les sub folders, les label d�pendent du nom des dossiers de la BDD

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

%% Compte le nombre d'images par cat�gorie
labelCount = countEachLabel(imds)
labelCountSize = size(labelCount, 1);

%% Taille des images
img = readimage(imds,1);
s = size(img)

%% S�paration des images d'entrainement/de test + m�lange de toutes les images
numTrainFiles = floor(min(labelCount.Count)*4/5) % nombre d'images d'entrainement par cat�gorie
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

%% Charger le r�seau pr�-entrain�
net = vgg16;
net.Layers;

%% On remplace les couches finales
layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(imds.Labels));
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

%% Options d'entrainement
options = trainingOptions('sgdm', ...
    'MiniBatchSize',30, ...
    'MaxEpochs',3, ...
    'InitialLearnRate',1e-4, ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',116, ...
    'ValidationPatience',Inf, ...
    'Verbose',false, ...
    'LearnRateDropFactor',0.5,... % drop * learnRate
    'LearnRateDropPeriod',1,...  % nb d'�poques � partir dequels le learnrate est mult par le drop factor
    'Plots','training-progress');

% options = trainingOptions('sgdm',...
%       'LearnRateSchedule','piecewise',...
%       'InitialLearnRate',1e-4,...
%       'LearnRateDropFactor',0.9,... % drop * learnRate
%       'LearnRateDropPeriod',1,...  % nb d'�poques � partir dequels le learnrate est mult par le drop factor
%       'MiniBatchSize',30,... % 128 par d�fault
%       'MaxEpochs',2);
  
%% Entrainement!!
net = trainNetwork(imdsTrain,layers,options);

%% Mesure la pr�cision
% YPred = classify(net,imdsValidation);
% YValidation = imdsValidation.Labels;

% accuracy = sum(YPred == YValidation)/numel(YValidation)

%% Sauvegarde
% netInsectVgg16 = net;
% save netInsectVgg16

%% Generation d'une fonction
% genFunction(net, 'insectClassificationNet','MatrixOnly','yes');
