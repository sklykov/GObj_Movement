clc; close all; clear variables; 
% The main script for generation of moving objects with Gaussian shapes by
% saving sequence of generated pictures in a current folder. This version
% generates randomly allocated objects going divided to two different
% subpopulations (two velocities). Added object appearance and
% disappearance events. The main goal - to make a ground truth movie for
% testing of developed tracking program features
%% properties of objects
sigma=4; % define size of Gaussian shape object through defining std
picSize = 800; % define size of background picture (related to density of objects in picture)
NumbObj=2; % define number of objects (related to density of objects in picture)
sigma_angle = 15; % sigma(std) in gaussian distribution of possible displacement angle (curvature)
NumbFrames=10; % # of frames for movie generation
%% generation of random disturbed objects through the picture (initial)
angles = zeros(NumbObj,1,'double'); % preallocation of angles
objects(1:NumbObj,1)=flObj(sigma,'g',1,1,1); % generation array of objects (id isn't unique)
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
name=strcat(num2str(1),'.png'); % making a name in format "1.png"
imwrite(Pic,name); % save picture with an initial distribution
% figure; imshow(Pic);
%% drawing remained frames (initial_#_frames - 1)
iter=2; %counter
thresholdV=0.05; % probability of object appearance
while iter<=NumbFrames 
    Pic=0; % generate empty picture
    l=0; % counter
    NumbObj = size(objects,1);
    for i=1:1:NumbObj
        objects=objects(i).appear(objects,thresholdV,picSize);
    end
    if size(objects,1)-NumbObj>0 % condition of new object generation
            j=0;
            while (size(objects,1)-NumbObj-j)>0
                addAngle=randi(361)-1;
                angles=cat(1,angles,addAngle);
                j=j+1;
            end
    end
    NumbObj = size(objects,1);
    for i=1:1:NumbObj
        xCyC=objects(i).curved(angles(i),sigma_angle,sigma*2,sigma*3);
        objects(i).xc=xCyC(1); objects(i).yc=xCyC(2); angles(i)=xCyC(3);
        PO = picWithObj4(BckGr,objects(i),Pic);
        Pic=PO.fuse(); % draw the object
        c=PO.paint(); % paint - defying is the object could be introduced to picture
        if c{1} % flag, true = still existing "paintable" object
            l=l+1;
        end
    end
    if l>0
        name=strcat(num2str(iter+1),'.png');
        imwrite(Pic,name);
%         figure; imshow(Pic);
    end
    iter=iter+1;
end
