function [OverAllTraceClass,OverAllTraceTrace,normal]=OverAllTraceAnalysisBefore(lsmdata)
   
    OverAllTraceTrace=zeros(1,r);
    im=lsmdata(1).data{1};
    ima=uint8(zeros(size(im)));    
    ima(im>250)=1; %����ֵ������
    
    for i=1:r
        im=lsmdata(i).data{1};
        im(im<20)=0;%����ֵ������
        im(ima==1)=0; %����ֵ֮���ֵ����
%         figure(1)
%         imshow(im)
%         bw=im2bw(im,0.001);��imshow(im>0)��Ч�����
%         imshow(im>0)
%         drawnow
%         pause(0.2)
        OverAllTraceTrace(i)=mean(double(im(im>0)));%�����з���ĵ����ƽ��
        
        
        
        
    end
    
    OverAllTraceClass=2;
    normal=OverAllTraceTrace/OverAllTraceTrace(1);
% ���²��ִ���Ϊnormalization����Ϊ���ܺܺõ�cover�������ݣ��ʶ�ȥ����2013-1-19    
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




