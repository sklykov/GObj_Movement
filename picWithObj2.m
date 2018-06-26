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
        function PicObj = picWithObj2(B,Obj,x,y,pIn)
            PicObj.background = B; % should be class "Picture"
            PicObj.object = Obj; % should be class "GaussObj"
            PicObj.xC = int16(x); PicObj.yC = int16(y); % round the coordinate of object center
            PicObj.picIN = pIn;
        end
    end
    
    methods
        % check the ability to paint object (center of object lays inside
        % the picture borders)
        %% 
        function PaintObj = paint(PicObj)
            PaintObj = {};
            %% variables definition and assignment
            xc=PicObj.xC; yc=PicObj.yC;
            sizeP=PicObj.background.N; sizeP=int16(sizeP);
            I1=PicObj.object.shape;
            %% set limits to pixel values
            xAv=(max(size(I1))-1)/2; yAv=xAv; yAv=int16(yAv); xAv=int16(xAv); % background - square
            if (xc>=xAv)&&(xc<=sizeP-xAv)
                xmin=xc-xAv; xmax=xc+xAv;
%             elseif (xc>=1)&&(xc<xAv)
%                 xmin=1; xmax=xAv-xc;
%             elseif (xc<=sizeP)&&(xc>sizeP-xAv)
%                 xmin=xc-xAv-sizeP; xmax=sizeP;
            else
                xmin=-1; xmax=0;
            end
            if (yc>=yAv)&&(yc<=sizeP-yAv)
                ymin=yc-yAv; ymax=yc+yAv;
%             elseif (yc>=1)&&(yc<yAv)
%                 ymin=1; ymax=yAv-yc;
%             elseif (yc<=sizeP)&&(yc>sizeP-yAv)
%                 ymin=yc-yAv-sizeP; ymax=sizeP;
            else
                ymin=-1; ymax=0;
            end
            if (xmax>0)&&(ymax>0)&&(xmin>0)&&(ymin>0)
                PaintObj{1} = true;
            else PaintObj{1} = false;
            end
            %% assign values to tranfer them to other method
            PaintObj{2}=xmin; PaintObj{3}=xmax; PaintObj{4}=ymin; PaintObj{5}=ymax; 
            PaintObj{6}=xAv; PaintObj{7}=yAv; PaintObj{8}=xc; PaintObj{9}=yc;
        end
    end
    
    methods
        % fuse object in background after checking if it lays inside the
        % picture borders)
        %%
        function BObj=fuse(PicObj)
            I1=PicObj.object.shape;
            %% checking the iteration step
            if max(size(PicObj.picIN))~=max(size(PicObj.background.blank)) 
                BObj=PicObj.background.blank;
            else BObj=PicObj.picIN;
            end
            %% assign pixel value
            vals = PicObj.paint; % all vals indexed below are assigned above, maybe not optimal solution
            if vals{1}
                for i1=vals{2}:1:vals{3}
                    for j1=vals{4}:1:vals{5}
                        xObj=i1+(vals{6}-vals{8})+1;
                        yObj=j1+(vals{7}-vals{9})+1;
                        if BObj(i1,j1)<255
                            BObj(i1,j1)=BObj(i1,j1)+I1(xObj,yObj);
                        end
                    end
                end
            end 
            BObj=cast(BObj,'uint8');
        end
    end
    
    methods
        % move particle further linear, return center coordinates
        %%
        function lin=linear(PicObj,angle,speed)
            lin=zeros(2,'double');
            lin(1) = PicObj.xC+speed*cos(angle*pi/180);
            lin(1) = cast(lin(1),'uint16');
            lin(2) = PicObj.yC+speed*sin(angle*pi/180);
            lin(2) = cast(lin(2),'uint16');
        end
    end
    
end

