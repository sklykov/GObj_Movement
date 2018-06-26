clc; close all; clear variables; 
% properties of objects
sigma=5; % define size of Gaussian shape object
picSize = 500; % define size of background picture
NumbObj=50;

coord = zeros(2*NumbObj,1,'uint16'); 
angles = zeros(NumbObj,1,'double');
for i=1:1:NumbObj
    coord(2*i-1)=randi(picSize);
    coord(2*i)=randi(picSize);
    angles(i)=randi(361)-1;
end
% creation sample of object
G1 = GaussObj(sigma); P1 = Picture(picSize); % generate samples of objects
% I1 = G1.shape; B1 = P1.blank; % methods gives the generated objects
BI1=0; 
for i=1:1:NumbObj
    PO1 = picWithObj2(P1,G1,coord(2*i-1),coord(2*i),BI1);
    BI1=PO1.fuse;
    PO(i)=PO1;
end
% imwrite(BI1,'1.png'); 
iter=1; 
% imshow(BI1);

speed=14;

% create movie
flag1=true; 
while flag1&&(iter<26)
    BI2=P1.blank; l=0;
    for i=1:1:NumbObj
        xCyC=PO(i).linear(angles(i),speed);
        coord(2*i-1)=xCyC(1); coord(2*i)=xCyC(2);
        PO(i) = picWithObj2(P1,G1,coord(2*i-1),coord(2*i),BI2);
        BI2=PO(i).fuse;
        c=PO(i).paint;
        if c{1}
            l=l+1;
        end
    end
    if l>0
        flag1=true;
        name=strcat(num2str(iter),'.png');
        imwrite(BI2,name);
    else flag1=false;
    end
    iter=iter+1;
end
