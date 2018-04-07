function [OverAllTraceClass,OverAllTraceTrace,normal]=OverAllTraceAnalysisBefore(lsmdata)
   
    OverAllTraceTrace=zeros(1,r);
    im=lsmdata(1).data{1};
    ima=uint8(zeros(size(im)));    
    ima(im>250)=1; %设阈值的上限
    
    for i=1:r
        im=lsmdata(i).data{1};
        im(im<20)=0;%设阈值的下限
        im(ima==1)=0; %将阈值之外的值归零
%         figure(1)
%         imshow(im)
%         bw=im2bw(im,0.001);与imshow(im>0)的效果差不多
%         imshow(im>0)
%         drawnow
%         pause(0.2)
        OverAllTraceTrace(i)=mean(double(im(im>0)));%对所有非零的点进行平均
        
        
        
        
    end
    
    OverAllTraceClass=2;
    normal=OverAllTraceTrace/OverAllTraceTrace(1);
% 以下部分代码为normalization。因为不能很好的cover所有数据，故而去掉。2013-1-19    
%     try 
%         Trace=emd(OverAllTraceTrace);
%         Trace=Trace(end,:);
%         OverAllTraceTrace=OverAllTraceTrace./Trace*Trace(1);
%         for i=1:r
%             im=lsm_image(:,:,i);
%             im=uint8(double(im)/Trace(i)*Trace(1));
%             lsm_image(:,:,i)=im;
%         end   
%     catch err        
%         err.identifier
%     end
%     [ind,~] = peakfinder(OverAllTraceTrace);
    
%     if isempty(ind)
%         OverAllTraceClass=1;
%         normal=[];
%     else
%         if ind(1)<3
%             ind(1)=[];
%         end
%         if isempty(ind)
%             OverAllTraceClass=1;
%             normal=[];
%         else
%             pea=OverAllTraceTrace(ind);
%             m=max(pea);
%             m=m(1);
%             in=find(OverAllTraceTrace==m);
%             mi=min(OverAllTraceTrace(max(1,in-20):in));
%             if (m-mi)/mi>0.03
%                 OverAllTraceClass=2;
%                 normal=(OverAllTraceTrace-mi)/mi;
%             else
%                 OverAllTraceClass=1;
%                 normal=[];
%             end
%         end
%     end
       
end




