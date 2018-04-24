clear all; close all; clc;
%%
I = imread('Images/noct02.jpg');
% I = imread('Images/Scarabaeus-v.jpg');
% I = imread('Images/image_galleryzoom.jpg');
I = imresize(I,[300 300]);
figure(1); imshow(I);

% Segmentation 7 étapes
Igray = rgb2gray(I);
%%
bw = edge(Igray, 'Canny');
figure(2); imshow(bw);
%%
s = strel('disk', 2);
Ic = imclose(bw, s);


figure(3); imshow(Ic);

%%
 If = imfill(Ic,'holes');
 
 s = strel('disk', 1);
If = imopen(If, s);

 figure(4); imshow(If);
 %figure(4); contour(Ic);
 %%
 label = bwlabel(If);
 
 figure(5); imshow(label,[]);
 %%
 stat = regionprops(label,'Area');
 %%
area = [stat.Area];
[val,idx] = max(area);
 
%%
Ilogic = (label==idx);
figure(6); imshow(Ilogic);

% s = strel('disk', 5);
% Ilogic = imopen(Ilogic, s);
% 
% figure(7); imshow(Ilogic);


     
