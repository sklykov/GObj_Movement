clc; close all; clear variables; 
% Main script for generation of moving objects with Gaussian shapes. This
% version generates randomly allocated objects going divided to two
% different subpopulations (two velocities) + angles with gaussian
% distributions
%% properties of objects
sigma=4; % define size of Gaussian shape object
picSize = 800; % define size of background picture
NumbObj=20; % define number of objects
sigma_angle = 15; % sigma in gaussian distribution of possible displacement angle 

%% generation of random disturbed objects through the picture
angles = zeros(NumbObj,1,'double'); % preallocation of angles
objects(1:NumbObj)=flObj(sigma,'g',1,1,1); % generation array of objects (id isn't unique)
for i=1:1:NumbObj
    angles(i)=randi(361)-1; % initial angle of displacement counted from X axis
    objects(i).id=i; % enumeration of objects = giving them id
    objects(i).xc=randi(picSize); % "x" coordinate
    objects(i).yc=randi(picSize); % "y" coordinate
end
%% drawing of generated objects (1st frame)
BckGr=Picture(picSize); % the sample of class "Picture" 
Pic=0; % Pic - empty picture with single pixel value
for i=1:1:NumbObj
    PO = picWithObj4(BckGr,objects(i),Pic);
    Pic = PO.fuse();
end
name=strcat(num2str(1),'.png'); imwrite(Pic,name); % save picture with an initial distribution
% imshow(Pic)
flag1=true; iter=1;   
while iter<100&&flag1
    Pic=0; % generate empty picture
    l=0; % after generation of each frame this value is used for checking of 
    % presence of any "paintable" object
    for i=1:1:NumbObj
        xCyC=objects(i).curved(angles(i),sigma_angle,sigma*2,sigma*6);
        objects(i).xc=xCyC(1); objects(i).yc=xCyC(2); angles(i)=xCyC(3);
        PO = picWithObj4(BckGr,objects(i),Pic);
        Pic=PO.fuse(); % draw the object
        c=PO.paint(); % paint - defying is the object could be introduced to picture
        if c{1} % flag, true = still existing "paintable" object
            l=l+1;
        end
    end
    if l>0
        flag1=true;
        name=strcat(num2str(iter+1),'.png');
        imwrite(Pic,name);
    else flag1=false;
    end
    iter=iter+1;
end
