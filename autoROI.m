function [ROIpoint count flashsignal]=autoROI(meanIm,lsmdata,...
    r,channel,channels_analyze)
    % r是总帧数，channel是总通道数
% tic

wb=waitbar(0);

H=fspecial('average',20);
averaged=imfilter(meanIm,H);

bw=meanIm>averaged;
bw=bwareaopen(bw,20);
bw=imclose(bw,strel('square',3));

D=bwdist(~bw);
D=-D;

D(~bw)=-inf;
L=watershed(D);

L(L==mode(double(L(:))))=0;
bw=L;
bw=bwareaopen(bw,20);

[L,n]=bwlabel(bw);
ROIpoint=cell(1,n);
ROIpoint_s.ind=[];
ROIpoint_s.pea=[];
ROIpoint_s.base=[];
ROIpoint_s.basepea=[];
ROIpoint_s.down=[];
ROIpoint_s.downpea=[];

imCalMean=cell(1,n);

total=2*r*n;
count=0;
for id=1:n
    bw1=L==id;
%     disp(id);
    pos=find(bw1==1,1);
    pos2=[mod(pos,size(bw1,1)) ceil(pos/size(bw1,1))];
    pos2(pos2==0)=size(bw1,1);
    try
        boundaryv=bwtraceboundary(bw1,pos2,'se');
    catch e
%         disp(e.message)
%         disp(id);
    end
    ROIpoint_s.x=boundaryv(:,2)';
    ROIpoint_s.y=boundaryv(:,1)';
    ROIpoint{id}=ROIpoint_s;
    
    imCalMean{id}=ones(channel,r,sum(bw1(:)))*100;
    for id1=1:r
        for id2=sort(channels_analyze)
            imCalMean{id}(id2,id1,:)=lsmdata(id1).data{id2}(bw1);
        end
    end
    count=count+2*r;
    waitbar(count/total,wb)
end

% toc

count=n;
flashsignal=cell(1,n);

% for id=1:n
%     bw1=L==id;
%     flashsignal{id}=cell(1,channel);
%     for ch=1:channel
%         flashsignal{id}{ch}=zeros(1,r);
%         for f=1:r
%             flashsignal{id}{ch}(f)=mean(double(lsmdata(f).data{ch}(bw1)));
% %             toc
%         end
%     end
% end

for id=1:n
    tmp=mean(imCalMean{id},3);
    tmp=num2cell(tmp,2);
    flashsignal{id}=tmp';
end

delete(wb)
%使用矩阵一次计算多个mean比只计算一个mean只节省了1s，对于100帧，要40多秒
% toc