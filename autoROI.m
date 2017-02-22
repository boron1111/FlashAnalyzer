function [ROIpoint count flashsignal]=autoROI(meanIm,lsmdata,channelForAutoROI,...
    r,channel)
    % r是总帧数，channel是总通道数
level=graythresh(meanIm);
bw=im2bw(meanIm,level);
bw=bwareaopen(bw,15);
bw=imclose(bw,strel('square',3));
% figure;imshow(bw)
% title('全局阈值');

H=fspecial('average',20);
averaged=imfilter(meanIm,H);
% figure;imshow(averaged);
% title('局部平均');
% imcontrast

b=meanIm>averaged;
b=bwareaopen(b,20);
b=imclose(b,strel('square',3));
% b=b&~bw;
% figure;imshow(b)
% title('新增局部阈值')

bw=b|bw;
D=bwdist(~bw);
D=-D;

D(~bw)=-inf;
L=watershed(D);
% rgb = label2rgb(L,'jet',[.5 .5 .5]);
% imtool(rgb)
L(L==mode(double(L(:))))=0;
bw=L;
bw=bwareaopen(bw,20);

% figure;imshow(bw);
% title('综合')
% imcontrast

[L,n]=bwlabel(bw);
ROIpoint=cell(1,n);
ROIpoint_s.ind=[];
ROIpoint_s.pea=[];
ROIpoint_s.base=[];
ROIpoint_s.basepea=[];
ROIpoint_s.down=[];
ROIpoint_s.downpea=[];
for id=1:n
    bw1=L==id;
%     disp(id);
    pos=find(bw1==1,1);
    pos2=[mod(pos,size(bw1,1)) ceil(pos/size(bw1,1))];
    pos2(pos2==0)=size(bw1,1);
    boundaryv=bwtraceboundary(bw1,pos2,'e');
    ROIpoint_s.x=boundaryv(:,2)';
    ROIpoint_s.y=boundaryv(:,1)';
    ROIpoint{id}=ROIpoint_s;
end

count=n;
flashsignal=cell(1,n);

for id=1:n
    bw1=L==id;
    flashsignal{id}=cell(1,channel);
    for ch=1:channel
        flashsignal{id}{ch}=zeros(1,r);
        for f=1:r
            flashsignal{id}{ch}(f)=mean(double(lsmdata(f).data{ch}(bw1)));
        end
    end
end
