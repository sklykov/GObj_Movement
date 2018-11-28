clc; close all; clear variables; 
% The main script for generation of moving objects with Gaussian shapes by
% saving sequence of generated pictures in a current folder. This version
% generates randomly allocated objects going divided to two different
% subpopulations (two velocities). 
% Version 2: utilization of "objectsArr" class for storing generated
% objects and collecting related statistics + different events (stopping,
% emerging, disappearing, etc)
%% properties of objects
sigma=5; % define size of Gaussian shape object through defining std
picSize=1000; % define size of background picture (related to density of objects in picture)
NumbObj=200; % define number of objects (related to density of objects in picture)
sigma_angle=20; % sigma(std) in gaussian distribution of possible displacement angle (curvature)
NumbFrames=100; % # of frames for movie generation
Vel1=sigma*2; % mean velocity of first subpopulation of moving objects
Vel2=sigma*3; % mean velocity of second subpopulation of moving objects
disp_vel=0.25; % set the dispersion coefficient in the equation (mean_velocity*dispersion_coefficient)
dRmax=1; % maximal displacement for oscillating movements ("halting or stopping or stacking") 

%% initialization of the entry data
BckGr=Picture(picSize); % initialize the instance of class "Picture" 
obArr = objectsArr(NumbObj,flObj(sigma,'g',1,1,1)); % initialize the array with objects
obArr.arrayGen(picSize); % initialize randomly allocated objects
Pic=obArr.drawFirst(BckGr); % create first frame
obArr.instat(Pic); % initialization of statistics counting
name=strcat(num2str(1),'.png'); % making the picture name in format "1.png"
imwrite(Pic,name); % save picture with an initial distribution
% figure; imshow(Pic);

%% properties for handling dynamical events connected with objects
thApp=1E-4; % probability of object appearance
thDis=3E-3; % probability of object disappearance 
thHalt=0.04; % probability of object stopping (halting)
thRec=1E-2; % probability of object continue moving after pause (stopping event)

%% drawing remained frames (initial_#_of_frames - 1)
iter=2; % counter of frames
while iter<=NumbFrames
    Pic=0; % generate empty picture for drawing of objects
    l=0; % counter
    BckGr=Picture(picSize); % creation of background
    obArr.emerge(thApp,picSize); % appearance of an object
    for i=1:1:obArr.amount
        obArr.disappear(thDis,i); % suddenly object disappearance
        obArr.stopping(thHalt,i); % object is stopped in some region (docked to something, trapped somewhere)
        obArr.recover(thRec,i,iter,dRmax); % recovering of object moving (now with constant probability)
    end
    obArr.curvedDispl(sigma_angle,Vel1,Vel2,disp_vel,BckGr,Pic,iter,dRmax,NumbObj); % calculation of displacements - curved motion
    Pic=obArr.drawFrame(BckGr); % draw objects in pictures
    if size(Pic,1)>0
        name=strcat(num2str(iter),'.png'); % creation of name with format "1.png"
        imwrite(Pic,name); % saving the generated frame with objects
%         figure; imshow(Pic);
    end
    iter=iter+1;
end
obArr.saveReport(dRmax); % save dynamic properties
