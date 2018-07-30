clc; close all; clear variables; 
% Main script for generation of moving objects with Gaussian shapes  

%% properties of objects
sigma=5; % define size of Gaussian shape object
picSize = 500; % define size of background picture
NumbObj=50; % define number of objects
coord = zeros(2*NumbObj,1,'uint16'); % initialize # of objects
angles = zeros(NumbObj,1,'double');
speed=14; % assign as pixels/frame for each object

%% generation of random disturbed objects through the picture
for i=1:1:NumbObj
    coord(2*i-1)=randi(picSize); % "x" coordinate
    coord(2*i)=randi(picSize); % "y" coordinate
    angles(i)=randi(361)-1; % 
end

%% creation sample of object
G1 = GaussObj(sigma); P1 = Picture(picSize); % generate samples of relevant classes
% I1 = G1.shape; B1 = P1.blank; % methods gives the generated objects
BI1=0; % here is absolutely empty picture containing 1 pixel
PO(1:NumbObj)=picWithObj2(P1,G1,1,1,BI1); % create array of classes
for i=1:1:NumbObj
    PO1 = picWithObj2(P1,G1,coord(2*i-1),coord(2*i),BI1); 
    BI1=PO1.fuse; % fuse objects in picture
    PO(i)=PO1;
end
% imwrite(BI1,'1.png'); 
iter=1; 
% imshow(BI1);

%% create movie
flag1=true;  
while flag1
    BI2=P1.blank; % generate blank picture
    l=0; % after generation of each frame this value is used for checking of 
    % presence of any "paintable" object
    for i=1:1:NumbObj
        xCyC=PO(i).linear(angles(i),speed);
        coord(2*i-1)=xCyC(1); coord(2*i)=xCyC(2);
        PO(i) = picWithObj2(P1,G1,coord(2*i-1),coord(2*i),BI2);
        BI2=PO(i).fuse;
        c=PO(i).paint;
        if c{1}
            l=l+1;
        end
    end
    if l>0
        flag1=true;
        name=strcat(num2str(iter),'.png');
        imwrite(BI2,name);
    else flag1=false;
    end
    iter=iter+1;
end
