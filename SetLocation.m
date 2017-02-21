function SetLocation(f,h,row,col,screen,panel)

%     screensize=get(0,'screensize');
    positionf=get(f,'position');

    ra=double(row)/double(col);
    rl=screen(4)*positionf(4)*0.85;%height
    cl=screen(3)*positionf(3)*0.6;%width
    
    if cl/rl>=ra
        set(h,'parent',panel); 
        set(h,'position',[((cl-rl*ra)/2)/cl,0,rl*ra/cl,1]);
        set(h,'xlim',[1,col+1],'ylim',[1,row+1]);  
        
    else
        set(h,'parent',panel); 
        set(h,'position',[0,((rl-cl/ra)/2)/rl,1,cl/ra/rl]);
        set(h,'xlim',[1,col+1],'ylim',[1,row+1]);
        
    end
    
end