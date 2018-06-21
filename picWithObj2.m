classdef picWithObj2 < handle
    % fuse objects with picture
    properties
        background; % background picture as array
        object; % gaussian or other shape object
        xC; yC; % coordinates of center point 
        picIN; % for making iterations
    end
    
    methods
        % constructor (all conditions)
        function PicObj = picWithObj(B,Obj,x,y,pIn)
            PicObj.background = B; % should be class "Picture"
            PicObj.object = Obj; % should be class "GaussObj"
            PicObj.xC = int16(x); PicObj.yC = int16(y); % round the coordinate of object center
            PicObj.picIN = pIn;
        end
    end
    
    methods
        % fuse object in background
        function BObj=fuse(PicObj)
            %% variables definition and assignment
            int16 sizeP; int16 xAv; int16 yAv; int16 i1; int16 j1;
            int16 xc; int16 yc; int16 xObj;
            int16 xmin; int16 yimn; int16 xmax; int16 ymax;
            xc=PicObj.xC; yc=PicObj.yC;
            sizeP=PicObj.background.N; sizeP=int16(sizeP);
            I1=PicObj.object.shape;
            %% checking the iteration step
            if max(size(PicObj.picIN))~=max(size(PicObj.background.blank)) 
                BObj=PicObj.background.blank;
            else BObj=PicObj.picIN;
            end
            %% fuse object depending the coordinates of object center
            xAv=(max(size(I1))-1)/2; yAv=xAv; yAv=int16(yAv); xAv=int16(xAv); % background - square
            
            if (xc>xAv)&&(xc<sizeP)
                xmin=xc-xAv;
            else xmin=-1;
            end
            if (yc>yAv)&&(yc<sizeP)
                ymin=yc-yAv;
            else ymin=-1;
            end
            if xc<sizeP-xAv
                xmax=xc+xAv;
            else xmax=0;
            end
            if yc<sizeP-xAv
                ymax=yc+yAv;
            else ymax=0;
            end
            
            if (xmax>0)&&(ymax>0)&&(xmin>0)&&(ymin>0)
                for i1=xmin:1:xmax
                    for j1=ymin:1:ymax
                        xObj=i1+(xAv-xc)+1;
                        yObj=j1+(yAv-yc)+1;
                        if BObj(i1,j1)<255
                            BObj(i1,j1)=BObj(i1,j1)+I1(xObj,yObj);
                        end
                    end
                end
            end
            
            BObj=cast(BObj,'uint8');
        end
    end
end

