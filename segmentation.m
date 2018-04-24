clear all; close all; clc;
%%
% I = imread('Images/noct02.jpg');
% I = imread('Images/_471_.jpg');
I = imread('Images/09_09_12_170.jpg');
% I = imread('Images/aab_0892.jpg');
% I = imread('Images/aeshna_affinis_0x.jpg');
% I = imread('Images/bourdonC.jpg');
% I = imread('Images/eurytomidae_1.2_.jpg');
% I = imread('Images/img_0597.jpg');
% I = imread('Images/img_7252.jpg.jpg');
% I = imread('Images/Scarabaeus-v.jpg');
% I = imread('Images/image_galleryzoom.jpg');
I = imresize(I,[300 300]);


% Segmentation 7 étapes
Igray = rgb2gray(I);
figure(1); imshow(Igray);
s = strel('disk', 10);
Igray = imopen(Igray, s);


%%
% bw = edge(Igray, 'Canny');
% bw = edge(Igray, 'Sobel');
bw = edge(Igray, 'Prewitt');
% bw = edge(Igray, 'Roberts');
% bw = edge(Igray, 'approxcanny');
% bw = edge(Igray, 'log');

% bw = bw1  bw2;
figure(2); imshow(bw);
%%
s = strel('disk', 10);
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


     
