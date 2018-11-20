classdef objectsArr < handle
    % This class collects the attributes and methods related to creation of
    % array of objects spreaded on the background 
    
    %% statistical parameters of the array
    properties
        amount; 
        angles; 
        trackL;
        object;
        arrayObjs;
        displacements;
        coordinates;
    end
    
    %% constructor
    % it only demands amount of them and sample of "flObj"
    methods
        function obArr = objectsArr(amount,object)
            obArr.amount = amount; obArr.object=object; % two main parameters - amount of and type of objects
         end
    end

    %% generate the array with objects
    methods 
        function arrayRand = arrayGen(objectsArr,picSize)
            nObj=objectsArr.amount; % additional value? just make shorter name!
            arrayRand(1:nObj,1)=objectsArr.object; % initialize the array with fluorescent objects
            objectsArr.angles(1:nObj,1)=0; % initialize the array with angles (between initial displacement and X axis)
            if isa(objectsArr.object,'flObj') % checking that appropriate class is used
                for i=1:1:nObj
                    arrayRand(i).id=i; % assigh id for instances
                    objectsArr.angles(i)=randi(361)-1; % assign the random angle of initial displacement
                    arrayRand(i).xc=randi(picSize); % assign the random X coordinate
                    arrayRand(i).yc=randi(picSize); % assign the random Y coordinate
                end
                objectsArr.arrayObjs=arrayRand; % transfer generated array to class properties
            else warning('specify behaviour for other input class')   
            end          
        end
    end
    
    %% draw all objects in the first (initial) frame
    methods
        function draw1 = drawFirst(objectsArr,Background)
            draw1=0; % initialize picture with as 1 zero pixel (1x1 array)
            for i=1:1:objectsArr.amount
                PO = picWithObj4(Background,objectsArr.arrayObjs(i),draw1); % instance of "picture with objects"
                draw1 = PO.fuse();
            end
        end
    end
    
    %% draw objects in a frame (depending on their id)
    methods
        function drawn = drawFrame(objectsArr,Background)
            Picture=0; % picture with 1 zero pixel initialization 
            for i=1:1:objectsArr.amount
                if objectsArr.arrayObjs(i).id > 0 % check if the current object isn't labelled
                    PO = picWithObj4(Background,objectsArr.arrayObjs(i),Picture); % instance of class "picWithObj4"
                    Picture=PO.fuse(); % draw object
                end
            end
            drawn=Picture; 
        end
    end
    
    %% initialize statistics calculation
    methods
        function []=instat(objectsArr,Pic) % seems that empty matrix [] plays the role of void function
            dimension=size(Pic); % just quick workaround to access row numbers in the array
            if (dimension(1)>1)&&(objectsArr.amount>0) % just 1st frame isn't empty & instances of objects already generated
                objectsArr.trackL=zeros(objectsArr.amount,1,'uint16'); % assign zero length to all tracks
                objectsArr.displacements=zeros(objectsArr.amount,1); % all displacements are zero
%                 objectsArr.coordinates=zeros(2,objectsArr.amount); % all coordinates are zero
%                 for j=1:1:objectsArr.amount
%                     objectsArr.coordinates(1,j)=objectsArr.arrayObjs(j).xc; % save firstly "x" coordinates
%                     objectsArr.coordinates(2,j)=objectsArr.arrayObjs(j).yc; % after it - "y" coordinates
%                 end
            end
        end
    end
    
    %% appearance of object (with predefined probability)
    methods
        function em = emerge(objectsArr,threshold,picSize)
            if rand<threshold
                N=size(objectsArr.arrayObjs,1); % last index in objects array
                sizeObj = objectsArr.arrayObjs(N).s; shapeObj=objectsArr.arrayObjs(N).shape; % get object properties
                shapeObj=char(shapeObj); addObj=flObj(sizeObj,shapeObj,1,1,1); % create new fluorescent object
                addObj.id=N+1; % enumeration of objects (corrected)
                addObj.id
                xc=randi(picSize); yc=randi(picSize); % x,y coordinates
                xAv=(objectsArr.arrayObjs(1).s-1)/2; 
                if xc<xAv % checking generated values and correct them 
                    xc=xAv+4; % to be sure that generated objects obtain normal coordinates 
                elseif xc>picSize-xAv %(conditions here and below)
                    xc=picSize-xAv-4;
                end
                if yc<xAv
                    yc=xAv+4;
                elseif yc>picSize-xAv
                    yc=picSize-xAv-4;
                end
                addObj.xc=xc; addObj.yc=yc; % assign corrected values
                objectsArr.arrayObjs=cat(1,objectsArr.arrayObjs,addObj); % append to array created object
                addAngle=randi(361)-1; % randomly create new angle
                objectsArr.angles=cat(1,objectsArr.angles,addAngle); % append new angle
                objectsArr.amount=objectsArr.amount+1; % amount ++
                objectsArr.trackL=cat(1,objectsArr.trackL,0); % initialize track length recording for new track
                [~,nColumns]=size(objectsArr.displacements); % get number of columns, ~ - instead of unused value
                newRow=zeros(1,nColumns); clear('nRows');
                objectsArr.displacements=cat(1,objectsArr.displacements,newRow); % new recording of particle displacements
