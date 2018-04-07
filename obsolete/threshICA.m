function si=threshICA(si,r)
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
        if c<20
            b(A==i)=false;
        end
    end
    si=b;
    si=bwmorph(si,'clean');
    [A,num]=bwlabel(si);
    STATS=regionprops(si,'Area');
    for i=1:num
        c=STATS(i).Area;
        if c<20
            si(A==i)=false;
        end
    end
end