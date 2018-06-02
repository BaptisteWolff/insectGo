clear; close all;
nom='3.jpg';
img=im2double(imread(nom));
[li,co,~]=size(img);
t=0.2;
% Marquer les 4 coins pris sur image
img(1:ceil(t*li),1:ceil(t*co))=0;
img(1:ceil(t*li),floor((1-t)*co):co)=0;
img(ceil((1-t)*li):li,1:ceil(t*co))=0;
img(ceil((1-t)*li):li,ceil((1-t)*co):co)=0;
imshow(img);
img=im2double(imread(nom));
% RGB->HSV
img=rgb2hsv(img);
% Coins
coin1=img(1:ceil(t*li),1:ceil(t*co),:);
coin2=img(1:ceil(t*li),floor((1-t)*co):co,:);
coin3=img(ceil((1-t)*li):li,1:ceil(t*co),:);
coin4=img(ceil((1-t)*li):li,ceil((1-t)*co):co,:);
[li1,co1,~]=size(coin1); size1=li1*co1;
[li2,co2,~]=size(coin2); size2=li2*co2;
[li3,co3,~]=size(coin3); size3=li3*co3;
[li4,co4,~]=size(coin4); size4=li4*co4;
clear li1 li2 li3 li4 co1 co2 co3 co4
moyH=sum(sum(coin1(:,:,1)))/size1+...
    sum(sum(coin2(:,:,1)))/size2+...
    sum(sum(coin3(:,:,1)))/size3+...
    sum(sum(coin4(:,:,1)))/size4;
moyS=sum(sum(coin1(:,:,2)))/size1+...
    sum(sum(coin2(:,:,2)))/size2+...
    sum(sum(coin3(:,:,2)))/size3+...
    sum(sum(coin4(:,:,2)))/size4;
moyV=sum(sum(coin1(:,:,3)))/size1+...
    sum(sum(coin2(:,:,3)))/size2+...
    sum(sum(coin3(:,:,3)))/size3+...
    sum(sum(coin4(:,:,3)))/size4;
% Parcourir l'image
h=0.05;
s=0.2;
v=0.07;
for i=1:li
    for j=1:co
        if img(i,j,1)<(1+h)*moyH && img(i,j,1)>h*moyH
            if img(i,j,2)<(1+s)*moyS && img(i,j,2)>s*moyS
                if img(i,j,3)<(1+v)*moyV && img(i,j,1)>v*moyV
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
figure,subplot(2,2,1),imshow(img);
% La plus grande partie
img=maxRegion(img);
subplot(2,2,2),imshow(img);
% Erosion/Dilatation
SE = strel('square',3);
img = imdilate(img,SE);
img = imerode(img,SE);

% Remplir les trous
filled=imfill(img,'holes');
holes=filled&~img;
bigholes=bwareaopen(holes,50);
smallholes=holes&~bigholes;
img=img|smallholes;

subplot(2,2,3),imshow(img);
img = bwperim(img,8);
subplot(2,2,4),imshow(img);