%                 dimen1 = size(objectsArr.coordinates,1); newCoord=zeros(dimen1,1); % intialize empty subarray for storing coordinates
%                 objectsArr.coordinates=cat(2,objectsArr.coordinates,newCoord); % append this empty array
%                 dimen2 = size(objectsArr.coordinates,2);
                em=true; % flag shows that new object have appeared in the frame
            end
        end
    end
    
    %% disappearance of object
    methods
        function [] = disappear(objectsArr,threshold,index)
            if rand<threshold
%                 objectsArr.arrayObjs(index)=[]; % deletion of object(i) from the array
%                 objectsArr.angles(index)=[]; % deletion of related angle
%                 objectsArr.amount=objectsArr.amount-1; % amount --
%                 dis = objectsArr; % return of instance of class "objects array" 
                objectsArr.arrayObjs(index).id = -1; % label such disappeared objects
            end
        end
    end
      
    %% generate curved motion (update coordinates)
    % method for generation of curved motion and immideately statistics
    % update 
    methods
        function curv = curvedDispl(objectsArr,sigma_angles,mean_vel1,mean_vel2,disp_vel,BckGr,Pic,nFrame)
            excl=0; % counter of excluded objects from further drawing (becomes out of borders)
            if nFrame>2
                N=size(objectsArr.displacements,1); % get number of rows in the related column
                newCol=zeros(N,1); % initialize the column with zeros
                objectsArr.displacements=cat(2,objectsArr.displacements,newCol); % append the initilized column
            end
            for i=1:1:objectsArr.amount
                if (objectsArr.arrayObjs(i).id > 0) % activate only for presented objects
                   objectsArr.trackL(i)=objectsArr.trackL(i)+1; % update the length of tracks
                   x=objectsArr.arrayObjs(i).xc; y=objectsArr.arrayObjs(i).yc; % get coordinates
                   xCyC=objectsArr.arrayObjs(i).curved(objectsArr.angles(i),sigma_angles,mean_vel1,mean_vel2,disp_vel);
                   objectsArr.arrayObjs(i).xc=xCyC(1); objectsArr.arrayObjs(i).yc=xCyC(2); % save assigned coordinates
                   objectsArr.angles(i)=xCyC(3); % modify angle of movement
                   PO = picWithObj4(BckGr,objectsArr.arrayObjs(i),Pic); % instance of class "picWithObj4"
                   c = PO.paint(); % define if objects stays in the frame limits
                   if c{1} % checking there appears object
                       x=cast(x,'double'); y=cast(y,'double'); 
                       dR=sqrt((x-xCyC(1))^2+((y-xCyC(2))^2)); % calculation of Euclidian displacement
                       if nFrame==2 % for the second frame  
                           objectsArr.displacements(i)=dR; % save calculated Euclidian displacements
                       else objectsArr.displacements(i,nFrame-1)=dR;
                       end
                   else excl=excl+1;
                       objectsArr.arrayObjs(i).id = -1; % assign id for exclusion 
                   end
                end
            end
            i1=0; % counter
            while i1<excl % loop for generation the objects with high probability instead of disappeared
                objectsArr.emerge(0.95,BckGr.N); % appearance of object with 0.95 probability
                i1=i1+1;
            end
            curv=objectsArr; % return new instance of "objects array" class
        end
    end
    
    %% make the report and save it in the active directory
    % for recording of the dynamic parameters 
    methods
        function []=saveReport(objectsArr)
            %% excluding tracks with zero length and save only not zero ones
            nRows=size(objectsArr.trackL,1); i=1;
            while i<=nRows
                if objectsArr.trackL(i)>0
                    i=i+1;
                else objectsArr.trackL(i)=[];
                    nRows=size(objectsArr.trackL,1);
                end
            end
            xlswrite('Track_Lengths_GR.xls',objectsArr.trackL); % directly save csv file
            %% averaging of displacements in rows
            [nRows,nCols]=size(objectsArr.displacements); % get # rows and columns
            avInstant=zeros(nRows,1,'double');
            for i=1:1:nRows
                sum=0; n=0; % initial values
                for j=1:1:nCols
                    if objectsArr.displacements(i,j)>0 % checking elements
                        sum=sum+objectsArr.displacements(i,j); % summarize
                        n=n+1;
                    end
                end
                if n>0
                    avInstant(i,1)=sum/n; % average displacement along a track
                end
            end
            i=1;
            while i<=nRows
                if avInstant(i,1)>0
                   i=i+1;
                else avInstant(i)=[];
                    nRows=size(avInstant,1);
                end
            end
            xlswrite('Mean_Instant_Vels_GR.xls',avInstant); % xls file... proprietary format... but working! 
            clear('avInstant'); % clear allocated variable
            %% collect all instant 
            [nRows,nCols]=size(objectsArr.displacements); % get # rows and columns
            nSize=nRows*nCols; % size of overall array
            overInst=zeros(nSize,1,'double'); % intialize the array for collecting displacements
            n=1;
            for i=1:1:nRows
                for j=1:1:nCols
                    if objectsArr.displacements(i,j)>0 % checking elements
                       overInst(n,1)=objectsArr.displacements(i,j); % saving not zero value
                       n=n+1; 
                    end
                end
            end
            overInst=overInst(1:n-1,1); % delete all zero elements
%             csvwrite('All_Instant_Vels.csv',overInst); % save all instant velocities in 1 array
            xlswrite('All_Instant_Vels_GR.xls',overInst); % honestly, better compatibility with delimeters issues
            clear('overInst'); % clear variable
        end
    end
    
end

