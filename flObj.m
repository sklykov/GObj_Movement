classdef flObj < handle
    % New class for generation of "fluorescent object" as a class
    
    %% list of parameters related to the object
    properties
        s; % obvious property
        shape; % type of object shape
        xc; yc; % coordinates of center
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
    
    %% making a Gaussian shape
    methods
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
end

