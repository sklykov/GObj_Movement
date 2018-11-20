% This file contains some hints for creation of histograms
clc; close all;   
filename='some_local_file.xls'; filename1='some_local_file2.xls'; % xls or csv
A = xlsread(filename); A1 = xlsread(filename1); 
[m,n]=size(A); [m1,n1]=size(A1); % number of columns and rows in matrix
B = zeros(1,m*n,'double'); l=ones(1,1,'uint16'); B1 = zeros(1,m1*n1,'double'); l1=ones(1,1,'uint16');
%% get rid of NaN values and transfer 2D array to 1D row
for i=1:1:m
    for j=1:1:n
        if ~isnan(A(i,j))
            if A(i,j)>0
                B(1,l)=A(i,j);
                l=l+1;
            end
        else break;
        end
    end    
end
[~,n]=size(B); B(:,l:n)=[]; % delete all zero numbers (put attention to ":" in rows) 
clear('A'); % release memory
for i=1:1:m1
    for j=1:1:n1
        if ~isnan(A1(i,j))
            if A1(i,j)>0
                B1(1,l1)=A1(i,j);
                l1=l1+1;
            end
        else break;
        end
    end    
end
[~,n1]=size(B1); B1(:,l1:n1)=[]; % delete all zero numbers (put attention to ":" in rows) 
clear('A1'); % release memory

%% histograms
%% 1
figure; set(0,'DefaultAxesFontSize',10,'DefaultAxesFontName','Times New Roman');
xlabel('V ({\mu}m/s)'); ylabel('Counts'); % assign proper names to labels
M=max(B); m=min(B); M1=max(B1); m1=min(B1);
m=0; M=2.6; steph=0.100001; % Absolute hint in Matlab for the step for histograms - ! 
hold on; 
xlim([m M]); ylim([0 450]); % label limitations in axis 
set(gca,'XTick',m:0.2:M); set(gca,'YTick', 0:50:450); % set to graph right ticks for axis
h=histogram(B, [m m:steph:M M]);  h2=histogram(B1, [m m:steph:M M]); % histogram with limits set above 
set(h2,'FaceColor','green'); set(h,'FaceColor','blue'); % set bars colors
legend('spmething','something2'); set(gca,'LineWidth',0.5); % LineWidth of axis! 
hold off; 
p=gcf; % get handler to current figure
set(p,'Units','centimeters'); set(p,'PaperUnits','centimeters'); 
set(p,'PaperSize',[10 8.4]); % size of puctire in centimeters (?? - necessity)
set(p,'PaperPositionMode','manual'); set(p,'Resize','on'); 
set(p,'PaperPosition',[0 0 10 8.4]); % ? - necessity - maybe will be updated
pos=get(gca,'Position'); set(gca,'Position',[pos(1)+0.015 pos(2)+0.03 pos(3)-0.015 pos(4)-0.03]); % for tick label positioning
print('test1','-dtiffn','-r300'); print('test2','-depsc','-r600'); % save file in local directory
print('test3','-dpng','-r600'); print('test4','-dsvg','-r600'); % save file in local directory