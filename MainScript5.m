clc; close all; clear variables; 
% Main script for generation of moving objects with Gaussian shapes  

%% properties of objects
sigma=100; % define size of Gaussian shape object
picSize = 500; % define size of background picture
NumbObj=50; % define number of objects
coord = zeros(2*NumbObj,1,'uint16'); % initialize values for # of objects
angles = zeros(NumbObj,1,'double');

%% generation of random disturbed objects through the picture
for i=1:1:NumbObj
    coord(2*i-1)=randi(picSize); % "x" coordinate
    coord(2*i)=randi(picSize); % "y" coordinate
    angles(i)=randi(361)-1; % initial angle of displacement counted from X axis
end

% obj1=flObj(sigma,'g',1,1,1); % just testing 
% I1=obj1.gshape;
% imshow(I1)