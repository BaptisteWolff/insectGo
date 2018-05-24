function [ mask,imageOut ] = InsectSegmentation( imageIn )
%Réalise la segmentation d'un insecte
%   imageIn : image avec l'insecte à segmenter
%   mask : mask de l'insecte dimensionné en 2000 * 2000

imageOut = imresize(imageIn,[2000 2000]);
Igray = rgb2gray(imageOut);
s = strel('disk', 20);
Igray = imopen(Igray, s);
    
bw = edge(Igray, 'Sobel');

s = strel('disk', 6);
Ic = imdilate(bw, s);

If = imfill(Ic,'holes');
label = bwlabel(If);

stat = regionprops(label,'Area');

area = [stat.Area];
[val,idx] = max(area);


Ilogic = (label==idx);
    
s = strel('disk', 12);
Ilogic = imdilate(Ilogic, s);
Ilogic = imfill(Ilogic,'holes');
mask = imerode(Ilogic, s);

end

