clear all; close all; clc;
%%
I = imread('Images/noct02.jpg');
figure(1); imshow(I);

% Segmentation 7 �tapes
Igray = rgb2gray(I);
%%
bw = edge(Igray, 'Canny');
figure(2); imshow(bw);
%%
s = strel('disk', 1);
Ic = imclose(bw, s);

figure(3); imshow(Ic);

%%
% If = imfill(Ic,'holes');
% figure(4); imshow(If);

figure(4); contour(Ic);