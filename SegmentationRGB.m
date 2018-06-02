function [ img ] = SegmentationRGB( image )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% nom='3.jpg';
% img=imread(nom);
img = image;
[li,co,~]=size(img);
t=0.1;
% Marquer les 4 coins pris sur image
% img(1:ceil(t*li),1:ceil(t*co))=0;
% img(1:ceil(t*li),floor((1-t)*co):co)=0;
% img(ceil((1-t)*li):li,1:ceil(t*co))=0;
% img(ceil((1-t)*li):li,ceil((1-t)*co):co)=0;
% imshow(img);
% img=imread(nom);
% Coins
coin1=img(1:ceil(t*li),1:ceil(t*co),:);
coin2=img(1:ceil(t*li),floor((1-t)*co):co,:);
coin3=img(ceil((1-t)*li):li,1:ceil(t*co),:);
coin4=img(ceil((1-t)*li):li,ceil((1-t)*co):co,:);
% Afficher les 4 coins
% figure,
% subplot(2,2,1), imshow(coin1);
% subplot(2,2,2), imshow(coin2);
% subplot(2,2,3), imshow(coin3);
% subplot(2,2,4), imshow(coin4);
% Moyennes RGB
[li1,co1,~]=size(coin1); size1=li1*co1;
[li2,co2,~]=size(coin2); size2=li2*co2;
[li3,co3,~]=size(coin3); size3=li3*co3;
[li4,co4,~]=size(coin4); size4=li4*co4;
clear li1 li2 li3 li4 co1 co2 co3 co4
moyR=sum(sum(coin1(:,:,1)))/size1+...
    sum(sum(coin2(:,:,1)))/size2+...
    sum(sum(coin3(:,:,1)))/size3+...
    sum(sum(coin4(:,:,1)))/size4;
moyG=sum(sum(coin1(:,:,2)))/size1+...
    sum(sum(coin2(:,:,2)))/size2+...
    sum(sum(coin3(:,:,2)))/size3+...
    sum(sum(coin4(:,:,2)))/size4;
moyB=sum(sum(coin1(:,:,3)))/size1+...
    sum(sum(coin2(:,:,3)))/size2+...
    sum(sum(coin3(:,:,3)))/size3+...
    sum(sum(coin4(:,:,3)))/size4;
% Parcourir l'image
a=0.10;
for i=1:li
    for j=1:co
        if img(i,j,1)<(1+a)*moyR && img(i,j,1)>a*moyR
            if img(i,j,2)<(1+a)*moyG && img(i,j,2)>a*moyG
                if img(i,j,3)<(1+a)*moyB && img(i,j,1)>a*moyB
                    [img(i,j,1),img(i,j,2),img(i,j,3)] = deal(0);
                else
                    [img(i,j,1),img(i,j,2),img(i,j,3)] = deal(255);
                end
            else
                [img(i,j,1),img(i,j,2),img(i,j,3)] = deal(255);
            end
        else
            [img(i,j,1),img(i,j,2),img(i,j,3)] = deal(255);
        end
    end
end
% figure,subplot(2,2,1),imshow(img);
% La plus grande partie
img=maxRegion(img);
% subplot(2,2,2),imshow(img);
% Remplir les trous
img=imfill(img,'holes');
% holes=filled&~img;
% bigholes=bwareaopen(holes,400);
% smallholes=holes&~bigholes;
% img=img|smallholes;
% subplot(2,2,3),imshow(img);
img = bwperim(img,8);
% subplot(2,2,4),imshow(img);

end

