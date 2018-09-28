clc; close all; clear all; 
% properties of objects
sigma=4; % define size of Gaussian shape object
picSize = 500; % define size of background picture
xC1=1; yC1=picSize/2; % coordinates of particle center
yC2=1; xC2=picSize/2; 
% creation sample of object
G1 = GaussObj(sigma); P1 = Picture(picSize); % generate samples of objects
% I1 = G1.shape; B1 = P1.blank; % methods gives the generated objects
PO1 = picWithObj2(P1,G1,xC1,yC1,0);
BI1=PO1.fuse;
PO1 = picWithObj2(P1,G1,xC2,yC2,BI1);
BI1=PO1.fuse; 
% imwrite(BI1,'1.png'); 
iter=2; xC1 = xC1 + 2*sigma; yC2 = yC2 + 2*sigma;
imshow(BI1);

% while xC1<=picSize-3*sigma
%     BI2=0;
%     PO2 = picWithObj(P1,G1,xC1,yC1,BI2);
%     BI2=PO2.fuse;
%     PO2 = picWithObj(P1,G1,xC2,yC2,BI2);
%     BI2=PO2.fuse;
%     name=strcat(num2str(iter),'.png');
% %     imwrite(BI2,name);
%     xC1 = xC1 + 2*sigma;
%     yC2 = yC2 + 2*sigma;
%     iter=iter+1;
% end

