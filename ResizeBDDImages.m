%% Ce script resize les images de la bdd en 227 * 227

digitDatasetPath = 'BDD';
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
% inclu les sub folders, les label dépendent du nom des dossiers de la BDD

%% Resize
imds.ReadSize = numpartitions(imds);
imds.ReadFcn = @(loc)imresize(imread(loc),[227,227]);

%% check random
figure(1);
img = readimage(imds,5); imshow(img); size(img)
figure(2);
img = readimage(imds,222); imshow(img); size(img)