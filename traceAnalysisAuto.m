function [ind,pea,base,basepea,down,downpea,RiseTime,DownTime]=traceAnalysisAuto(sss,r)
    % find peak and the index of peak
    signal=mean5_3(sss,3);
    [ind,pea] = peakfinder(signal);
    
    if ~isempty(ind)
        
        [spmax, spmin, ~]= extrema(signal);
        
        if ~isempty(spmax)
            b1=spmin(:,1);
            b1(1)=[];b1(end)=[];
            l=length(ind);
            
            base=zeros(1,length(ind));basepea=zeros(1,length(ind));
            % is there is only one peak on the trace
            if l==1
                if ind<16
                    bb=b1(b1<ind);
                    if ~isempty(bb)
                        if length(bb)==1
                            base=bb;basepea=signal(base);
                        else
                            done=0;
                            ll=length(bb);
                            if ll==2
                                while(done==0)
                                    ddd=0;
                                    if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                        ddd=1;
                                    end
                                    done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ll==2||ddd);
                                    ll=ll-1;
                                end
                            else
                                while(done==0)
                                    ddd=0;
                                    if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                        ddd=1;
                                    end
                                    done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ll==2||ddd||signal(bb(ll))<signal(bb(ll-1))&&signal(bb(ll))<signal(bb(ll-2)));
                                    ll=ll-1;
                                end
                            end
                            base=bb(ll+1);basepea=signal(base);
                        end
                    else
                        mi=find(signal(1:ind)==min(signal(1:ind)));
                        base=mi(1);basepea=signal(base);
                    end
                else
                    bb=b1(b1<ind);
                    bb=bb(bb>ind-15);
                    if ~isempty(bb)
                        if length(bb)==1
                            base=bb;basepea=signal(base);
                        else
                            done=0;
                            ll=length(bb);
                            if ll==2
                                while(done==0)
                                    ddd=0;
                                    if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                        ddd=1;
                                    end                                    
                                    done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ddd||ll==2);
                                    ll=ll-1;
                                end
                            else
                                while(done==0)
                                    ddd=0;
                                    if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                        ddd=1;
                                    end                                    
                                    done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ll==2||ddd||signal(bb(ll))<signal(bb(ll-1))&&signal(bb(ll))<signal(bb(ll-2)));
                                    ll=ll-1;
                                end
                            end
                            base=bb(ll+1);basepea=signal(base);
                        end
                    else
                        mi=find(signal(ind-15:ind)==min(signal(ind-15:ind)));
                        base=mi(1)+ind-15;basepea=signal(base);
                    end
                end
            elseif l>1
                if ind(1)<16
                    bb=b1(b1<ind(1));
                    if ~isempty(bb)
                        if length(bb)==1
                            base(1)=bb;
                        else
                            done=0;
                            ll=length(bb);
                            if ll==2
                                while(done==0)
                                    ddd=0;
                                    if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                        ddd=1;
                                    end                                    
                                    done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ddd||ll==2);
                                    ll=ll-1;
                                end
                            else
                                while(done==0)
                                    ddd=0;
                                    if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                        ddd=1;
                                    end                                    
                                    done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ll==2||ddd||signal(bb(ll))<signal(bb(ll-1))&&signal(bb(ll))<signal(bb(ll-2)));
                                    ll=ll-1;
                                end
                            end
                            base(1)=bb(ll+1);
                        end
                    else
                        mi=find(signal(1:ind(1))==min(signal(1:ind(1))));
                        base(1)=mi(1);
                    end
                else
                    bb=b1(b1<ind(1));
                    bb=bb(bb>ind(1)-15);
                    if ~isempty(bb)
                        if length(bb)==1
                            base(1)=bb;
                        else
                            done=0;
                            ll=length(bb);
                            if ll==2
                                while(done==0)
                                    ddd=0;
                                    if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                        ddd=1;
                                    end                                    
                                    done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ddd||ll==2);
                                    ll=ll-1;
                                end
                            else
                                while(done==0)
                                    ddd=0;
                                    if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                        ddd=1;
                                    end                                    
                                    done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ll==2||ddd||signal(bb(ll))<signal(bb(ll-1))&&signal(bb(ll))<signal(bb(ll-2)));
                                    ll=ll-1;
                                end
                            end
                            base(1)=bb(ll+1);
                        end
                    else
                        mi=find(signal(ind(1)-15:ind(1))==min(signal(ind(1)-15:ind(1))));
                        base(1)=mi(1)+ind(1)-15;
                    end
                end                


                for i=2:l
                    if ind(i)<16
                        bb=b1(b1<ind(i));
                        bb=bb(bb>ind(i-1));
                        if ~isempty(bb)
                            if length(bb)==1
                                base(i)=bb;
                            else
                                done=0;
                                ll=length(bb);
                                if ll==2
                                    while(done==0)
                                        ddd=0;
                                        if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                            ddd=1;
                                        end
                                        done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ddd||ll==2);
                                        ll=ll-1;
                                    end
                                else
                                    while(done==0)
                                        ddd=0;
                                        if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                            ddd=1;
                                        end
                                        done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ll==2||ddd||signal(bb(ll))<signal(bb(ll-1))&&signal(bb(ll))<signal(bb(ll-2)));
                                        ll=ll-1;
                                    end
                                end
                                base(i)=bb(ll+1);
                            end
                        else
                            mi=find(signal(1:ind(i))==min(signal(1:ind(i))));
                            base(i)=mi(1);
                        end
                    else
                        if ind(i-1)>ind(i)-15
                            bb=b1(b1<ind(i));
                            bb=bb(bb>ind(i-1));
                            if ~isempty(bb)
                                if length(bb)==1
                                    base(i)=bb;
                                else
                                    done=0;
                                    ll=length(bb);
                                    if ll==2
                                        while(done==0)
                                            ddd=0;
                                            if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                                ddd=1;
                                            end
                                            done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ddd||ll==2);
                                            ll=ll-1;
                                        end
                                    else
                                        while(done==0) 
                                            ddd=0;
                                            if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                                ddd=1;
                                            end
                                            done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ddd||ll==2||signal(bb(ll))<signal(bb(ll-1))&&signal(bb(ll))<signal(bb(ll-2)));
                                            ll=ll-1;
                                        end                                        
                                    end
                                    base(i)=bb(ll+1);
                                end
                            else
                                mi=find(signal(ind(i-1):ind(i))==min(signal(ind(i-1):ind(i))));
                                base(i)=mi(1)+ind(i-1);
                            end
                        else
                            bb=b1(b1<ind(i));
                            bb=bb(bb>ind(i)-15);
                            if ~isempty(bb)
                                if length(bb)==1
                                    base(i)=bb;
                                else
                                    done=0;
                                    ll=length(bb);
                                    if ll==2
                                        while(done==0)
                                            ddd=0;
                                            if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                                ddd=1;
                                            end
                                            done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ddd||ll==2);
                                            ll=ll-1;
                                        end
                                    else
                                        while(done==0)  
                                            ddd=0;
                                            if max(signal(bb(ll-1):bb(ll)))-signal(bb(ll))>abs(signal(bb(ll))-signal(bb(ll-1)))
                                                ddd=1;
                                            end
                                            done=(abs(signal(bb(ll))-signal(bb(ll-1)))/signal(bb(ll))<0.015||ll==2||ddd||signal(bb(ll))<signal(bb(ll-1))&&signal(bb(ll))<signal(bb(ll-2)));
                                            ll=ll-1;
                                        end
                                    end
                                    base(i)=bb(ll+1);
                                end
                            else
                                mi=find(signal(ind(i)-15:ind(i))==min(signal(ind(i)-15:ind(i))));
                                base(i)=mi(1)+ind(i)-15;
                            end                            
                        end
                        
                    end
                end
                basepea=signal(base);
            end
            
            for i=1:length(ind)
                if ind(i)-base(i)<1
                    ind(i)=0;
                    pea(i)=0;
                    base(i)=0;
                    basepea(i)=0;
                end
                if basepea(i)~=0&&(pea(i)-basepea(i))/basepea(i)<0.2
                    ind(i)=0;
                    pea(i)=0;
                    base(i)=0;
                    basepea(i)=0;                    
                end
            end
            
            ind(ind==0)=[];
            pea(pea==0)=[];
            base(base==0)=[];
            basepea(basepea==0)=[];
            l=length(ind);
            
            if l>0
                down=zeros(1,l);downpea=zeros(1,l);            
                if l==1
                    if ind>r-15
                        bb=b1(b1>ind);
                        if ~isempty(bb)
                            if length(bb)==1
                                down=bb;downpea=signal(down);
                            else
                                done=0;
                                ll=length(bb);
                                coun=1;
                                if ll==2
                                    while(done==0)
                                        done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.02||coun+1==ll);
                                        coun=coun+1;
                                    end
                                else
                                    while(done==0)
                                        done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.02||coun+2==ll||signal(bb(coun))<signal(bb(coun+1))&&signal(bb(coun))<signal(bb(coun+2)));
                                        coun=coun+1;
                                    end
                                end
                                down=bb(coun-1);downpea=signal(down);
                            end
                        else
                            mi=find(signal(ind:end)==min(signal(ind:end)));
                            down=mi(1)+ind-1;
                            downpea=signal(down);
                        end
                    else

                        bb=b1(b1>ind);
                        bb=bb(bb<=ind+15);
                        if ~isempty(bb)
                            if length(bb)==1
                                down=bb;downpea=signal(down);
                            else
                                done=0;
                                ll=length(bb);
                                coun=1;
                                if ll==2
                                    while(done==0)
                                        done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.2||coun+1==ll);
                                        coun=coun+1;
                                    end
                                else
                                    while(done==0)
                                        done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.2||coun+2==ll||signal(bb(coun))<signal(bb(coun+1))&&signal(bb(coun))<signal(bb(coun+2)));
                                        coun=coun+1;
                                    end
                                end
                                down=bb(coun-1);downpea=signal(down);
                            end
                        else
                            mi=find(signal(ind:ind+15)==min(signal(ind:ind+15)));
                            down=mi(1)+ind-1;
                            downpea=signal(down);
                        end                    

                    end

                elseif l>1
                    if ind(l)>r-15
                        bb=b1(b1>ind(l));
                        if ~isempty(bb)
                            if length(bb)==1
                                down(l)=bb;downpea(l)=signal(down(l));
                            else
                                done=0;
                                ll=length(bb);
                                coun=1;
                                if ll==2
                                    while(done==0)
                                        done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.2||coun+1==ll);
                                        coun=coun+1;
                                    end
                                else
                                    while(done==0)
                                        done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.2||coun+2==ll||signal(bb(coun))<signal(bb(coun+1))&&signal(bb(coun))<signal(bb(coun+2)));
                                        coun=coun+1;
                                    end
                                end
                                down(l)=bb(coun-1);downpea(l)=signal(down(l));
                            end
                        else
                            mi=find(signal(ind(l):end)==min(signal(ind(l):end)));
                            down(l)=mi(1)+ind(l)-1;
                            downpea(l)=signal(down(l));
                        end   
                    else
                        bb=b1(b1>ind(l));
                        bb=bb(bb<=ind(l)+15);
                        if ~isempty(bb)
                            if length(bb)==1
                                down(l)=bb;downpea(l)=signal(down(l));
                            else
                                done=0;
                                ll=length(bb);
                                coun=1;
                                if ll==2
                                    while(done==0)
                                        done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.02||coun+1==ll);
                                        coun=coun+1;
                                    end
                                else
                                    while(done==0)
                                        done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.2||coun+2==ll||signal(bb(coun))<signal(bb(coun+1))&&signal(bb(coun))<signal(bb(coun+2)));
                                        coun=coun+1;
                                    end
                                end
                                down(l)=bb(coun-1);downpea(l)=signal(down(l));
                            end
                        else
                            mi=find(signal(ind(l):ind(l)+15)==min(signal(ind(l):ind(l)+15)));
                            down(l)=mi(1)+ind(l)-1;
                            downpea(l)=signal(down(l));
                        end                     
                    end

                    for i=1:l-1
                        if ind(i)>r-15
                            bb=b1(b1>ind(i));
                            if ~isempty(bb)
                                if length(bb)==1
                                    down(i)=bb;downpea(i)=signal(down(i));
                                else
                                    done=0;
                                    ll=length(bb);
                                    coun=1;
                                    if ll==2
                                        while(done==0)
                                            done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.02||coun+1==ll);
                                            coun=coun+1;
                                        end
                                    else
                                        while(done==0)
                                            done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.02||coun+2==ll||signal(bb(coun))<signal(bb(coun+1))&&signal(bb(coun))<signal(bb(coun+2)));
                                            coun=coun+1;
                                        end
                                    end
                                    down(i)=bb(coun-1);downpea(i)=signal(down(i));
                                end
                            else
                                mi=find(signal(ind(i):end)==min(signal(ind(i):end)));
                                down(i)=mi(1)+ind(i)-1;
                                downpea(i)=signal(down(i));
                            end
                        else
                            if base(i+1)>=ind(i)+15
                                bb=b1(b1>ind(i));
                                bb=bb(bb<=ind(i)+15);
                                if ~isempty(bb)      
                                    if length(bb)==1
                                        down(i)=bb;downpea(i)=signal(down(i));
                                    else
                                        done=0;
                                        ll=length(bb);
                                        coun=1;
                                        if ll==2
                                            while(done==0)
                                                done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.02||coun+1==ll);
                                                coun=coun+1;
                                            end
                                        else
                                            while(done==0)
                                                done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.02||coun+1==ll||signal(bb(coun))<signal(bb(coun+1))&&signal(bb(coun))<signal(bb(coun+2)));
                                                coun=coun+1;
                                            end
                                        end
                                        down(i)=bb(coun-1);downpea(i)=signal(down(i));
                                    end
                                else
                                    mi=find(signal(ind(i):ind(i)+15)==min(signal(ind(i):ind(i)+15)));
                                    down(i)=mi(1)+ind(i)-1;
                                    downpea(i)=signal(down(i));
                                end
                            else
                                bb=b1(b1>ind(i));
                                bb=bb(bb<=base(i+1)); 
                                
                                if ~isempty(bb)      
                                    if length(bb)==1
                                        down(i)=bb;downpea(i)=signal(down(i));
                                    else
                                        done=0;
                                        ll=length(bb);
                                        coun=1;
                                        if ll==2
                                            while(done==0)
                                                done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.02||coun+1==ll);
                                                coun=coun+1;
                                            end
                                        else
                                            while(done==0)
                                                done=(abs(signal(bb(coun))-signal(bb(coun+1)))/signal(bb(coun))<0.02||coun+2==ll||signal(bb(coun))<signal(bb(coun+1))&&signal(bb(coun))<signal(bb(coun+2)));
                                                coun=coun+1;
                                            end
                                        end
                                        down(i)=bb(coun-1);downpea(i)=signal(down(i));
                                    end
                                else
                                    mi=find(signal(ind(i):base(i+1))==min(signal(ind(i):base(i+1))));
                                    down(i)=mi(1)+ind(i)-1;
                                    downpea(i)=signal(down(i));                                    
                                end
                            end
                        end
                    end             
                end
                
                indcopy=ind;
                [spmax, spmin, ~]= extrema(sss);
                b1=spmax(:,1); b2=spmax(:,2);
                for i=1:length(ind)
                    c=abs(b1-indcopy(i));
                    [c,x]=sort(c);
                    if c(2)>c(1)
                        if b2(x(1))>b2(x(2))
                            ind(i)=b1(x(1));
                        else
                           ind(i)=b1(x(2)); 
                        end
                    else
                        ind(i)=b1(x(1));
                    end
                end
                b1=spmin(:,1); b2=spmin(:,2);
                basecopy=base;
                
                for i=1:length(ind)
                    c=abs(b1-basecopy(i));
                    [c,x]=sort(c);
                    if c(2)>c(1)
                        if b2(x(1))<b2(x(2))
                            base(i)=b1(x(1));
                        else
                           base(i)=b1(x(2)); 
                        end
                    else
                        base(i)=b1(x(1));
                    end
                end 
                
                downcopy=down;
                for i=1:length(ind)
                    c=abs(b1-downcopy(i));
                    [c,x]=sort(c);
                    if c(2)>c(1)
                        if b2(x(1))<b2(x(2))
                            down(i)=b1(x(1));
                        else
                           down(i)=b1(x(2)); 
                        end
                    else
                        down(i)=b1(x(1));
                    end
                end
                
                
                for i=1:length(ind)
                    if basepea(i)>=pea(i)
                        ind(i)=0;
                        base(i)=0;
                        down(i)=0;
                    end
                    if downpea(i)>=pea(i)
                        ind(i)=0;
                        base(i)=0;
                        down(i)=0;
                    end
                    if down(i)-base(i)<4
                        ind(i)=0;
                        base(i)=0;
                        down(i)=0;
                    end
                    if pea(i)<40
                        ind(i)=0;
                        base(i)=0;
                        down(i)=0;  
                    end
                    if ind(i)<3
                        ind(i)=0;
                        base(i)=0;
                        down(i)=0;                          
                    end
                end
                
                for i=1:length(ind)
                   if base(i)>ind(i)&&base(i)<down(i)
                       b=find(sss(base(i):down(i))==max(sss(base(i):down(i))));
                       b=base(i)+b-1;
                       ind(i)=b(1);
                   end
                end
                
                
                ind(ind==0)=[];
                base(base==0)=[];
                down(down==0)=[];
                l=length(ind);  
                if l
                    pea=sss(ind);
                    basepea=sss(base);
                    downpea=sss(down);
                    n1=base(1);n1p=basepea(1);
                    n2=down(1);n2p=downpea(1);
                    nn=ind(1);

                    if n1p<n2p
                        done=0;
                        n=0;
                        while(done==0)
                            done=(sss(nn-n)-n2p>=0&&sss(nn-n-1)-n2p<=0||nn-n==1);
                            n=n+1;
                        end
                        RiseTime=n;
                        DownTime=n2-nn;
                    else
                        done=0;
                        n=0;
                        while(done==0)
                            done=(sss(nn+n)-n1p>=0&&sss(nn+n+1)-n1p<=0||nn+n==r);
                            n=n+1;
                        end
                        RiseTime=nn-n1;
                        DownTime=n;
                    end
                else
                    base=[];
                    basepea=[];
                    down=[];
                    downpea=[];
                    RiseTime=[];
                    DownTime=[];
                end
            else
                base=[];
                basepea=[];
                down=[];
                downpea=[];
                RiseTime=[];
                DownTime=[];
            end
        end
    else
        base=[];
        basepea=[];
        down=[];
        downpea=[];
        RiseTime=[];
        DownTime=[];
    end
    
end