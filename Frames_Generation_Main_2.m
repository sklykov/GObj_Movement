clc; close all; clear variables; 
% The main script for generation of moving objects with Gaussian shapes by
% saving sequence of generated pictures in a current folder. This version
% generates randomly allocated objects going divided to two different
% subpopulations (two velocities). 
% Version 2: utilization of "objectsArr" class for storing generated
% objects and collecting related statistics
%% properties of objects
sigma=5; % define size of Gaussian shape object through defining std
picSize = 1000; % define size of background picture (related to density of objects in picture)
NumbObj=100; % define number of objects (related to density of objects in picture)
sigma_angle = 10; % sigma(std) in gaussian distribution of possible displacement angle (curvature)
NumbFrames=100; % # of frames for movie generation

%% initialization of the entry data
BckGr=Picture(picSize); % initialize the instance of class "Picture" 
obArr = objectsArr(NumbObj,flObj(sigma,'g',1,1,1)); % initialize the array with objects
obArr.arrayGen(picSize); % initialize randomly allocated objects
Pic=obArr.drawFirst(BckGr); % create first frame
obArr.instat(Pic); % initialization of statistics counting
name=strcat(num2str(1),'.png'); % making the picture name in format "1.png"
imwrite(Pic,name); % save picture with an initial distribution
% figure; imshow(Pic);

%% drawing remained frames (initial_#_of_frames - 1)
iter=2; % counter of frames
thApp=0.1; % probability of object appearance
thDis=1E-3; % probability of object disappearance 
thresholdDis=0.005; % probability of object disappearance
while iter<=NumbFrames
    Pic=0; % generate empty picture for drawing of objects
    l=0; % counter
    BckGr=Picture(picSize); % creation of background
    obArr.emerge(thApp,picSize); % appearance of an object
    for i=1:1:obArr.amount
        obArr.disappear(thDis,i); % suddenly object disappearance
    end
    obArr.curvedDispl(10,15,30,0.25,BckGr,Pic,iter); % calculation of displacements
    Pic=obArr.drawFrame(BckGr); % draw objects in pictures
    if size(Pic,1)>0
        name=strcat(num2str(iter),'.png'); % creation of name with format "1.png"
        imwrite(Pic,name); % saving the generated frame with objects
%         figure; imshow(Pic);
    end
    iter=iter+1;
end
