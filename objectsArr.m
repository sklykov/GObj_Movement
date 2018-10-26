classdef objectsArr < handle
    % This class collects the attributes and methods related to creation of
    % array of objects spreaded on the background 
    
    %% statistical parameters of the array
    properties
        amount; 
        angles; 
        meanInstV;
        trackL;
        object;
        arrayObjs;
        crossings;
        displacements;
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
    
    %% initialize statistics calculation
    methods
        function []=instat(objectsArr,Pic) % seems that empty matrix [] plays the role of void function
            if size(Pic)>1 % just 1st frame isn't empty
                objectsArr.trackL=ones(size(objectsArr.arrayObjs)); % all tracks obtain the length "1"
            end
        end
    end
    
    %% appearance of object (with predefined probability)
    methods
        function em = emerge(objectsArr,threshold,picSize)
            if rand<threshold
                N=size(objectsArr.arrayObjs,1); % last index in objects array
                sizeObj = objectsArr.arrayObjs(N).s; shapeObj=objectsArr.arrayObjs(N).shape; 
                shapeObj=char(shapeObj); addObj=flObj(sizeObj,shapeObj,1,1,1); % create new fluorescent object
                addObj.id=objectsArr.arrayObjs(N).id+1; % enumeration of objects
                addObj.xc=randi(picSize); addObj.yc=randi(picSize); % x,y coordinates
                objectsArr.arrayObjs=cat(1,objectsArr.arrayObjs,addObj); % append to array created object
                em=true; % flag shows that new object have appeared in the frame
            end
        end
    end
    
    %% update objects attributes after object appearance
    methods
        function [] = update(objectsArr) % [] - again instead of void function
            if (objectsArr.amount-size(objectsArr.arrayObjs,1))<0 % this 
                addAngle=randi(361)-1; % randomly create new angle
                objectsArr.angles=cat(1,objectsArr.angles,addAngle); % append new angle
                objectsArr.trackL=cat(1,objectsArr.trackL,1); % initialize track length
                objectsArr.amount=objectsArr.amount+1;
            end
        end
    end
end

