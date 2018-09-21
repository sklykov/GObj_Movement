classdef picWithObj4
    % fuse objects with background picture
    %% list of parameters
    properties
        background; % background picture as array
        object; % gaussian or other shape object
        picIN; % for making iterations
    end
    
    %% constructor 
    methods
        % constructor demands background picture (for 1st fuse iteration
        % and access to the picture size
        function PicObj = picWithObj4(B,Obj,pIn)
            PicObj.background = B; % should be class "Picture"
            PicObj.object = Obj; % should be class "flObj"
            PicObj.picIN = pIn; % array = real picture
        end
    end
    
    %% paint method = define is the object able to be "painted"
    methods
        % check the ability to paint object (center of object lays inside
        % the picture borders)
        function PaintObj = paint(PicObj)
            PaintObj = {}; % structure array - array of any data type elements
            %% variables definition and assignment
            xc=int16(PicObj.object.xc); yc=int16(PicObj.object.yc);
            sizeP=PicObj.background.N; sizeP=int16(sizeP); % size of background => size of picture
            I1=PicObj.object.gshape; % gaussian shape of object itself (for fusing into generated picture)
            %% set limits to pixel values
            xAv=(max(size(I1))-1)/2; % half of the object representation picture (gaussian shape)
            yAv=xAv; yAv=int16(yAv); xAv=int16(xAv); % background - square (assumed)
            if (xc>=xAv)&&(xc<=sizeP-xAv) % this condition guarantees that object doesn't
                %touch the border of the picture (background)
                xmin=xc-xAv; xmax=xc+xAv; % limits for assigning pixel values
            else
                xmin=-1; xmax=0;
            end
            if (yc>=yAv)&&(yc<=sizeP-yAv) % same condition for y coordinate
                ymin=yc-yAv; ymax=yc+yAv;
            else
                ymin=-1; ymax=0;
            end
            if (xmax>0)&&(ymax>0)&&(xmin>0)&&(ymin>0) % return flag that object could be fused into pic
                PaintObj{1} = true; % flag is painting the object possible
            else PaintObj{1} = false; % or not
            end
            %% assign values to tranfer them to other method
            % maybe not optimal variant of coupling the methods but it's
            % working
            PaintObj{2}=xmin; PaintObj{3}=xmax; PaintObj{4}=ymin; PaintObj{5}=ymax; 
            PaintObj{6}=xAv; PaintObj{7}=yAv; PaintObj{8}=xc; PaintObj{9}=yc;
        end
    end
    
    %% fuse object in picture method
    methods
        % fuse object in background after checking if it lays inside the
        % picture borders
        function BObj=fuse(PicObj) % BObj = physical picture 
            I1=PicObj.object.gshape; % gaussian object itself (generation) 
            %% checking the iteration step
            if max(size(PicObj.picIN))~=max(size(PicObj.background.blank)) 
                BObj=PicObj.background.blank; % initialize picture if the enter pic is empty
            else BObj=PicObj.picIN; % enter pic - the aim for object fusing
            end
            %% assign pixel value
            vals = PicObj.paint; % all vals indexed below are assigned above, maybe not optimal solution
            if vals{1} % this condition means that fusing possible for object with entered coordinates
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
    
end

