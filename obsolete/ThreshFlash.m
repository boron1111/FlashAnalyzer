function b=ThreshFlash(si,r)
        [counts,x] = imhist(si);
        x=x(10:end);
        counts=counts(x-1);
        counts=mean5_3(counts,5);
        counts=mean5_3(counts,5);counts=mean5_3(counts,5);
        counts=(counts-min(counts))/(max(counts)-min(counts))*r;
        if counts(end)>0.01
            counts=(counts-counts(end))/counts(end);
            counts=counts/max(counts)*r;
        end
%         [spmax, spmin, flag]= extrema(counts);

        n=length(counts);
        [pea,ind] = findpeaks(counts,'MINPEAKDISTANCE',6,'THRESHOLD',0);
        pea(pea<30)=0;
        ind=ind(pea>0);
        ind=[1,ind];
        ind=sort(ind);
        n1=ind(end);
        done=0;
        while (done==0)
            n=n-1;
            if counts(n)>=25
                done=1;
            end
        end
        n=n-n1;
        thresh=(n1+10)*1.6+n*1.4;
        si(si<thresh)=0;
        b=logical(si);
end