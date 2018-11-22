classdef GaussObj < handle
    % transfering of generation of Gaussian shape object to class
    
    properties
        s; % sigma in Gaussian distribution
    end
    %% constructor
    methods 
        function GObj = GaussObj(sigma)
            if (nargin == 1)&&(sigma>0)
                GObj.s = sigma;
            else warning('incorrect initiation of Gaussian shape object')
            end  
        end
    end
    %% gaussian shape object
    methods
        function I = shape(GObj)
            int16 sn; int16 n; int16 av;  int16 i; int16 j;
            double x; double y; double s1;
            sn = int16(GObj.s); n = 6*sn+1; av = 3*sn+1;
            I = zeros(n,n,'double'); s1=double(GObj.s);
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

