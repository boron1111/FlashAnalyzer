

function [ROIpoint,stabledata,count,flashsignal,signalpoint Rise Down DeltF_F0 Classf flg,FDHM,FAHM]=autoTotalff(lsmdata,r,thresh,channel,Time)

    im=lsmdata(1).data{1};
    imag=im;
    thresh=max(thresh-5,0);
%     thresh=30;
    im=medfilt2(im,[3,3]);
    im(im<thresh)=0;
    im=logical(im);
    im=bwmorph(im,'clean');
    [A,num]=bwlabel(im);
    STATS=regionprops(im,'Area');
    for i=1:num
        c=STATS(i).Area;
        if c<20
            im(A==i)=false;
        end
    end
    thresh
    figure(5)
    imshow(im)    
    count=0;
    Rise={};
    Down={};
    DeltF_F0={};
    stabledata={};
    Classf=[]; 
    ROIpoint={};
    flg=0;
    flashsignal={};
    signalpoint={};
    FDHM={};
    FAHM={};
    
    if max(max(im))
        
        B=bwboundaries(im,'noholes');
        for iij=1:length(B)
            boundary = B{iij};
            point.x=boundary(:,2);
            point.y=boundary(:,1);
            bw=roipoly(imag, point.x, point.y);
            num=length(find(bw));
            if num>10
                
                signal=cell(1,channel);
                for j=1:channel
                    signal1=zeros(1,r);
                    for i=1:r
                        ima=lsmdata(i).data{j};
                        ima=double(ima);
                        signal1(i)=mean(double(ima(bw==1)));
                    end
                    signal{j}=signal1;
                end
                s=signal{1};
                [ind,pea,base,basepea,down,downpea,RiseTime,DownTime,hd,ha]=traceAnalysis(signal{1},r,Time);

                s=sort(s);
                if 1
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
                            if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
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
                            if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
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
                            if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
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
                        flg(count)=0;
                        flashsignal{count}=signal;
                        signalpoint{count}=point;
                        stabledata{count,1}=num2str(count);  
                        FDHM{count}=[];
                        FAHM{count}=[];
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
                        flg(count)=0;
                        flashsignal{count}=signal;
                        signalpoint{count}=point;
                        stabledata{count,1}=num2str(count);  
                        FDHM{count}=[];
                        FAHM{count}=[];                        
                    end

                    
                end

            end
        end
    end
end