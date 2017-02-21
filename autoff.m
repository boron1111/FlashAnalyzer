%autodetection
function [ROIpoint,stabledata,count,flashsignal,signalpoint Rise Down DeltF_F0 Classf flg]=autoff(ROIpoint,stabledata,lsm_image,r,row,col,count,flashsignal)
    
%     hw=waitbar(0,'Auto detection is in progress,please wait...','Name','Auto detection','CreateCancelBtn',...
%         'setappdata(gcbf,''canceling'',1)','WindowStyle','modal');
%     SetIcon(hw);
%     for i=1:r
%         imag=lsm_image(:,:,i);
%         imag=medfilt2(imag,[3,3]);
%         lsm_image(:,:,i)=imag;
%     end
    
%     steps=(ceil(row/128)-1)*(ceil(col/32)-1);
    
    for ij=1:ceil(row/128)-1
        for ji=1:ceil(col/128)-1
%             if getappdata(hw,'canceling')
%                 delete(hw)
% 
%                 count=0;
%                 ROIpoint={};
%                 
%                 stabledata={};
%                 flashsignal=[];% will delete in the future
%                 signalpoint={};
%                 Rise={};
%                 Down={};
%                 DeltF_F0={};
%                 Classf=[];
%                 flg=[];
%                 
%                 break
%             end
            sig=zeros(r,256*256);
            for i=1:r
                disp('autoff im')
                lsm_image(:,:,i)
                im=double(lsm_image(:,:,i));
                
                im=im(1+128*(ij-1):256+128*(ij-1),1+128*(ji-1):256+128*(ji-1));
                sig(i,:)=im(:);
            end
            
            icasig =fastica(sig,'numOfIC',5,'approach', 'symm','g','skew','interactivePCA','off','firstEig',1,'lastEig',round(r)/2,'displayMode', 'off','verbose','off','epsilon' ,0.00001);
            
            for jjjj=1:size(icasig,1)
                si=icasig(jjjj,:);
                si=reshape(si,[256,256]);
                si=abs(si);
                si=floor(mat2gray(si)*255);
                si=uint8(si);
                si=medfilt2(si);
                b=ThreshFlash(si,r);
                b=bwmorph(b,'clean');
                [A,num]=bwlabel(b);
                STATS=regionprops(b,'Area');
                for i=1:num
                    c=STATS(i).Area;
                    if c<25
                        b(A==i)=false;
                    end
                end
                b=bwmorph(b,'close');
                si=logical(b);
                si=bwmorph(si,'clean');
                si=uint8(si)*255;
                % si=bwmorph(si,'close');
                SE=strel('line',3,15);
                si=imdilate(si,SE);
                si=imerode(si,SE);
                si=logical(si);
                [A,num]=bwlabel(si);
                STATS=regionprops(si,'Area');
                for i=1:num
                    c=STATS(i).Area;
                    if c<25
                        si(A==i)=false;
                    end
                end
                sssum=uint8(zeros(row,col));
                sssum(1+128*(ij-1):256+128*(ij-1),1+128*(ji-1):256+128*(ji-1))=sssum(1+128*(ij-1):256+128*(ij-1),1+128*(ji-1):256+128*(ji-1))+uint8(si);
                sssum=logical(sssum);
                if max(max(sssum))
                    B=bwboundaries(sssum,'noholes');
                    imag=lsm_image(:,:,1);
                    for iij=1:length(B)
                        boundary = B{iij};
                        point.x=boundary(:,2);
                        point.y=boundary(:,1);
                        bw=roipoly(imag, point.x, point.y);
                        num=length(find(bw));
                        if num>10
                            s=zeros(1,r);
                            for jj=1:r
                                ima=lsm_image(:,:,jj);
                                s(jj)=mean(double(ima(bw==1)));
                            end
                            [ind,pea,base,basepea,down,downpea,RiseTime,DownTime]=traceAnalysisAuto(s,r);
                            signal=s;
                            s=sort(s);
                            if ~isempty(ind)&&length(ind)<6&&mean(s(1:10))>5&&~isempty(find(s>(mean(s)+1.3*std(s))))&&max(s)>35
                                count=count+1;
                                ROIpoint{count}=point;
                                point=[];
                                if ~isempty(ind)
                                    Rise{count}=ind-base+1;
                                    Down{count}=down-ind+1;
                                    stabledata{count,2}=num2str(ind-base+1);
                                    str=[];
                                    for i=1:length(ind)
                                        str=[str,num2str((pea(i)-basepea(i))/basepea(i))];
                                    end
                                    stabledata{count,3}=str;
                                    stabledata{count,4}=num2str(down-ind+1);
                                    stabledata{count,6}=[];
                                    point.ind=ind;
                                    point.pea=pea;
                                    point.base=base;
                                    point.basepea=basepea;
                                    point.down=down;
                                    point.downpea=downpea;
                                    DeltF_F0{count}=(pea-basepea)./basepea;
                                    if RiseTime-DownTime>1
                                        if (pea(1)-signal(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
                                            if length(ind)==1
                                                Classf(count)=111;
                                                stabledata{count,5}=111;
                                            else
                                                Classf(count)=112;
                                                stabledata{count,5}=112;
                                            end
                                        else
                                            if length(ind)==1
                                                Classf(count)=121;
                                                stabledata{count,5}=121;
                                            else
                                                Classf(count)=122;
                                                stabledata{count,5}=121;
                                            end                                            
                                        end
                                    elseif DownTime-RiseTime>1
                                        if (pea(1)-signal(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
                                            if length(ind)==1
                                                Classf(count)=211;
                                                stabledata{count,5}=211;
                                            else
                                                Classf(count)=212;
                                                stabledata{count,5}=212;
                                            end
                                        else
                                            if length(ind)==1
                                                Classf(count)=221;
                                                stabledata{count,5}=221;
                                            else
                                                Classf(count)=222;
                                                stabledata{count,5}=222;
                                            end                                            
                                        end                                        
                                    else
                                        if (pea(1)-signal(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
                                            if length(ind)==1
                                                Classf(count)=311;
                                                stabledata{count,5}=311;
                                            else
                                                Classf(count)=312;
                                                stabledata{count,5}=312;
                                            end
                                        else
                                            if length(ind)==1
                                                Classf(count)=321;
                                                stabledata{count,5}=321;
                                            else
                                                Classf(count)=322;
                                                stabledata{count,5}=322;
                                            end                                            
                                        end                                         
                                    end
                                else
                                    point.ind=[];
                                    point.pea=[];
                                    point.base=[];
                                    point.basepea=[];
                                    point.down=[];
                                    point.downpea=[];
                                    Rise{count}=[];
                                    Down{count}=[];
                                    DeltF_F0{count}=[];
                                    stabledata{count,2}=[];
                                    stabledata{count,3}=[];
                                    stabledata{count,4}=[];
                                    stabledata{count,5}=[];
                                    stabledata{count,6}=[];
                                    Classf(count)=0;
                                end
                                flg(count)=0;
                                flashsignal=[flashsignal;signal];
                                signalpoint{count}=point;
                                stabledata{count,1}=num2str(count);
                            end
                        end
                    end
                end
%                 sssum(1+128*(ij-1):256+128*(ij-1),1+128*(ji-1):256+128*(ji-1))=sssum(1+128*(ij-1):256+128*(ij-1),1+128*(ji-1):256+128*(ji-1))+uint8(si);
            end
%             waitbar((ji+3*(ij-1)) / steps*(0.5),hw);
        end 
    end
    if count>0
        ROIpointCopy=ROIpoint;
        flashsignalCopy=flashsignal;
        tag=ones(1,count);
        for i=1:count
%             if getappdata(hw,'canceling')
%                 delete(hw)
%                 count=0;
%                 ROIpoint={};
% 
%                 stabledata={};
%                 flashsignal=[];% will delete in the future
%                 signalpoint={};
%                 Rise={};
%                 Down={};
%                 DeltF_F0={};
%                 Classf=[];
%                 flg=[];
% 
%                 break
%             end
            a=ROIpointCopy{i};
            for j=1:count
                if i~=j
                    b=ROIpoint{j};
                    IN=inpolygon(a.x,a.y,b.x,b.y);
                    s1=flashsignalCopy(i,:);
                    s2=flashsignal(j,:);
                    p=corrcoef(s1,s2);
                    done1=0;
                    if length(find(IN==1))/length(a.x)>0.5
                        done1=1;
                    end
                    done2=0;
                    if p(1,2)>0.80
                        done2=1;
                    end
                    if (done1)&&(done2)
                        tag(j)=0;
                    end
                end
            end 
%             waitbar(0.5+i / count*0.5);
        end
        
%         if ishandle(hw)
            flashsignal=flashsignal(tag==1,:);
            ROIpoint=ROIpoint(tag==1);
            stabledata=stabledata(tag==1,:);
            signalpoint=signalpoint(tag==1);
            Rise=Rise(tag==1);
            Down=Down(tag==1);
            DeltF_F0=DeltF_F0(tag==1);
            Classf=Classf(tag==1);
            flg=flg(tag==1);
            count=count-length(find(tag==0));
            for i=1:count
               stabledata{i,1}=num2str(i); 
            end
            
%             delete(hw);
            
%         end
    end
    clear a b i j point bw1 bw2 p n1 n2 half s1 s2 s point3 point2 point1  Rstr F0str Peakstr Deltstr                  
    clear done1 done2 a1 a2  si done current rise risea
    
end

