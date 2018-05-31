

%% Charge le r�seau de neuronnes
load netInsect1
net = netInsect1;
%% Charge la BDD
% currentFolder = pwd;
% digitDatasetPath = [currentFolder '\BDD'];
digitDatasetPath = 'BDD';
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');
% inclu les sub folders, les label d�pendent du nom des dossiers de la BDD

%% test sur des images
nbImagesTest = 2;
labelCount = countEachLabel(imds)
[imdsTest,~] = splitEachLabel(imds,nbImagesTest,'randomize');
%% Affiche les images
% figure;
% perm = randperm(numpartitions(imds),20);
% for i = 1:20
%     subplot(4,5,i);
%     imshow(imds.Files{perm(i)});
% end
%% Test
c = classify(net,imdsTest)

%% Affiche le r�sultat

labels = imdsTest.Labels;
figure();
n = nbImagesTest*size(labelCount,1);
for i=1:n
    subplot(2,5,i);
    imshow(readimage(imdsTest,i));
    t = [cellstr(c(i)) cellstr(labels(i))];
    title(t)
end

