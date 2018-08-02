clc; close all; clear variables; 
% Main script for generation of moving objects with Gaussian shapes  

%% properties of objects
sigma=15; % define size of Gaussian shape object
picSize = 700; % define size of background picture
NumbObj=2; % define number of objects
coord = zeros(2*NumbObj,1,'uint16'); % initialize # of objects
rad = NumbObj*sigma*8; radx=zeros(NumbObj,1,'uint16');

%% generation of disturbed objects
for i=1:1:NumbObj
    radx(i)=rad-4*sigma*(i-1);
    coord(2*i)= radx(i)+(picSize/2);  % "x" coordinate
    coord(2*i-1)= picSize/2; % "y" coordinate
end

%% creation sample of object
G1 = GaussObj(sigma); P1 = Picture(picSize); % generate samples of relevant classes
% I1 = G1.shape; B1 = P1.blank; % methods gives the generated objects
BI1=0; % here is absolutely empty picture containing 1 pixel
% PO(1:NumbObj)=picWithObj2(P1,G1,1,1,BI1); % create array of classes
for i=1:1:NumbObj
    PO1 = picWithObj3(P1,G1,coord(2*i-1),coord(2*i),BI1); 
    BI1=PO1.fuse; % fuse objects in picture (1 picture with multiple objects)
%     PO(i)=PO1; % each object requires instance of class 
end
% imwrite(BI1,'1.png'); 
% figure; imshow(BI1);

%% create movie
angle=0; iter=1;
while angle<=90
    BI2=P1.blank; % generate blank picture
    for i=1:1:NumbObj
         xCyC=PO1.circle(radx(i),angle);
        coord(2*i)=xCyC(1)+picSize/2; 
        coord(2*i-1)=xCyC(2)+picSize/2;
        PO1 = picWithObj3(P1,G1,coord(2*i-1),coord(2*i),BI2);
        BI2=PO1.fuse;
    end
    name=strcat(num2str(iter),'.png');
    imwrite(BI2,name);
%     figure; imshow(BI2);
    angle=angle+10;iter=iter+1;
end
