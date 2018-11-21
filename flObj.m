classdef flObj
    % Generation of "fluorescent object" with attributes like size (in
    % pixels), shape (Gaussian, ...), coordinates of a center, id
    
    %% list of parameters related to the object
    properties
        s; % size in pixels
        shape; % type of an object shape (now - only Gaussian simulated)
        xc; % 'X' coordinate of the particle center
        yc; % 'Y' coordinate of the particle center
        id; % for distinguishing and controlling through ground truth simulation
    end
    
    %% constructor
    methods
        function flObj = flObj(size,shape,x,y,id)
            if (nargin == 5)&&(size>0)&&(ischar(shape))
                flObj.s=size; flObj.shape=shape; flObj.xc=x; flObj.yc=y; flObj.id=id; 
            else warning('incorrect initiation of an object')
            end
        end
    end
    
    %% making or returning a Gaussian shape
    methods
        % this method returned the gaussian shaped object with central
        % intensity equal to maximal white value in 8-bit image ("255")
        function I = gshape(flObj)
            if ((flObj.shape=='g')||(strcmp(flObj.shape,'gaussian')))
            int16 sn; int16 n; int16 av;  int16 i; int16 j;
            double x; double y; double s1;
            sn = int16(flObj.s); n = 6*sn+1; av = 3*sn+1;
            I = zeros(n,n,'double'); s1=double(flObj.s);
            for i=1:1:n
                for j=1:1:n
                    x=i-av; 
                    y=j-av;
                    x=double(x); y=double(y);
                    I(i,j)=255*exp(-((x^2+y^2)/(2*s1^2)));
                end
            end
            I = uint8(I);
            end
        end    
    end
    
    %% linear (without acceleration) displacement between frames 
    % this method used also for connection the particles centers between
    % frames
    methods (Static) % method doesn't demand the sample of class "flObj"
        function lin=linear(x,y,angle,speed)
            lin=zeros(2,1,'double'); % returning modified coordinates (x,y)
            lin(1) = x+speed*cos(angle*pi/180); % x
            lin(1) = cast(lin(1),'uint16'); % round x
            lin(2) = y+speed*sin(angle*pi/180); % y
            lin(2) = cast(lin(2),'uint16'); % round y
        end
    end
    %% generation of cirle movement (rotation of objects)
    methods (Static)
        % generate movement of objects on some cirle with predefined radius
        function cir=circle(rad,angle) %cir = (x,y)
            cir=zeros(2,'double'); 
            cir(1) = rad*cos(angle*pi/180); % x
            cir(1) = cast(cir(1),'uint16'); % round x
            cir(2) = rad*sin(angle*pi/180); % y
            cir(2) = cast(cir(2),'uint16'); % round y
        end
    end
    %% generate curved trajectory
    methods
        %for generation it's assumed now that there exist two subpopulation of
        %particles; displacement value between two frames and angle of such
        %displacement are normally disturbed 
        function curvedXY= curved(flObj,init_angle,sigma_angles,mean_vel1,mean_vel2,disp_vel)
            curvedXY=zeros(3,1,'double'); % predefine the return values
            x=flObj.xc; y=flObj.yc; % get previous coordinates of object
            angle=normrnd(init_angle,sigma_angles); % get normally disturbed angle, 5 degree - dispersion
            if mod(flObj.id,2)==0
                meanV=mean_vel1;
            else meanV=mean_vel2;
            end
            if nargin == 5 % despersion of velocity predifend in this case
                displ=abs(normrnd(meanV,0.25*meanV)); % get normally disturbed displacement, 20% - dispersion from mean
                curvedXY=flObj.linear(x,y,angle,displ);
            else
                displ=abs(normrnd(meanV,disp_vel*meanV)); % get normally disturbed displacement, 20% - dispersion from mean
                curvedXY=flObj.linear(x,y,angle,displ);
            end
            curvedXY(3)=angle; 
        end
    end
    %% generate the halt event (e.g. in an actin-reach (?) region) - 
    % the dRmax limits the maximal displacement, angle and displacement
    % becomes quasi-random (using built-in function), 0<=angle<=359
    % degrees; 0<=dR(frame-to-frame)<=dRmax
    methods
        function halt = halt(flObj,dRmax)
            x=flObj.xc; y=flObj.yc; % get previous coordinates of object
            dx=rand*sqrt(dRmax); dy=rand*sqrt(dRmax); % get displacements along X and Y axis
            probe1=rand; probe2=rand; % two times create "heads and tails" probe for defyining the sign of displacements
            if probe1 <= 0.5 % defyining the sign of "X" displacement
                sign1=1; 
            else sign1=-1; 
            end
            if probe2 <= 0.5 % defyining the sign of "Y" displacement
                sign2=1;
            else sign2=-1;
            end
            flObj.xc=x+sign1*dx; flObj.yc=y+sign2*dy; % assign new coordinates for an object
            halt=flObj; % explicitly return modified sample of object because of object type
        end
    end
    %% object appearance event (with some threshold probability for each frame)
    methods (Static)
        function ap = appear(objects,thresholdV,picSize)
                if isa(objects(1),'flObj')&&(~isempty(objects)) % check the type of array class and array size
                    if rand<thresholdV
                        N=size(objects,1); % last index in objects array
                        sizeObj = objects(N).s; shapeObj=objects(N).shape; shapeObj=char(shapeObj);
                        addObj=flObj(sizeObj,shapeObj,1,1,1); % create new fluorescent object
                        addObj.id=objects(N).id+1; % enumeration of objects = giving them id
                        addObj.xc=randi(picSize); % "x" coordinate
                        addObj.yc=randi(picSize); % "y" coordinate
                        ap=cat(1,objects,addObj); % append to array created object
                    else ap=objects; % return input array containing objects if new one didn't appear
                    end
                else error('not proper input')
                end
        end
    end
    %% object disappearance (suddenly)
    methods (Static)
        function dis=disappear(objects,index,thresholdV)
            if isa(objects(1),'flObj')&&(~isempty(objects)) % check all conditions
                    if rand<thresholdV
                       objects(index)=[];
                       dis=objects;
                    else dis=objects; % return input array of object if current one didn't disappear
                    end
                else error('not proper input')
            end
        end
    end
    
end

