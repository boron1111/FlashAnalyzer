function [OverAllTraceClass,OverAllTraceTrace,normal]=OverAllTraceAnalysis(lsmdata,r,channel,thresh)
    OverAllTraceTrace=cell(1,channel);
    normal=cell(1,channel);
    OverAllTraceTrace1=zeros(1,r);
    im=lsmdata(1).data{1};
    ima=uint8(zeros(size(im)));    
    ima(im>250)=1; %����ֵ������
    

    
    
    for j=1:channel
        for i=1:r
            im=lsmdata(i).data{j};
            im(im<thresh)=0;%����ֵ������
            im(ima==1)=0; %����ֵ֮���ֵ����

% %             bw=im2bw(im,0.001);%��imshow(im>0)��Ч�����
%             imshow(im>0)
%             drawnow
%             pause(0.2)
            OverAllTraceTrace1(i)=mean(double(im(im>0)));%�����з���ĵ����ƽ��

        end

        normal1=OverAllTraceTrace1/OverAllTraceTrace1(1);
        OverAllTraceTrace{j}=OverAllTraceTrace1;
        normal{j}=normal1;
    end
    OverAllTraceClass=2;
    
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




