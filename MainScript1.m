clc; close all;
% properties of objects
double sigma; uint16 picSize; double xC; double yC; 
sigma=4; % define size of Gaussian shape object
picSize = 200; % define size of background picture
xC=8; yC=8; % coordinates of particle center
% creation sample of object
G1 = GaussObj(sigma); P1 = Picture(picSize); % generate samples of objects
I1 = G1.shape; B1 = P1.blank; % methods gives the generated objects
PO1 = picWithObj(P1,G1,xC,yC,0);
BI1=PO1.fuse;
xC=xC+4*sigma; yC=yC+6*sigma; 
PO2 = picWithObj(P1,G1,xC,yC,BI1);
BI2=PO2.fuse;

figure; imshow(BI1)
figure; imshow(BI2)
% imshow(I1);
% imshow(B1)
