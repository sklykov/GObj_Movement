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
NumbObj=80; % define number of objects (related to density of objects in picture)
sigma_angle = 10; % sigma(std) in gaussian distribution of possible displacement angle (curvature)
NumbFrames=50; % # of frames for movie generation

%% initialization of the entry data
BckGr=Picture(picSize); % initialize the instance of class "Picture" 
obArr = objectsArr(NumbObj,flObj(sigma,'g',1,1,1)); % initialize the array with objects
obArr.arrayGen(picSize); % initialize randomly allocated objects
Pic=obArr.drawFirst(BckGr); % create first frame
obArr.instat(Pic); % initialization of statistics counting
name=strcat(num2str(1),'.png'); % making the picture name in format "1.png"
% imwrite(Pic,name); % save picture with an initial distribution
% figure; imshow(Pic);

%% drawing remained frames (initial_#_of_frames - 1)
iter=2; % counter of frames
thApp=1; % probability of object appearance
thresholdDis=0.005; % probability of object disappearance
obArr.emerge(thApp,picSize);
obArr.update()
% obArr.arrayObjs

% while iter<=NumbFrames
%     Pic=0; % generate empty picture
%     l=0; % counter
%     %% object appearance (only single for the frame - "the sudden object appearance")
%     NumbObj = size(objects,1);
%     objects=objects(1).appear(objects,thresholdApp,picSize); % appearing event of particle
%     if size(objects,1)-NumbObj>0 % checking if new object has been generated at the previous step
%             addAngle=randi(361)-1; % generate initial angle of displacement for newly generated object
%             angles=cat(1,angles,addAngle); % adding the generated angle to the array
%     end
%     %% object disappearance (may happens for any of objects with predefined probability)
%     % if object has disappeared, then a new object could appear with
%     % probability 0.9 for compensation of decreasing objects density
%     i=1; % counter
%     while i<=size(objects,1)
%         NObj=size(objects,1);
%         objects=objects(i).disappear(objects,i,thresholdDis);
%         if size(objects,1)-NObj<0 % checking if new object has been generated at the previous step
%             angles(i)=[]; % removing corresponded angle
%             NObj=size(objects,1);
%             objects=objects(1).appear(objects,0.9,picSize); % appearing event of particle
%             if size(objects,1)-NObj>0 % checking if new object has been generated at the previous step
%                 addAngle=randi(361)-1; % generate initial angle of displacement for newly generated object
%                 angles=cat(1,angles,addAngle); % adding the generated angle to the array
%             end
%         else i=i+1;
%         end
%     end
%     %% drawing of objects (incl. appeared)
%     NumbObj = size(objects,1); i=1; % counter
%     while i<=size(objects,1)
%         xCyC=objects(i).curved(angles(i),sigma_angle,sigma*1.5,sigma*3); % returning coordinates
%         objects(i).xc=xCyC(1); objects(i).yc=xCyC(2); angles(i)=xCyC(3); % assigning coordinates and angle
%         PO = picWithObj4(BckGr,objects(i),Pic);
%         c=PO.paint(); % paint - defying is the object could be introduced to picture
%         if c{1} % flag, true = still existing "paintable" object
%             l=l+1; % defines if the frame could be saved or not      
%             Pic=PO.fuse(); % draw the object
%             i=i+1; % increase the # of object
%         else objects(i)=[]; % kind of removing of particle which has gone out the picture borders
%              angles(i)=[]; % removing a related angle
%              % object dissappear => let's generate with high probability
%              % new one for replacement of gone one
%              NumbObj = size(objects,1); % refresh # of objects
%              objects=objects(1).appear(objects,0.9,picSize); % appearing event of particle
%             if size(objects,1)-NumbObj>0 % checking if new object has been generated at the previous step
%                 addAngle=randi(361)-1; % generate initial angle of displacement for newly generated object
%                 angles=cat(1,angles,addAngle); % adding the generated angle to the array
%             end
%         end
%         NumbObj = size(objects,1); 
%     end
%     if l>0
% %         name=strcat(num2str(iter),'.png'); % creation of name with format "1.png"
% %         imwrite(Pic,name); % saving the generated frame with objects
% %         figure; imshow(Pic);
%     end
%     iter=iter+1;
% end
