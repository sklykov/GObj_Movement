clc; close all; clear all; 
% properties of objects
sigma=4; % define size of Gaussian shape object
picSize = 500; % define size of background picture
coord = zeros(10,'uint16');
for i=1:1:size(coord)/2
    coord(2*i-1)=randi(picSize);
    coord(2*i)=randi(picSize);
end
% creation sample of object
G1 = GaussObj(sigma); P1 = Picture(picSize); % generate samples of objects
% I1 = G1.shape; B1 = P1.blank; % methods gives the generated objects
BI1=0;
for i=1:1:size(coord)/2
    PO1 = picWithObj2(P1,G1,coord(2*i-1),coord(2*i),BI1);
    BI1=PO1.fuse;
end
% imwrite(BI1,'1.png'); 
iter=2; 
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

