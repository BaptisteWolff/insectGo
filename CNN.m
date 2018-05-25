close all; clear all; clc;
%% Charge la BDD
% currentFolder = pwd;
% digitDatasetPath = [currentFolder '\BDD'];
digitDatasetPath = 'BDD';
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
% inclu les sub folders, les label dépendent du nom des dossiers de la BDD

%% Resize toutes les images en 227 * 227
imds.ReadSize = numpartitions(imds);
imds.ReadFcn = @(loc)imresize(imread(loc),[227,227]);

%% Affiche quelques images
figure;
perm = randperm(numpartitions(imds),20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
end

%% Compte le nombre d'images par catégorie
labelCount = countEachLabel(imds)


