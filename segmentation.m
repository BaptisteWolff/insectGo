clear all; close all; clc;
%%
% I = imread('Images/noct02.jpg');
% I = imread('Images/_471_.jpg');
% I = imread('Images/09_09_12_170.jpg');
% I = imread('Images/aab_0892.jpg');
% I = imread('Images/aeshna_affinis_0x.jpg');
% I = imread('Images/bourdonC.jpg');
% I = imread('Images/eurytomidae_1.2_.jpg');
% I = imread('Images/img_0597.jpg');
% I = imread('Images/img_7252.jpg.jpg');
% I = imread('Images/Scarabaeus-v.jpg');
% I = imread('Images/image_galleryzoom.jpg');

% Get list of all BMP files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
imagefiles = dir('Images/*.jpg');      
nfiles = length(imagefiles);    % Number of files found

for ii=1:nfiles
   currentfilename = ['Images/' imagefiles(ii).name];
   currentimage = imread(currentfilename);
   I = currentimage;
%    I = gpuArray(I);

    
%     I = imresize(I,[2000 2000]);

    % Segmentation 7 étapes
    Igray = rgb2gray(I);
    Igray = imresize(Igray,[2000 2000]);
    figure(); 
    subplot(1,2,1);
    imshow(Igray);
    s = strel('disk', 20);%7
    Igray = imopen(Igray, s);


    %%
%     bw = edge(Igray, 'Canny');
    bw = edge(Igray, 'Sobel');
%     bw = edge(Igray, 'Prewitt');
%     bw = edge(Igray, 'Roberts');
    % bw = edge(Igray, 'approxcanny');
%     bw = edge(Igray, 'log');

    % bw = bw1  bw2;
%     figure(2); imshow(bw);
    %%
    s = strel('disk', 6);%6
    Ic = imdilate(bw, s);
%     s = strel('disk', 20);
%     IC = imerode(Ic, s);


%     figure(3); imshow(Ic);

    %%
     If = imfill(Ic,'holes');

%      s = strel('disk', 6);
%     If = imopen(If, s);

%      figure(4); imshow(If);
     %figure(4); contour(Ic);
     %%
     label = bwlabel(If);

%      figure(5); imshow(label,[]);
     %%
     stat = regionprops(label,'Area');
     %%
    area = [stat.Area];
    [val,idx] = max(area);

    %%
    Ilogic = (label==idx);
%     
%     
% %     %% ajout
    
    s = strel('disk', 12);%6
    Ilogic = imdilate(Ilogic, s);
%     s = strel('disk', 20);
%     IC = imclose(Ic, s);


%     figure(3); imshow(Ic);

    %
     Ilogic = imfill(Ilogic,'holes');
%      s = strel('disk', 10);
   Ilogic = imerode(Ilogic, s);
%    Ilogic = imopen(Ilogic,s);
    
    %% ajout
    
%     figure(); 
    subplot(1,2,2);
    imshow(Ilogic);

    % s = strel('disk', 5);
    % Ilogic = imopen(Ilogic, s);
    % 
    % figure(7); imshow(Ilogic);


end     
