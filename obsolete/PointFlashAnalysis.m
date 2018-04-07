function [ind,pea,base,basepea,down,downpea,RiseTime,DownTime,hd,ha]=PointFlashAnalysis(signal,point,Time)
    hd=[];
    ha=[];
    r=length(signal);
    base=point.base;basepea=point.basepea;
    ind=point.ind;pea=point.pea;
    down=point.down;downpea=point.down;
    n1=base(1);n1p=basepea(1);
    n2=down(1);n2p=downpea(1);
    nn=ind(1);
    
%     if n1p<n2p
%         done=0;
%         n=0;
%         while(done==0)
%             done=(signal(nn-n)-n2p>=0&&signal(nn-n-1)-n2p<=0)||nn-n-1==1;
%             n=n+1;
%         end
%         RiseTime=n;
%         DownTime=n2-nn;
%     else
%         done=0;
%         n=0;
%         while(done==0)
%             done=(signal(nn+n)-n1p>=0&&signal(nn+n+1)-n1p<=0)||nn+n+1==r;
%             n=n+1;
%         end
%         RiseTime=nn-n1;
%         DownTime=n;
%     end
    RiseTime=Time(nn)-Time(n1);
    DownTime=Time(n2)-Time(nn);
    hal=(n1p+pea(1))/2;
    n=0;
    done=0;
    try
        while(done==0)
            done=(signal(nn-n)-hal>=0&&signal(nn-n-1)-hal<=0||nn-n==1);
            n=n+1;
        end
    catch
        n=nn-1;
    end
    n1=n;
    n=0;
    done=0;
    
    try
        while(done==0)
            done=(signal(nn+n)-hal>=0&&signal(nn+n+1)-hal<=0||nn+n==r);
            n=n+1;
        end
    catch
        n=r-nn;
    end
    hd=Time(nn+n-1)-Time(nn-n1);
    if nn+n<=r
%         hd=hd+n-1;
        ha=sum(signal(nn-n1:nn+n-1).*Time(nn-n1:nn+n-1));
    else
        hd=NaN;
        ha=NaN;
    end
end

