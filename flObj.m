classdef flObj
    % New class for generation of "fluorescent object" as a class
    
    %% list of parameters related to the object
    properties
        s; % obvious property - size
        shape; % type of an object shape
        xc; yc; % coordinates of a center
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
    methods (Static) % method doesn't demand the sample of class "flObj"
        function lin=linear(x,y,angle,speed)
            lin=zeros(2,'double'); % returning modified coordinates (x,y)
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
        function curvedXY= curved(flObj,init_angle,sigma_angles,mean_vel1,mean_vel2)
            curvedXY=zeros(3,'double'); %#ok<*PREALL> % returning modified coordinates (x,y) + angle (!) served later as mean
            x=flObj.xc; y=flObj.yc;
            if mod(flObj.id,2)==0
                meanV=mean_vel1;
            else meanV=mean_vel2;
            end
            displ=abs(normrnd(meanV,0.25*meanV)); % get normally disturbed displacement, 20% - dispersion from mean
            angle=normrnd(init_angle,sigma_angles); % get normally disturbed angle, 5 degree - dispersion
            curvedXY=flObj.linear(x,y,angle,displ);
            curvedXY(3)=angle;
        end
    end
    %% object appearance event (with some threshold probability for each frame)
    methods (Static)
        function ap = appear(objects,thresholdV,picSize)
                if isa(objects(1),'flObj')&&(~isempty(objects)) % check all conditions
                    if rand<thresholdV
                        N=size(objects,1); % last index in objects array
                        sizeObj = objects(N).s; shapeObj=objects(N).shape; shapeObj=char(shapeObj);
                        addObj=flObj(sizeObj,shapeObj,1,1,1); % create new fluorescent object
%                         angle=randi(361)-1; % initial angle of displacement counted from X axis
                        addObj.id=objects(N).id+1; % enumeration of objects = giving them id
                        addObj.xc=randi(picSize); % "x" coordinate
                        addObj.yc=randi(picSize); % "y" coordinate
                        ap=cat(1,objects,addObj); % append to array created object
                    else ap=objects; % return input array of object if new one didn't appear
                    end
                else error('not proper input')
                end
        end
    end
end

