function lsm_uint(row,col,lsm_image,map1)
%     clear all;
    global f0 currentflash stabledata flashsignal ROI ROItext ROIpoint
    global count Filename   xy r signal signalpoint
    global flashindex  flg   Rise Down DeltF_F0 Classf
    screen=get(0,'ScreenSize');
    
    if row+50>screen(4)
        ap=row/col;
        row=screen(4)-250;
        col=row/ap;
        col=floor(col);
    end
    if row<320
        ap=row/col;
        row=320;
        col=row/ap;
        col=floor(col);
    end    
  
    f = figure('Visible','on','Menubar','none','Toolbar','none','Units', 'Pixel','numbertitle','off','Position',[floor((screen(3)-col-10)/2),floor((screen(4)-row-60)/2),col+10,row+60],'resize','on'...
        ,'color',[1,1,1]);
    set(f,'name',strcat('Superoxide Flashes Detector/  ',Filename),'tag','figure2','BusyAction','cancel','KeyPressFcn',@keyf)    
    SetIcon(f);
   
    sto=0;
    rr=1;
    Line=[]; 
    Linetext=[];
    Linecount=0;
    Val1=0;
    Val2=0;
    dra=findobj('type','axes','parent',f0);
    dra=dra(1);
    ylim=get(dra,'YLim');
    hlabel=line('XData',[1,1],'YData',ylim,'visible','off','Parent',dra,'Interruptible','on','BusyAction','cancel');    

    tablef=findobj('tag','table1','Parent',f0);
    set(tablef,'data',stabledata,'BusyAction','cancel');   
    
    th = uitoolbar(f);
    th1 = uitoolbar(f);

    [Load_Status,map]=imread('.\bitmaps\importd.bmp');
    Load_Status=ind2rgb(Load_Status,map);
    Load_Status= uipushtool(th,'CData',Load_Status,'TooltipString','Load status','HandleVisibility','off','Clipping','off');

    [Save_Status,map]=imread('.\bitmaps\importf.bmp');
    Save_Status=ind2rgb(Save_Status,map);
    Save_Statust= uipushtool(th,'CData',Save_Status,'TooltipString','Save status','HandleVisibility','off');
    set(Save_Statust,'clickedcallback',@statusf,'BusyAction','cancel')
    [Save_Movie,map]=imread('.\bitmaps\movie.bmp');
     
    Save_Movie= uipushtool(th,'CData',Save_Movie,'TooltipString','Save movie','HandleVisibility','off');
    set(Save_Movie,'ClickedCallback',@save_movie,'BusyAction','cancel')

    [Data_cursor,map]=imread('.\bitmaps\data_cursor.bmp');
    Datacursort= uitoggletool(th,'CData',Data_cursor,'TooltipString','Data_cursor','HandleVisibility','on');
    set(Datacursort,'OnCallback',@datacursoron)
    set(Datacursort,'OffCallback',@datacursoroff)
    
    Play=imread('.\bitmaps\play.bmp');
    Playt= uipushtool(th,'CData',Play,'TooltipString','Play','HandleVisibility','off','Separator','on');
    set(Playt,'ClickedCallback',@playf,'BusyAction','cancel')

    Stop=imread('.\bitmaps\pause.bmp');
    Stopt= uipushtool(th,'CData',Stop,'TooltipString','Stop','HandleVisibility','off');
    set(Stopt,'ClickedCallback',@stopf,'BusyAction','cancel')
    
    [Brightness,map]=imread('.\bitmaps\brightness.bmp');
    Brightness= uipushtool(th,'CData',Brightness,'TooltipString','Adjust brightness','HandleVisibility','off','Separator','on','enable','off'); 
    set(Brightness,'ClickedCallback',@BrightnessAdjust,'BusyAction','cancel')  
    
    [Contrast,map]=imread('.\bitmaps\bulb.bmp');
    Contrast=ind2rgb(Contrast,map);
    Contrastt= uipushtool(th,'CData',Contrast,'TooltipString','Adjust contrast','HandleVisibility','off','enable','off'); 
    set(Contrastt,'ClickedCallback',@ContrastAdjust,'BusyAction','cancel')
    
    [Rulert,map]=imread('.\bitmaps\line.bmp');
    Rulert=ind2rgb(Rulert,map);
    Rulert= uitoggletool(th,'CData',Rulert,'TooltipString','Ruler','HandleVisibility','off','Separator','on');
    set(Rulert,'OnCallback',@Rulerf,'OffCallback',@recover,'BusyAction','cancel')
    
    [linedelete,map]=imread('.\bitmaps\linedelete.bmp');
    linedelete=ind2rgb(linedelete,map);
    linedelete= uipushtool(th,'CData',linedelete,'TooltipString','Detele all rulers','HandleVisibility','off');
    set(linedelete,'ClickedCallback',@linedetele1,'BusyAction','cancel')    

    [framedelete,map]=imread('.\bitmaps\deletebad.bmp');
%     framedelete=ind2rgb(framedelete,map);
    framedelete= uipushtool(th,'CData',framedelete,'TooltipString','Delete bad frame','HandleVisibility','off');
    set(framedelete,'ClickedCallback',@framedeletef,'BusyAction','cancel') 
    
    [Area,map]=imread('.\bitmaps\area.bmp');
%     Area=ind2rgb(Area,map);
    Area= uipushtool(th,'CData',Area,'TooltipString','Cell area','HandleVisibility','off');
    set(Area,'ClickedCallback',@areacacul,'BusyAction','cancel')
    
    [ShowTrackerImage,map]=imread('.\bitmaps\switch_up.bmp');
    ShowTrackerImage=ind2rgb(ShowTrackerImage,map);
    [HideTrackerImage,map]=imread('.\bitmaps\switch_down.bmp');
    HideTrackerImage=ind2rgb(HideTrackerImage,map);    
    ShowTracker= uitoggletool(th,'CData',ShowTrackerImage,'TooltipString','Show Tracker','HandleVisibility','off','Separator','on');
    set(ShowTracker,'OnCallback',{@ShowTrackerf},'OffCallback',{@HideTrackerf})
    
    [ROIm,map]=imread('.\bitmaps\ROI_M.bmp');
%     ROIm=ind2rgb(ROIm,map);
    uipushtool(th1,'CData',ROIm,'TooltipString','ROI Manualdetection','HandleVisibility','off','HitTest','off','BusyAction','cancel');
    
    [Rectangl,map]=imread('.\bitmaps\rectangl.bmp');
    Rectangl=ind2rgb(Rectangl,map);
    Rectanglt= uitoggletool(th1,'CData',Rectangl,'TooltipString','Rectangle','HandleVisibility','off');
    set(Rectanglt,'OnCallback',@retangle,'OffCallback',@recover,'BusyAction','cancel')
%     set(Rectanglt,'OffCallback',@recover)

    [Segpoly,map]=imread('.\bitmaps\segpoly.bmp');
    Segpoly=ind2rgb(Segpoly,map);
    Segpolyt= uitoggletool(th1,'CData',Segpoly,'TooltipString','Polygon','HandleVisibility','off');
    set(Segpolyt,'OnCallback',@poly,'OffCallback',@recover,'BusyAction','cancel')
       
    [ROIa,map]=imread('.\bitmaps\ROI_A.bmp');
%     ROIa=ind2rgb(ROIa,map);
    uipushtool(th1,'CData',ROIa,'TooltipString','ROI Autodetection','HandleVisibility','off','HitTest','off','Separator','on');
    
    [Auto,map]=imread('.\bitmaps\gears.bmp');
    Auto=ind2rgb(Auto,map);
%     right=uitoolbar(f)
    Auto=uipushtool(th1,'TooltipString','Automatic detection','CData',Auto,'visible','on','clickedcallback',@autof,'BusyAction','cancel');
    
    [AutoROIp,map]=imread('.\bitmaps\gearsROI.bmp');
    AutoROIp=ind2rgb(AutoROIp,map);
%     right=uitoolbar(f)
    AutoROIp=uitoggletool(th1,'TooltipString','Local automatic point detection','CData',AutoROIp,'visible','on');  
    set(AutoROIp,'OnCallback',@autoROIfp,'OffCallback',@recover,'BusyAction','cancel'); 
 
    [roi,map]=imread('.\bitmaps\ROIselect.bmp');

    [Delete,map]=imread('.\bitmaps\delete.bmp');
    Delete=ind2rgb(Delete,map);   
%     right=uitoolbar(f)
    Delete=uipushtool(th1,'TooltipString','Delete current ROI','CData',Delete,'visible','on'...
        ,'ClickedCallback',@deletthis);
    
    [Deletem,map]=imread('.\bitmaps\DeleteManualROI.bmp');
    Deletem=ind2rgb(Deletem,map);   
%     right=uitoolbar(f)
    Deletetm=uipushtool(th1,'TooltipString','Delete All ROI','CData',Deletem,'visible','on'...
        ,'ClickedCallback',@delet,'BusyAction','cancel');
     
    [hide,map]=imread('.\bitmaps\HideLabel.bmp');
    hide=ind2rgb(hide,map); 
    [hider,map]=imread('.\bitmaps\text.bmp');
    hider=ind2rgb(hider,map);     
    hidef=uitoggletool(th1,'TooltipString','Hide Label','CData',hide,'visible','on'...
        ,'OnCallback',@hideon,'offCallback',@hideoff);
    
    [hideROI,map]=imread('.\bitmaps\HideROI.bmp');
    hideROI=ind2rgb(hideROI,map);
    [hideROIr,map]=imread('.\bitmaps\segpoly_active.bmp');
    hideROIr=ind2rgb(hideROIr,map);     
    hideROIf=uitoggletool(th1,'TooltipString','Hide ROI','CData',hideROI,'visible','on'...
        ,'OnCallback',@hideROIon,'OffCallback',@hideROIoff);
    
    [sorta,map]=imread('.\bitmaps\right.bmp');
%     sorta=ind2rgb(sorta,map);      
    sorta=uipushtool(th1,'TooltipString','Sort in space','CData',sorta,'visible','on','enable','on','ClickedCallback',@sortf);
    
    [left,map]=imread('.\bitmaps\shift_left.bmp');
    left=ind2rgb(left,map);      
    Leftt=uipushtool(th1,'TooltipString','Previous ROI','CData',left,'visible','on','enable','off','tag','Leftt','ClickedCallback',@leftf);
    
    [right,map]=imread('.\bitmaps\shift_right.bmp');
    right=ind2rgb(right,map);
    Rightt=uipushtool(th1,'TooltipString','Next ROI','CData',right,'visible','on','enable','off','tag','Rightt','ClickedCallback',@rightf);       
    
    [ROIselection,map]=imread('.\bitmaps\arrow.bmp');
    ROIselection=ind2rgb(ROIselection,map);      
    ROIselection=uitoggletool(th1,'TooltipString','ROIselection','CData',ROIselection,'visible','on','OnCallback',@ROIselectionf,'OffCallback',@recover); 
    
    [r1,c1]=size(lsm_image(:,:,1));
    drawf.f1=axes('Parent',f,'Units','pixel','Position',[5,60,col,row],'xtick',[],'ytick',[]...
        ,'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94],'drawmode','fast','XLim',[1,c1+1],'YLim',[1,r1+1],'tag','drawf1');
    
    drawf.f2=axes('Parent',f,'Units','pixel','Position',[5,60,col,row],'xtick',[],'ytick',[]...
        ,'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94],'drawmode','fast','XLim',[1,c1+1],'YLim',[1,r1+1],'tag','drawf2');
    axis ij
%     axis square    
    drawf.f3=axes('Parent',f,'Units','pixel','Position',[5,60,col,row],'xtick',[],'ytick',[]...
        ,'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94],'drawmode','fast','XLim',[1,c1+1],'YLim',[1,r1+1],'tag','drawf3');
    axis ij
    
    drawf.f4=axes('Parent',f,'Units','pixel','Position',[5,60,col,row],'xtick',[],'ytick',[]...
        ,'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94],'drawmode','fast','XLim',[1,c1+1],'YLim',[1,r1+1],'tag','drawf4');      
    axis ij
    
    drawf.f5=axes('Parent',f,'Units','pixel','Position',[5,60,col,row],'xtick',[],'ytick',[]...
        ,'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94],'drawmode','fast','XLim',[1,c1+1],'YLim',[1,r1+1],'tag','drawf5');      
    axis ij    
    
    set(drawf.f2,'color','none')
    set(drawf.f3,'color','none')
    set(drawf.f4,'color','none')
    set(drawf.f5,'color','none')
    
    set(f,'windowbuttondownfcn',@db)
    ShowT='off';

    set(f,'CloseRequestFcn',@closereq)
    imag=lsm_image(:,:,1);
    imshow(imag,map1,'parent',drawf.f1)
    axis off
    
    set(f,'ResizeFcn',@ResizeFcnf)
    
    clear fileg Loadf Save_Statusf Save_movie Exitf playg Stopg zooming zoomoutg Informationt tool Brightness Contrastt Filtert linedelete analysisg helpg
    clear sorta merge Deletetm AutoROI Auto roi Load_Status ROIm
    r=size(lsm_image,3);  
  
    panel1=uipanel(f,'Title','','FontSize',12,'BackgroundColor','white','units','pixel','Position',[5 2 col 50],'BorderType','etchedin');
    panel11=uipanel(panel1,'Title','','FontSize',12,'BackgroundColor','white','units','pixel','Position',[0 25 col 25]);
    h = uicontrol(panel11,'style', 'slider','Units','pixel','Position',[0,3,col-2,18],'min',0,'max',1,'value',0,'BackgroundColor',[1 1 1]);
    
    if r==1
        set(h,'enable','off');
        rr=1;
    else
        eachstep=[1/(r-1),1/(r-1)];
        set(h,'sliderstep',eachstep);
        lastVal = get(h, 'Value');
        eachstep=get(h,'sliderstep');
        rr=round(lastVal/eachstep(1));
    end
    
    panel12=uipanel(panel1,'Title','','FontSize',12,'BackgroundColor','white','units','pixel','Position',[0 0 100 25]);
    panel13=uipanel(panel1,'Title','','FontSize',12,'BackgroundColor','white','units','pixel','Position',[col-150 0 70 25]); 
    panel14=uipanel(panel1,'Title','','FontSize',12,'BackgroundColor','white','units','pixel','Position',[col-80 0 80 25]); 
    
    ht = uicontrol(panel12,'style', 'slider','Units','pixel','Position',[20,8,100,10],'min',0,'max',0.1,'value',0,'BackgroundColor',[1 1 1]);
    set(ht,'callback',@htf)
    htime=uicontrol('parent',panel13,'Style','text','string','Ready','fontsize',10,'Units','Pixel','Position',[2 3  64 18],'BackgroundColor','white','foregroundcolor',[0,0,0],'HorizontalAlignment','center');
    str=strcat(num2str(rr),'/',num2str(r));
    nu = uicontrol('parent',panel14,'Style','text','string',str,'HorizontalAlignment','center','Units','Pixel','Position',[2 2  74 18],'BackgroundColor','white');

    pack
    
    hJScrollBar = findjobj(h);
    hJScrollBar.AdjustmentValueChangedCallback = @cb1;   
    
    function datacursoron(s,e)
        datacursormode on
    end
    
    function datacursoroff(s,e)
        datacursormode off
    end

    function cb1(s,e)
        if get(h, 'Value') ~= lastVal 
            lastVal = get(h, 'Value');
            rr=round(lastVal/eachstep(1))+1;
            str=strcat(num2str(rr),'/',num2str(r)); 
            set(nu,'string',str)
            imag=lsm_image(:,:,rr);
            imshow(imag,map1,'parent',drawf.f1)
            if count>0
                if strcmp(ShowT,'on')
                    if ishandle(hlabel)
                        delete(hlabel)
                    end
                    ylim=get(dra,'YLim');
                    hlabel=line('XData',[rr,rr],'YData',ylim,'parent',dra);
                else
                    if ishandle(hlabel)
                        delete(hlabel)
                    end                    
                end
            end            
        end
    end
    function htf(s,e)
        
  
    end

    ROI={};
    ROItext=[];
    
    if count>0
        currentflash=count;
        for k=1:count
            hh=[];
            poin=ROIpoint{k};
            x=poin.x;
            y=poin.y;
%             l=length(x);
%             xx=point.x;yy=point.y;
            hh=line('XData',x,'YData', y,'color',[0.8,0.4,0],'LineWidth',1,'parent',drawf.f3);
            ROI{k}=hh;    
            h5=text(mean(x),mean(y),num2str(k),'color',[0.8,0.8,0],'Parent',drawf.f4);
            ROItext(k)=h5;
        end
        
        set(ROItext(currentflash),'color','r','parent',drawf.f4);
        set(ROI{currentflash},'color','r','parent',drawf.f3);
        currentflash=count;
        signal=flashsignal(currentflash,:);
        
        pF=get(f0,'position');
        pF(1)=0;
        pF(2)=pF(4)*1/3;
        pF(3)=pF(3);
        pF(4)=pF(4)*2/3;
        set(dra,'OuterPosition',pF)
        clear pF
        cla(dra)
        plot(dra,signal,'color',[0,1,0],'LineWidth',2) 
        legend(dra,strcat('ROI: ',num2str(currentflash)))
        axis(dra,[1,r,min(signal)-10,max(signal)+10])
        axis(dra,'on')
        axis(dra,'xy')
        set(tablef,'data',stabledata);
        if ~isempty(signalpoint)
            point=signalpoint{currentflash};
            if ~isempty(point.ind)
                hold on
                h_R=[];h_P=[];h_D=[];
                for i=1:length(point.ind)
                    h_R(i)=line('XData',point.ind(i),'YData',point.pea(i),'Marker','s','color','r','markersize',10,'tag','0','parent',dra);
                    h_P(i)=line('XData',point.base(i),'YData',point.basepea(i),'Marker','*','color','r','markersize',10,'tag','1','parent',dra);
                    h_D(i)=line('XData',point.down(i),'YData',point.downpea(i),'Marker','o','color','r','markersize',10,'tag','2','parent',dra);
                end
%                 set(h_R,'buttondownfcn',@PointDownf)
%                 set(h_P,'buttondownfcn',@PointDownf)
%                 set(h_D,'buttondownfcn',@PointDownf)
            end
        end
    else
        count=0;
        ROIpoint={};
        
        stabledata={};
        currentflash=0;
        flashsignal=[];% will delete in the future
        signalpoint={};
        Rise={};
        Down={};
        Classf=[];
        flashindex=[];
    end
    
    clear k poin hh h5 x y h1
    pack 
    pause(0.1)
    

    function ContrastAdjust(s,e)
        h4=findobj(f,'tag','h4');

        if ishandle(h4)
           delete(h4) 
        end
      
        h4 = uicontrol('style', 'slider','Units', 'Pixel','position', [90 10 col/3 15],'min',0,'max',1,'value',Val1,'BackgroundColor',[1 1 1]);
        hJScrollBar = findjobj(h4);
        hJScrollBar.AdjustmentValueChangedCallback = @cb;
        
        h2 = uicontrol('Style', 'pushbutton', 'String', 'Done','position',[col*1/3+100,6,37,25],'callback',@done);
        h3 = uicontrol('Style', 'pushbutton', 'String', 'Cancel','position',[col*1/3+137,6,37,25],'callback',@cancel);
        h6 = uicontrol('Style', 'pushbutton', 'String', 'Reset','position',[col*1/3+174,6,37,25],'callback',@reset);
        set(h4,'tag','h4')
        set(h2,'tag','h2')
        set(h3,'tag','h3')
        set(h6,'tag','h6')        
        
        function done(s,e)
            for i=1:r
                imag=lsm_image(:,:,i);
                imag=imadjust(imag,[Val1,(1-Val1)]);
                lsm_image(:,:,i)=imag;
            end
            set(h4,'value',Val1);
            delete (h4)
            delete (h2)
            delete (h3)
            delete (h6)
            clear h4 h2 h3 h6
        end
        
        function cancel(s,e)
            set(h4,'value',Val1);
            delete (h4)
            delete (h2)
            delete (h3)
            delete (h6)
            clear h4 h2 h3 h6
        end
         
        function cb(s,e)
            if ishandle(h4)
                if get(h4, 'Value') ~=Val1 
                    Val1 = get(h4, 'Value');
                    imag=lsm_image(:,:,rr);
                    
                    imag=imadjust(imag,[Val1,(1-Val1)]);
                    imshow(imag,map1,'parent',drawf.f1)
                    clear imag 
                    pack
                end
            end
        end          
    end

    function BrightnessAdjust(s,e)
        
        h4=findobj(f,'tag','h4');
        cla(drawf.f2)
        set(f,'WindowButtondownFcn','')
        set(f,'WindowButtonmotionFcn','')
        set(f,'WindowButtonupFcn','')
        set(f,'Pointer','arrow');
        set(AutoROIp,'state','off')
        if ishandle(h4)
           delete(h4) 
        end
        
        h4 = uicontrol('style', 'slider','Units', 'Pixel','position', [90 10 col/3 15],'min',-1,'max',1,'value',Val2,'BackgroundColor',[1 1 1]);
        hJScrollBar = findjobj(h4);
        hJScrollBar.AdjustmentValueChangedCallback = @cb;
        
        h2 = uicontrol('Style', 'pushbutton', 'String', 'Done','position',[col*1/3+100,6,37,25],'callback',@done);
        h3 = uicontrol('Style', 'pushbutton', 'String', 'Cancel','position',[col*1/3+137,6,37,25],'callback',@cancel);
        set(h4,'tag','h4')
        set(h2,'tag','h2')
        set(h3,'tag','h3')
        
        function done(s,e)
            for i=1:r
                imag=lsm_image(:,:,i);
                imag=uint8(double(imag)+(Val2*double(imag)));
                lsm_image(:,:,i)=imag;
            end
            set(h4,'value',Val2);
            delete (h4)
            delete (h2)
            delete (h3)
            clear h4 h2 h3 
        end
        
        function cancel(s,e)
            set(h4,'value',Val2);
            delete (h4)
            delete (h2)
            delete (h3)
            clear h4 h2 h3
        end
        
        function cb(s,e)
            if ishandle(h4)
                if get(h4, 'Value') ~=Val2 
                    Val2 = get(h4, 'Value');
                    imag=lsm_image(:,:,rr);
                    imag=uint8(double(imag)+(Val2*double(imag)));
                    imshow(imag,map1,'parent',drawf.f1)
                    clear imag
                    pack
                end
            end
        end
    end
    
    function Rulerf(s,e)
        set(Rectanglt,'state','off')
        set(Segpolyt,'state','off')
        pp=ones(16);
        pp(:,:)=NaN;
        pp(8,:)=2;
        pp(:,8)=2;
        pp(end,:)=NaN;
        pp(:,end)=NaN;        
        set(f,'WindowButtonmotionFcn',@wb)
        set(f,'WindowButtonDownFcn',@wbdcb)
        
        function wb(s,e)
            pgca=get(drawf.f2,'position');
            p=get(f,'currentpoint');
            if p(1,1)>pgca(1)&&p(1,1)<pgca(1)+pgca(3)&&p(1,2)>pgca(2)&&p(1,2)<pgca(2)+pgca(4)
                set(f,'pointer','custom','PointerShapeCData',pp,'PointerShapeHotSpot',[8,8])
            else
                set(f,'pointer','arrow')
            end
        end
        
        function wbdcb(src,evnt)
            if strcmp(get(src,'SelectionType'),'normal')
                cp = get(drawf.f2,'CurrentPoint');
                xinit = cp(1,1);yinit = cp(1,2);
                hl = line('XData',xinit,'YData',yinit,'color','w','EraseMode','normal','parent',drawf.f2);
                set(src,'WindowButtonMotionFcn',@wbmcb)
                set(src,'WindowButtonUpFcn',@wbucb)
            end

            function wbmcb(src,evnt)
                pgca=get(drawf.f2,'position');
                p=get(f,'currentpoint');
                ggca=get(drawf.f2,'currentpoint');
                if p(1,1)>pgca(1)&&p(1,1)<pgca(1)+pgca(3)&&p(1,2)>pgca(2)&&p(1,2)<pgca(2)+pgca(4)
                    set(f,'pointer','custom','PointerShapeCData',pp,'PointerShapeHotSpot',[8,8])
                    xdat = [xinit,ggca(1,1)];
                    ydat = [yinit,ggca(1,2)];
                    set(hl,'XData',xdat,'YData',ydat);drawnow
                    drawnow                    
                else
                    set(f,'pointer','arrow')
                end                
            end

            function wbucb(src,evnt)
                set(src,'WindowButtonMotionFcn','')
                set(src,'WindowButtonUpFcn','')
                Linecount=Linecount+1;
                Line(Linecount)=hl;
                x=get(hl,'XData');
                y=get(hl,'YData');
                dis=sqrt((x(1)-x(2))^2+(y(1)-y(2))^2)*xy.VoxelSizeX*10^6;
                h5=text((x(1)+x(2))/2,(y(1)+y(2))/2,num2str(dis),'HorizontalAlignment','center','Color','r','FontSize',9,'BackgroundColor',[.4 .9 .4],'Parent',drawf.f2);
                Linetext(Linecount)=h5;
                if Linecount>1
                    set(Line(Linecount-1),'color',[0.8,0.8,0]);
                    set(Linetext(Linecount-1),'color',[0.8,0.8,0],'BackgroundColor',[.7 0.9 .7]);
                end 
                set(f,'windowbuttonmotionfcn',@wb)
            end
        end
    end

    function linedetele1(s,e)
        Line=[];
        Linetext=[]; 
        Linecount=0;
        set(Rulert,'state','off')
        cla(drawf.f2)
    end

    function retangle(s,e)
        set(Rulert,'state','off')
        set(Segpolyt,'state','off') 
        set(ROIselection,'state','off') 
        pp=ones(16);
        pp(:,:)=NaN;
        pp(8,:)=2;
        pp(:,8)=2;
        pp(end,:)=NaN;
        pp(:,end)=NaN;           
        set(f,'pointer','custom','PointerShapeCData',pp)
        set(f,'WindowButtonmotionfcn',@wb)
        set(f,'WindowButtonDownFcn',@wbdcb)
        function wb(s,e)
            pgca=get(drawf.f3,'position');
            p=get(f,'currentpoint');
            if p(1,1)>pgca(1)&&p(1,1)<pgca(1)+pgca(3)&&p(1,2)>pgca(2)&&p(1,2)<pgca(2)+pgca(4)
                set(f,'pointer','custom','PointerShapeCData',pp,'PointerShapeHotSpot',[8,8])
            else
                set(f,'pointer','arrow')
            end
        end        
        
        function wbdcb(src,e)
            if strcmp(get(src,'SelectionType'),'normal')
                set(f,'pointer','custom','PointerShapeCData',pp,'PointerShapeHotSpot',[8,8])
                cp = get(drawf.f3,'CurrentPoint');
                xinit = cp(1,1);yinit = cp(1,2);
                point.x=[];
                point.y=[];
                h1 = line('XData',xinit,'YData',yinit,'color','r','parent',drawf.f3);
                h2 = line('XData',xinit,'YData',yinit,'color','r','parent',drawf.f3);
                h3 = line('XData',xinit,'YData',yinit,'color','r','parent',drawf.f3);
                h4 = line('XData',xinit,'YData',yinit,'color','r','parent',drawf.f3);
                set(src,'WindowButtonMotionFcn',@wbmcb)
                set(src,'WindowButtonUpFcn',@wbucb)
            end
            function wbmcb(src,evnt)
                cp = get(drawf.f3,'CurrentPoint');
                xdat = cp(1,1);
                ydat = cp(1,2);
                
                if xdat~=xinit&&ydat~=yinit
                    x1dat=[xinit,xdat];y1dat=[yinit,yinit];
                    x2dat=[xinit,xinit];y2dat=[yinit,ydat];
                    x3dat=[xinit,xdat];y3dat=[ydat,ydat];
                    x4dat=[xdat,xdat];y4dat=[yinit,ydat];
                    set(h1,'XData',x1dat,'YData',y1dat);
                    set(h2,'XData',x2dat,'YData',y2dat);
                    set(h3,'XData',x3dat,'YData',y3dat);
                    set(h4,'XData',x4dat,'YData',y4dat);
                end
                drawnow
            end
            function wbucb(src,evnt)
                  set(src,'WindowButtonMotionFcn','')
                  set(src,'WindowButtonUpFcn','')
                  x=get(h1,'XData');
                  y=get(h2,'YData');
                  if length(x)==1
                      delete(h1)
                      delete(h2)
                      delete(h3)
                      delete(h4)
                  else
                      count=count+1;
                      currentflash=count;

                      x=floor(x);
                      y=floor(y);
                      signal=zeros(1,r);
                      if x(1)<x(2)&&y(1)<y(2)
                          for i=1:r
                            imag=lsm_image(:,:,i);
                            imag=imag(y(1):y(2),x(1):x(2));
                            imag=double(imag);
                            signal(i)=mean(mean(imag));
                          end
                      elseif x(2)<x(1)&&y(1)<y(2)
                          for i=1:r
                            imag=lsm_image(:,:,i);
                            imag=imag(y(2):y(1),x(1):x(2));
                            imag=double(imag);
                            signal(i)=mean(mean(imag));
                          end
                      elseif x(1)<x(2)&&y(2)<y(1)
                          for i=1:r
                            imag=lsm_image(:,:,i);
                            imag=imag(y(2):y(1),x(1):x(2));
                            imag=double(imag);
                            signal(i)=mean(mean(imag));
                          end 
                      elseif x(2)<x(1)&&y(2)<y(1)
                          for i=1:r
                            imag=lsm_image(:,:,i);
                            imag=imag(y(2):y(1),x(2):x(1));
                            imag=double(imag);
                            signal(i)=mean(mean(imag));
                          end 
                      else
                          for i=1:r
                            imag=lsm_image{i};
                            imag=imag(y(1):y(2),x(1):x(2));
                            imag=double(imag);
                            signal(i)=mean(mean(imag));
                          end 
                      end

                      [ind,pea,base,basepea,down,downpea,RiseTime,DownTime]=traceAnalysis(signal,r);
                      s=signal;
                      s=sort(s);
                      point=[];
                      if ~isempty(ind)&&length(ind)<6&&mean(s(1:10))>5&&~isempty(find(s>(mean(s)+1.3*std(s))))&&max(s)>35
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
                      flashsignal=[flashsignal;signal];
                      signalpoint{count}=point;
                      stabledata{count,1}=num2str(count);
                      flg(count)=0;
                      
                      pf=get(f0,'position');
                      set(dra,'OuterPosition',[0,pf(4)*1/3,pf(3),pf(4)*2/3])
                      clear pf
                      cla(dra)
                      plot(dra,signal,'color',[0,1,0],'LineWidth',2)
                      axis(dra,[1,r,min(signal)-10,max(signal)+10])
                      axis(dra,'on')
                      axis(dra,'xy')

                      set(tablef,'data',stabledata);                  
                      hh(1)=h1;
                      hh(2)=h2;
                      hh(3)=h3;
                      hh(4)=h4;
                      set(Rightt,'enable','off'); %next flash button is unenable
                      ROI{count}=hh;

                      point.x=[x(1),x(2),x(2),x(1),x(1)];
                      point.y=[y(1),y(1),y(2),y(2),y(1)];
                      ROIpoint{count}=point;
                      
                      if strcmp(get(hidef,'state'),'off')
                          h5=text((x(1)+x(2))/2,(y(1)+y(2))/2,num2str(count),'Parent',drawf.f4);
                          set(h5,'color','r','HorizontalAlignment','center')
                      else
                          h5=text((x(1)+x(2))/2,(y(1)+y(2))/2,num2str(count),'visible','off','Parent',drawf.f4);
                          set(h5,'color','r','HorizontalAlignment','center')
                      end
                      
                      ROItext(count)=h5;
                      if count>1
                          set(ROI{count-1},'color',[0.8,0.4,0]);
                          set(ROItext(count-1),'color',[0.8,0.8,0]);
                          set(Leftt,'enable','on')
                          set(Rightt,'enable','off')
                      else
                          set(Leftt,'enable','off')
                      end

                      set(f,'windowbuttonmotionfcn',@wb)
                  end
                  clear s h5 hh point h1 h2 h3 h4 x y
                  pack
            end
        end
    end

    function poly(s,e)
        set(Rectanglt,'state','off')
        set(Rulert,'state','off')
        set(ROIselection,'state','off')   
        set(f,'WindowButtonmotionFcn',@wb)
        set(f,'WindowButtonDownFcn',@wbdcb)
        x=[];
        y=[];
        hh=[];
        pp=ones(16);
        pp(:,:)=NaN;
        pp(8,:)=2;
        pp(:,8)=2;
        pp(end,:)=NaN;
        pp(:,end)=NaN;           
              
        function wb(s,e)
            pgca=get(drawf.f3,'position');
            p=get(f,'currentpoint');
            if p(1,1)>pgca(1)&&p(1,1)<pgca(1)+pgca(3)&&p(1,2)>pgca(2)&&p(1,2)<pgca(2)+pgca(4)
                set(f,'pointer','custom','PointerShapeCData',pp)  
            else
                set(f,'pointer','arrow')
            end
        end 
        function wbdcb(src,evnt)
            
            if strcmp(get(src,'SelectionType'),'normal')
                cp = get(drawf.f3,'CurrentPoint');
                xinit = cp(1,1);yinit = cp(1,2);
                h1=line('XData',xinit,'YData',yinit,'color','r','parent',drawf.f3);
                x=[x,xinit];
                y=[y,yinit];
                hh(length(x))=h1;
                set(src,'WindowButtonMotionFcn',@wbmcb)
                set(src,'WindowButtonUpFcn',@wbucb)
            end

            function wbmcb(src,evnt)
                cp = get(drawf.f3,'CurrentPoint');
                xdat = [xinit,cp(1,1)];
                ydat = [yinit,cp(1,2)];
                set(h1,'XData',xdat,'YData',ydat);drawnow
                if abs(x(1)-cp(1,1))+abs(y(1)-cp(1,2))<6
                    set(f,'pointer','circle')
                else
                    set(f,'pointer','custom','PointerShapeCData',pp)  
                end
            end

            function wbucb(src,evnt)
               if strcmp(get(src,'SelectionType'),'open')
                  set(src,'WindowButtonMotionFcn','')
                  set(f,'pointer','custom','PointerShapeCData',pp)  
                  h1=line('XData',[x(1),x(end)],'YData',[y(1),y(end)],'color','r');
                  hh=[hh,h1];
                  
                 if length(x)==1
                     delete(hh)
                     x=[];y=[];
                 else
                  set(Rightt,'enable','off') 
                  
                  count=count+1;
                  currentflash=count;
                  if strcmp(get(hidef,'state'),'off')
                      h5=text(mean(x),mean(y),num2str(count),'Parent',drawf.f4);
                      set(h5,'color','r','HorizontalAlignment','center')
                  else
                      h5=text(mean(x),mean(y),num2str(count),'Parent',drawf.f4);
                      set(h5,'color','r','HorizontalAlignment','center')
                  end
                  
                  ROI{count}=hh; ROItext(count)=h5;
                  if count>1
                      set(ROI{count-1},'color',[0.8,0.4,0]);
                      set(ROItext(count-1),'color',[0.8,0.8,0]);
                      set(Leftt,'enable','on')
                      set(Rightt,'enable','off')                      
                  else
                      set(Leftt,'enable','off')
                  end
                  x=[x,x(1)];
                  y=[y,y(1)];
                  point.x=x;
                  point.y=y;
                  ROIpoint{count}=point;   
                  imag=lsm_image(:,:,1);
                  
                  bw=roipoly(imag, x, y);
                  signal=zeros(1,r);
                  for i=1:r
                      imag=lsm_image(:,:,i);
                      signal(i)=mean(double(imag(bw==1)));
                  end
                  
                  pf=get(f0,'position');
                  set(dra,'OuterPosition',[0,pf(4)*1/3,pf(3),pf(4)*2/3])
                  clear pf                 
                  cla(dra)
                  plot(dra,signal,'color',[0,1,0],'LineWidth',2)
                  axis(dra,[1,r,min(signal)-10,max(signal)+10])
                  axis(dra,'on')
                  axis(dra,'xy')

                  [ind,pea,base,basepea,down,downpea,RiseTime,DownTime]=traceAnalysis(signal,r);
                  point=[];
                  s=signal;
                  s=sort(s);
                  
                  if ~isempty(ind)&&length(ind)<6&&mean(s(1:10))>5&&~isempty(find(s>(mean(s)+1.3*std(s))))&&max(s)>35
                      Rise{count}=ind-base+1;
                      Down{count}=down-ind+1;
                      stabledata{count,2}=num2str(ind-base+1);
                      str=[];
                      for i=1:length(ind)
                          str=[str,num2str((pea(i)-basepea(i))/basepea(i))];
                      end
                      stabledata{count,3}=str;
                      stabledata{count,4}=num2str(down-ind+1);
                      stabledata{count,5}=[];
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
                  
                  set(tablef,'data',stabledata);
                  x=[];y=[];
                 end
                 clear data  bw  s imag  num xdat ydat cp xinit yinit hh h1 pgca p 
                 pack
                  
               end
            end
        end
    end

    function ShowTrackerf(s,e)
        ShowT='on';
        set(ShowTracker,'cdata',HideTrackerImage,'TooltipString','Hide Tracker');
    end

    function HideTrackerf(s,e)
        ShowT='off';
        set(ShowTracker,'cdata',ShowTrackerImage,'TooltipString','Show Tracker');
    end

    function playf(s,e)
        sto=0;
        cou=0;
        eachstep = 1/(r-1);
        while 1
            if sto==1
                break;
            end 
            pause(get(ht,'value'));
            if rr==r
                rr=1;
            else
                rr=rr+1;
            end
            cou=cou+1;
            val=(rr-1)*eachstep;
            set(h,'value',val);                
            imag=lsm_image(:,:,rr);
            imshow(imag,map1,'parent',drawf.f1) 
            drawnow
            str=strcat(num2str(rr),'/',num2str(r)); 
            set(nu,'string',str)   
            if count>0
                if strcmp(ShowT,'on')
                    if ishandle(hlabel)
                        delete(hlabel)
                    end
                    ylim=get(dra,'YLim');
                    hlabel=line('XData',[rr,rr],'YData',ylim,'parent',dra);
                else
                    if ishandle(hlabel)
                        delete(hlabel)
                    end                    
                end
            end
        end
    end

    function stopf(s,e)
        sto=1;
    end

    function recover(s,e)
        cla(drawf.f2)
        set(f,'WindowButtondownFcn','')
        set(f,'WindowButtonmotionFcn','')
        set(f,'WindowButtonupFcn','')
        set(f,'Pointer','arrow');
        h4=findobj(f,'tag','h4');
        if ishandle(h4)
           delete(h4) 
        end  
        
    end

    function leftf(s,e)
        if currentflash>1
            set(ROI{currentflash},'color',[0.8,0.4,0])
            set(ROItext(currentflash),'color',[0.8,0.4,0])
            currentflash=currentflash-1;
            set(ROI{currentflash},'color','r')
            set(ROItext(currentflash),'color','r')
            signal=flashsignal(currentflash,:);
            cla(dra)
            plot(dra,signal,'color',[0,1,0],'LineWidth',2) 
            set(dra,'ylim',[min(signal)-10,max(signal)+10],'FontSize',12)
            if currentflash<count
                set(Rightt,'enable','on')
            else
                set(Rightt,'enable','off')
            end 
            if currentflash==1
                set(Leftt,'enable','off')
            end
        else
            set(Leftt,'enable','off')
        end   
    end
    
    function rightf(s,e)
        if currentflash<count
            
            set(ROI{currentflash},'color',[0.8,0.4,0])
            set(ROItext(currentflash),'color',[0.8,0.8,0])
            currentflash=currentflash+1;
            set(ROI{currentflash},'color','r')
            set(ROItext(currentflash),'color','r')            
            
            signal=flashsignal(currentflash,:);
            cla(dra)
            plot(dra,signal,'color',[0,1,0],'LineWidth',2)
            set(dra,'ylim',[min(signal)-10,max(signal)+10],'FontSize',12)
            if currentflash>1
                set(Leftt,'enable','on')
            else
                set(Leftt,'enable','off')
            end
            if currentflash==count
                set(Rightt,'enable','off')
            end            
        else
            set(Rightt,'enable','off')
        end
        
    end

    function deletthis(s,e)
        if count>0
            str=get(findobj(drawf.f4,'color','r'),'string');
            if ~isempty(str)
                str=str2double(str);
                str=str';
                current=1:count;
                current=setdiff(current,str);
                for i=1:length(str)
                    delete(ROI{str(i)});delete(ROItext(str(i)));
                end
                count=count-length(str);
                if count>0
                    
                    ROI=ROI(current);
                    ROItext=ROItext(current);
                    stabledata=stabledata(current,:);
                    ROIpoint=ROIpoint(current);
                    flashsignal=flashsignal(current,:);
                    signalpoint=signalpoint(current);
                    Rise=Rise(current);
                    Down=Down(current);
                    DeltF_F0=DeltF_F0(current);
                    Classf=Classf(current);                    
                    flg=flg(current);
                    
                    if currentflash>count
                        currentflash=1;
                    end
                    for i=1:count
                        set(ROItext(i),'string',num2str(i));
                        stabledata{i,1}=num2str(i);
                    end 
 
                    if currentflash<count
                        
                        set(ROI{currentflash},'color','r')
                        set(ROItext(currentflash),'color','r')
                        signal=flashsignal(currentflash,:);
                        cla(dra)
                        plot(dra,signal,'color',[0,1,0],'LineWidth',2)
                        legend(dra,strcat('ROI: ',get(ROItext(currentflash),'string')))
                        axis(dra,[1,r,min(signal)-10,max(signal)+10])
                        axis(dra,'on')
                        axis(dra,'xy')
                        if ~isempty(signalpoint)
                            point=signalpoint{currentflash};
                            if ~isempty(point.ind)
                                hold on
                                h_R=[];h_P=[];h_D=[];
                                for i=1:length(point.ind)
                                    h_R(i)=line('XData',point.ind(i),'YData',point.pea(i),'Marker','s','color','r','markersize',10,'tag','0','parent',dra);
                                    h_P(i)=line('XData',point.base(i),'YData',point.basepea(i),'Marker','*','color','r','markersize',10,'tag','1','parent',dra);
                                    h_D(i)=line('XData',point.down(i),'YData',point.downpea(i),'Marker','o','color','r','markersize',10,'tag','2','parent',dra);
                                end
                            end
                        end
                        set(tablef,'data',stabledata);
                        
                    else
                        currentflash=1;
                        set(ROI{1},'color','r')
                        set(ROItext(1),'color','r')
                        signal=flashsignal(1,:);
                        
                        cla(dra)
                        plot(dra,signal,'color',[0,1,0],'LineWidth',2)
                        legend(dra,strcat('ROI: ',get(ROItext(currentflash),'string')))
                        axis(dra,[1,r,min(signal)-10,max(signal)+10])
                        axis(dra,'on')
                        axis(dra,'xy')
                        set(tablef,'data',stabledata);
                    end
                else
                    signal=0;
                    count=0;
                    ROIpoint={};
                    
                    stabledata={};
                    currentflash=0;
                    flashsignal=[];% will delete in the future
                    signalpoint={};
                    Rise={};
                    Down={};
                    DeltF_F0={};
                    Classf=[];
                    flashindex=[];
                    flg=[];
                    
                    pf=get(f0,'position');
                    set(dra,'position',[0,pf(4)*1/3,pf(3),pf(4)*2/3]);
                    legend(dra,'off')
                    imag=imread('.\bitmaps\Flash_2.5D.jpg');
                    axis(dra,[0 size(imag,2) 0 size(imag,1)]);
                    axis(dra,'ij');
                    image(imag,'parent',dra)
                    axis(dra, 'off')
                    set(tablef,'data','');
                    cla(drawf.f3)
                    cla(drawf.f4)
                    set(Leftt,'enable','off')
                    set(Rightt,'enable','off')
                end
            end
        end
    end

    function delet(s,e)
        choice = questdlg('Do you detemine to detele all manual ROI?','Delete all manual ROI','Yes','No','No');
        switch choice
            case 'Yes'
                set(Leftt,'enable','off');
                set(Rightt,'enable','off');
                set(ROIselection,'state','off');
                signal=0;
                count=0;
                ROIpoint={};
                
                stabledata={};
                currentflash=0;
                flashsignal=[];% will delete in the future
                signalpoint={};
                Rise={};
                Down={};
                DeltF_F0={};
                Classf=[];
                flashindex=[];
                flg=[];
                
                cla(drawf.f3)
                cla(drawf.f4)
                cla(dra)
                legend(dra,'off')
                pf=get(f0,'position');
                set(dra,'position',[0,pf(4)*1/3,pf(3),pf(4)*2/3]);
                
                imag=imread('.\bitmaps\Flash_2.5D.jpg');
                axis(dra,[0 size(imag,2) 0 size(imag,1)]);
                axis(dra,'ij');
                image(imag,'parent',dra)
                axis(dra, 'off')
                
                set(tablef,'data',{});
            case 'No'
                return
        end
    end
    
    function hideon(s,e)
        for i=1:count
            set(ROItext(i),'visible','off');
        end
        set(hidef,'CData',hider)
    end

    function hideoff(s,e)
        for i=1:count
            set(ROItext(i),'visible','on');
        end
        set(hidef,'CData',hide)
    end

    function hideROIon(s,e)
        for i=1:count
            set(ROItext(i),'visible','off');
        end 
        for i=1:count
            set(ROI{i},'visible','off');
        end
        set(hideROIf,'CData',hideROIr)
    end

    function hideROIoff(s,e)
        if strcmp(get(hidef,'state'),'off')
            for i=1:count
                set(ROItext(i),'visible','on');
            end 
        end
        for i=1:count
            set(ROI{i},'visible','on');
        end
        set(hideROIf,'CData',hideROI)
    end

    function ROIselectionf(s,e)
        set(Rectanglt,'state','off')
        set(Segpolyt,'state','off')    
        if count>0
            set(f,'WindowButtonMotionFcn',@cb2c);
        end
        set(f,'WindowButtonDownFcn',@downff);
    end

    function downff(s,e)    
        
        if strcmp(get(f,'SelectionType'),'normal')
            cp = get(drawf.f3,'CurrentPoint');
            xinit = cp(1,1);yinit = cp(1,2);
            str1=get(findobj(drawf.f4,'color','r'),'string');
            h1 = line('XData',xinit,'YData',yinit,'color','w','LineStyle',':','parent',drawf.f2);
            h2 = line('XData',xinit,'YData',yinit,'color','w','LineStyle',':','parent',drawf.f2);
            h3 = line('XData',xinit,'YData',yinit,'color','w','LineStyle',':','parent',drawf.f2);
            h4 = line('XData',xinit,'YData',yinit,'color','w','LineStyle',':','parent',drawf.f2);

            set(f,'WindowButtonMotionFcn',@cb2c1);
            set(f,'WindowButtonUpFcn',@cb2cup);
            
        else   
            set(f,'WindowButtonMotionFcn','');
            set(f,'WindowButtonUpFcn','');   
            
        end
        function cb2c1(s,e)
            
            cp = get(drawf.f3,'CurrentPoint');
            xdat = cp(1,1);
            ydat = cp(1,2);
            
            if xdat~=xinit&&ydat~=yinit
                x1dat=[xinit,xdat];y1dat=[yinit,yinit];
                x2dat=[xinit,xinit];y2dat=[yinit,ydat];
                x3dat=[xinit,xdat];y3dat=[ydat,ydat];
                x4dat=[xdat,xdat];y4dat=[yinit,ydat];
                set(h1,'XData',x1dat,'YData',y1dat);
                set(h2,'XData',x2dat,'YData',y2dat);
                set(h3,'XData',x3dat,'YData',y3dat);
                set(h4,'XData',x4dat,'YData',y4dat);
                x=[xinit,xdat,xdat,xinit];
                y=[yinit,yinit,ydat,ydat];
                for i=1:count
                    IN=inpolygon(ROIpoint{i}.x,ROIpoint{i}.y,x,y);
                    if ~isempty(find(IN==1))
                        set(ROI{i},'color','r');
                        set(ROItext(i),'color','r');
                    else
                        set(ROI{i},'color',[0.8,0.4,0]);
                        set(ROItext(i),'color',[0.8,0.8,0]);
                    end
                end
            end
            drawnow
        end                    
        function cb2cup(s,e)
            if count==0
                set(f,'WindowButtonMotionFcn','');
                set(f,'WindowButtonDownFcn',@downff);
            else
                set(f,'WindowButtonMotionFcn',@cb2c);
                set(f,'WindowButtonDownFcn',@downff);
            end
            
            if ishandle(h1)
                x=get(h1,'XData');
                y=get(h2,'YData');
                if length(x)>1
                    if x(1)~=x(2)
                        x=[x(1),x(2),x(2),x(1)];
                        y=[y(1),y(1),y(2),y(2)];
                        str=get(findobj(drawf.f4,'color','r'),'string');
                        if isempty(str)
                            if ~isempty(str)
                                str1=str2double(str1);
                                str1=str1';
                                for j=1:length(str1)
                                    set(ROI{str1(j)},'color','r');
                                    set(ROItext(str1(j)),'color','r');
                                end
                            end
                        end
                    end
                end
                delete(h1)
                delete(h2)
                delete(h3)
                delete(h4)
            end
            
            clear str str1 x y  h3 h4 i j jj jjj a x1dat x2dat x3dat x4dat y1dat y2dat y3dat y4dat
        end
    end  
    function cb2c(s,e)
        ggca=get(drawf.f3,'currentpoint');

        for i=1:count
            IN=inpolygon(ggca(1,1),ggca(1,2),ROIpoint{i}.x,ROIpoint{i}.y);
            if IN(1)
                set(f,'Pointer','hand')
                set(f,'windowbuttondownfcn',@down)
                return
            else
                set(f,'Pointer','arrow')
                set(f,'windowbuttondownfcn',@downff)
            end
            
        end
        function down(s,e)
            for jj=1:count
                set(ROI{jj},'color',[0.8,0.4,0]);
                set(ROItext(jj),'color',[0.8,0.8,0]);
            end
            currentflash=i;
            if currentflash==1
                set(Leftt,'enable','off');set(Rightt,'enable','on');
            elseif currentflash==count
                set(Rightt,'enable','off');set(Leftt,'enable','on');
            else
                set(Leftt,'enable','on');set(Rightt,'enable','on');
            end
            set(ROI{i},'color','r');
            set(ROItext(i),'color','r');
            signal=flashsignal(i,:);
            pf=get(f0,'position');
            set(dra,'OuterPosition',[0,pf(4)*1/3,pf(3),pf(4)*2/3])
            clear pf
            cla(dra)
            
            plot(dra,signal,'color',[0,1,0],'LineWidth',2)
            legend(dra,strcat('ROI: ',get(ROItext(currentflash),'string')))
            axis(dra,[1,r,min(signal)-10,max(signal)+10])
            axis(dra,'on')
            axis(dra,'xy')
            
            clear s iii  x1 y1 x2 y2 point1 pF
            pack
        end     
    end    

    function save_movie(s,e)
        name=Filename(1:end-4);
        [filename, pathname] = uiputfile( {'*.gif';'*.avi'},'Save as',name);
        str1=[pathname,filename];
        [~, ~, ext] = fileparts(filename);
        if filename
            if strcmp(ext,'.gif')
                save_movie_gif
            elseif strcmp(ext, '.avi')
                Save_movie_Avi
            end
        end
                     
        %save movie
        function save_movie_gif(s,e)
            cou=0;
            eachstep = 1/(r-1);
            while cou<r
                cou=cou+1;
                val=(r-cou)*eachstep;
                set(h,'value',val);                
                imag=lsm_image(:,:,cou);
                imshow(imag,map1,'parent',drawf.f1) 
                drawnow
                st2=strcat(num2str(cou),'/',num2str(r)); 
                set(nu,'string',st2)
                clear st2
                if count>0
                    if ishandle(hlabel)
                        delete(hlabel)
                    end
                    ylim=get(dra,'YLim');
                    hlabel=line('XData',[cou,cou],'YData',ylim,'parent',dra);
                    drawnow
                end

                frame= getframe(drawf.f1);
                imind=frame2im(frame);
                [imind,cm] = rgb2ind(imind,256);
                if  cou==1
                imwrite(imind,cm,str1,'gif', 'Loopcount',inf,'DelayTime',0);
                else
                imwrite(imind,cm,str1,'gif',...
                'WriteMode','append','DelayTime',0);
                end            
            end
            clear cou imind cm frame  ylim str1 val  imag filename 
            pack
        end
   
        function Save_movie_Avi(s,e)
                cou=0;
                eachstep = 1/(r-1);
                aviobj=avifile(str1,'fps',10);
                while cou<r
                    cou=cou+1;
                    val=(r-cou)*eachstep;
                    set(h,'value',val);                
                    imag=lsm_image(:,:,cou);
                    imshow(imag,map1,'parent',drawf.f1) 
                    drawnow
                    str=strcat(num2str(cou),'/',num2str(r)); 
                    set(nu,'string',str)
                    if count>0
                        if ishandle(hlabel)
                            delete(hlabel)
                        end
                        ylim=get(dra,'YLim');
                        hlabel=line('XData',[cou,cou],'YData',ylim,'parent',dra);
                        drownow
                    end 
                        frame=getframe(drawf.f1); 
                        aviobj=addframe(aviobj,frame);      
                end
                aviobj=close(aviobj);
                clear cou frame aviobj   ylim str val  imag filename str1
                pack
        end
    end

    function statusf(s,e)
        [filename, pathname] = uiputfile( {'*.mat'},'Save status as',Filename);
        clear pathstr ext
        pack
        if filename  
            name=filename(1:end-4);
            status.tag='Flash';
            status.filename=name;
            status.xy=xy;
            status.count=count;
            status.currentflash=currentflash;
            status.flashsignal=flashsignal;
            status.image=lsm_image;
            status.map=map1;
            status.stabledata=stabledata;
            status.ROIpoint=ROIpoint;
            status.Rise=Rise;
            status.Down=Down;
            status.DeltF_F0=DeltF_F0;
            status.Classf=Classf;
            status.flashindex=flashindex;
            status.flg=flg;
            status.signalpoint=signalpoint;
            save(strcat(pathname,Filename,'.mat'), 'status')
            clear filename pathname
            pack
            close(gcf)
        end
    end

    function framedeletef(s,e)
        choice = questdlg('Do you detemine to detele frame?', ...
        'Delete bad frame', ...
        'Yes','No','Yes');
        switch choice
            case 'Yes'
                if r<1
                    errordlg('Image data not found','Error');
                else
                    if r<2
                        errordlg('This is no image data','Error');
                    else         
                        current=1:r;
                        current=setdiff(current,rr);
                        lsm_image=lsm_image(:,:,current);
                        rr=1;
                        r=r-1;
                        eachstep=[1/(r-1),1/(r-1)];
                        set(h,'sliderstep',eachstep);
                        set(h,'value',1);
                        str=strcat(num2str(rr),'/',num2str(r)); 
                        set(nu,'string',str)
                    end
                end
            case 'No'
                return
        end
    end

    function areacacul(s,e)
        
        f3=figure('Visible','on','Menubar','none','Toolbar','none','Units', 'Pixel','Position',[400,100,col,row+40],'resize','off','numbertitle','off'...
        ,'color',[0.94,0.94,0.94],'name','Cell area caculation');
        SetIcon(f3);
        draw=axes('parent',f3,'units','pixel','position',[0,40,col,row],'xtick',[],'ytick',[],'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94]);
        draw1=axes('parent',f3,'units','pixel','position',[0,40,col,row],'xtick',[],'ytick',[],'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94]);
        set(draw1,'Xlim',[1,c1],'Ylim',[1,r1])
        set(draw1,'color','none')
        axis ij
        imag=lsm_image(:,:,rr);
%         imag=imresize(imag,0.5); 
        map=[[0,zeros(1,255)]',(0:255)'/256,zeros(256,1)];
        imshow(imag,map,'parent',draw)
        hs = uicontrol(f3,'style', 'slider','Units','pixel','Position',[5,13,col*1/3,15],'min',0,'max',0.5,'sliderstep',[0.01,0.01],'value',0,'BackgroundColor',[1 1 1],'callback',@cb);
        hs1 = uicontrol(f3,'style', 'slider','Units','pixel','Position',[col*1/3+170,13,col*1/3-30,15],'min',3,'max',20,'sliderstep',[0.01,0.01],'value',3,'BackgroundColor',[1 1 1]);
        h4 = uicontrol('Style', 'pushbutton', 'String', 'Erase','position',[col*1/3+10,8,37,25],'callback',@wb);
        h5 = uicontrol('Style', 'pushbutton', 'String', 'Delete','position',[col*1/3+47,8,37,25],'callback',@deletebad);
        h2 = uicontrol('Style', 'pushbutton', 'String', 'Done','position',[col*1/3+84,8,37,25],'callback',@done);
        h3 = uicontrol('Style', 'pushbutton', 'String', 'Cancel','position',[col*1/3+121,8,37,25],'callback',@cancel);
        
        hp2=rectangle('Position',[1,1,1,1],'FaceColor',[1,1,0],'visible','off','parent',draw1);
        set(f3,'CloseRequestFcn',@closefcn)
        uni=false(row,col);
        movegui(f3,'center');
        function closefcn(s,e)
            
            delete(f3)
            clear h2 h3 h4 draw imag
            
        end
          
        function cb(s,e)
%             cla(draw1)
            lastVal = get(hs, 'Value');
            if lastVal>0
                imag=lsm_image(:,:,rr);
%                 imag=imresize(imag,0.5);                
                bw=im2bw(imag,lastVal); 
                bw=bwmorph(bw,'clean');
%                 bw=bwmorph(bw,'open');
                [A,num]=bwlabel(bw);
                STATS=regionprops(bw,'Area'); 
                for i=1:num
                    c=STATS(i).Area;    
                    if c<20
                        bw(A==i)=false;
                    end
                end                  
                bw=uint8(bw);
                imag=imag.*bw; 
                uni(imag==0)=1;
                imshow(imag,map,'parent',draw)
            end
        end  
        
        function wb(s,e)
            
            P=ones(16);
            P(1:16,1:16)=NaN;
            
            pp=get(draw1,'position');
            set(f3,'windowbuttonmotionfcn',@cb2)
            function cb2(s,e)
                
                if ishandle(hp2)
                    set(hp2,'visible','on')
                    delete(hp2)
                end
                p1=get(f3,'currentpoint');
                if p1(1,1)>pp(1)&&p1(1,1)<pp(1)+pp(3)&&p1(1,2)>pp(2)&&p1(1,2)<pp(2)+pp(4)
                    set(f3,'pointer', 'custom', 'PointerShapeCData',P,'PointerShapeHotSpot',[8,8])
                    p2=get(draw1,'currentpoint');
                    x=[p2(1,1)-get(hs1,'value'),p2(1,1)+get(hs1,'value')];
                    x=floor(x);
                    y=[p2(1,2)-get(hs1,'value'),p2(1,2)+get(hs1,'value')];
                    y=floor(y);
                    
                    x=[max(x(1),1),min(x(2),col)];
                    y=[max(y(1),1),min(y(2),row)];
                    hp2=rectangle('Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)],'FaceColor',[1,1,0],'parent',draw1);
                    set(f3,'windowbuttondownfcn',@dw)            
                else
                    cla(draw1)
                    set(f3,'Pointer','arrow')
                end

                function dw(s,e) 
                    
                    p2=get(draw1,'currentpoint');
                    x=[p2(1,1)-get(hs1,'value'),p2(1,1)+get(hs1,'value')];
                    x=floor(x);
                    y=[p2(1,2)-get(hs1,'value'),p2(1,2)+get(hs1,'value')];
                    y=floor(y);
                    
                    x=[max(x(1),1),min(x(2),col)];
                    y=[max(y(1),1),min(y(2),row)];
                    hp1=rectangle('Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)],'FaceColor',[0,0,0],'parent',draw);
                    uni(x(1):x(2),y(1):y(2))=1;
                    set(f3,'windowbuttonmotionfcn',@wb1)
                    
                    function wb1(s,e)
                        
                        if ishandle(hp2)
                            set(hp2,'visible','on')
                            delete(hp2)
                        end
                        p1=get(f3,'currentpoint');
                        
                        if p1(1,1)>pp(1)&&p1(1,1)<pp(1)+pp(3)&&p1(1,2)>pp(2)&&p1(1,2)<pp(2)+pp(4)
                            set(f3,'pointer', 'custom', 'PointerShapeCData',P,'PointerShapeHotSpot',[8,8])
                            p2=get(draw1,'currentpoint');
                            x=[p2(1,1)-get(hs1,'value'),p2(1,1)+get(hs1,'value')];
                            x=floor(x);
                            y=[p2(1,2)-get(hs1,'value'),p2(1,2)+get(hs1,'value')];
                            y=floor(y);

                            x=[max(x(1),1),min(x(2),col)];
                            y=[max(y(1),1),min(y(2),row)];

                            hp1=rectangle('Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)],'FaceColor',[0,0,0],'parent',draw);
                            hp2=rectangle('Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)],'FaceColor',[1,1,0],'parent',draw1);
                            uni(x(1):x(2),y(1):y(2))=1;
                            set(f3,'windowbuttonupfcn',@up1)                              
                        else
                            set(f3,'Pointer','arrow')
                            cla(draw1)
                            
                        end                        
                        function up1(s,e)
                            set(f3,'windowbuttonmotionfcn',@cb2) 
                        end
                    end
                end                                                   
            end            
        end             
        
        function deletebad(s,e)
            bw=getframe(gca);
            bw=bw.cdata;
            bw=imresize(bw,[r1,c1]);
            imag=bw(:,:,2);
            bw=logical(imag);
            [x,y]=getpts(draw);
            x=floor(x);
            y=floor(y);
            
            bw=bwselect(bw,x,y,4);
            imag=imag-imag.*uint8(bw);
            cla(draw)
            map=[[0,zeros(1,255)]',(0:255)'/256,zeros(256,1)];
            imshow(imag,map,'parent',draw)
            
        end
        
        function done(s,e)
            set(f,'windowbuttonmotionfcn',@motion)
            bw=getframe(draw);
            bw=bw.cdata;
            bw=imresize(bw,[r1,c1]);
            bw=rgb2gray(bw);
            bw=logical(bw);
            mitoarea=length(find(bw==1));
            stabledata{1,14}=num2str(mitoarea*xy.VoxelSizeX*xy.VoxelSizeY*10^12);
            if count
                for i=1:count
                    stabledata{i,5}=num2str(str2double(stabledata{i,4})/(mitoarea*xy.VoxelSizeX*xy.VoxelSizeY*10^12));
                end
            end
            set(tablef,'data',stabledata);  
            delete(f3)
            
            clear bw bw1 imag map image hs bw f3 h2 h3 f3 hs  x y p2 uni mitoarea hp1 hp2 P pp h2 h3 h4  
            clear draw draw1
        end
        
        function cancel(s,e)
            
            set(f,'windowbuttonmotionfcn',@motion)            
            delete(f3)
            
            clear bw bw1 imag map image hs bw f3 hs   x y p2 uni mitoarea hp1 hp2 P pp h2 h3 h4 
            clear draw draw1
        end       
    end

    function ResizeFcnf(s,e) 
        
        fP = get(f, 'Position');              
        SetPosition(f,drawf.f1,drawf.f2,drawf.f3,drawf.f4,drawf.f5,panel1,panel11,panel12,panel13,panel14,h,row,col); 
        h4=findobj(f,'tag','h4');
%         h2=findobj(f,'tag','h2');
%         h3=findobj(f,'tag','h3');
%         h6=findobj(f,'tag','h6');
        
        if ishandle(h4)
%             [150 10 col-290-20 10]
            set(h4,'position',[150,10,fP(3)-320,10])
%             set(h2,'position',[col*1/3+100,fP(4)-row-34,37,25])
%             set(h3,'position',[col*1/3+137,fP(4)-row-34,37,25])
%             set(h6,'position',[col*1/3+174,fP(4)-row-34,37,25])
        end
%         h22=findobj(f,'tag','h22');
%         h33=findobj(f,'tag','h33');
%         if ishandle(h22)
%             set(h22,'position',[col*1/3+50,fP(4)-row-34,60,25])
%             set(h33,'position',[col*1/3+137,fP(4)-row-34,60,25])
%         end
    end

    function closereq(s,e)
        count=0;
        currentflash=0;
        set(f0,'windowbuttonmotionfcn','')
        set(f0,'windowbuttonupfcn','')
        pf=get(f0,'position');
        set(dra,'position',[0,pf(4)*1/3,pf(3),pf(4)*2/3]);
        legend(dra,'off')
        set(findobj('tag','Select','parent',f0),'state','off')
        imag=imread('.\bitmaps\Flash_2.5D.jpg');
        axis(dra,[0 size(imag,2) 0 size(imag,1)]);
        axis(dra,'ij');        
        image(imag,'parent',dra)
        axis(dra,'off')
        stabledata={};
        set(tablef,'data',stabledata)

        delete(gcf)
        delete('lsm_image.mat')
        clear dara pf imag
        clear dra lsm_image map1 Playt ROIselection drawf.f1 drawf.f2 drawf.f3 drawf.f4 Leftt Rightt map right left Analysist r1 c1 imag h stabledata ROI ROItext
        clear icasig icasig1 icasig2 ROI ROItext th th1
        clear info hnoname auto panel1 panel11 panel12 panel13 panel21 panel22 panel23
        clear flashindex Rtime PeakA F0 deltF halfA halfT flg hlabelR hlabelP r 
        clear f sto rr Line Linetext Linecount Val1 Val2 fittingROI fittingcount ss stat parameters
        clc
        pack
    end
    %image registration

    function autof(s,e)
        set(htime,'string','Busy')
        legend(dra,'off')
        axis(dra,'off')
        flashsignal=[];
        ROI={};
        ROItext=[];
        ROIpoint={};
        stabledata={};
        count=0;
        currentflash=0;
        signalpoint={};
        Rise={};
        Down={};

        Classf=[];
        flashindex=[];
       
        cla(drawf.f3)
        cla(drawf.f4);
        
        set(tablef,'data',{});
        cla(dra)
        set(tablef,'data',{});
        pause(0.1)
        [ROIpoint,stabledata,count,flashsignal]=autoff(ROIpoint,stabledata,lsm_image,r,r1,c1,count,flashsignal);
        if count
            for i=1:count
                point=ROIpoint{i};
                xx=point.x;yy=point.y;   
                hh=line('XData',xx,'YData', yy,'color',[0.8,0.4,0],'LineWidth',1,'parent',drawf.f3);
                h5=text(mean(xx),mean(yy),num2str(i),'Parent',drawf.f4);
                set(h5,'color',[0.8,0.8,0],'HorizontalAlignment','center')
                ROItext(i)=h5;             
                ROI{i}=hh;
            end
        end
        currentflash=count;

        set(tablef,'data',stabledata);
        
        if count>1
            set(Leftt,'enable','on');
            set(Rightt,'enable','off');
        elseif count==1
            set(Leftt,'enable','off');
            set(Rightt,'enable','off');
        end
        signal=flashsignal(currentflash,:);
        pf=get(f0,'position');
        set(dra,'OuterPosition',[0,pf(4)*1/3,pf(3),pf(4)*2/3])
        clear pf
        cla(dra)
        plot(dra,signal,'color',[0,1,0],'LineWidth',2)
        axis(dra,[1,r,min(signal)-10,max(signal)+10])
        axis(dra,'on')
        axis(dra,'xy')
        
        status=get(hidef,'state');
        if strcmp(status,'on')
            for i=1:count
                set(ROItext(i),'visible','off')
            end
        end
        
        status=get(hideROIf,'state');
        if strcmp(status,'on')
            for i=1:count
                set(ROItext(i),'visible','off')
                set(ROI{i},'visible','off')
            end
        end
        
        set(htime,'string','Ready')
        pack 
    end

    function sortf(s,e)
        count=length(ROI);
        if count>0
            currentflash=1;
            x=zeros(1,count);
            for i=1:count
                xyx=ROIpoint{i};
                x(i)=mean(xyx.x);
            end
            [x,ind]=sort(x);
            flashsignal=flashsignal(ind,:);
            ROIpoint=ROIpoint(ind);
            ROItext=ROItext(ind);
            ROI=ROI(ind);
            stabledata=stabledata(ind,:);
            if ~isempty(signalpointR)
                signalpoint=signalpoint(ind);
                flashindex=flashindex(ind);                
                flg=flg(ind);
            end
            
            for i=1:count
                set(ROItext(i),'string',num2str(i),'color',[0.8,0.8,0])
                set(ROI{i},'color',[0.8,0.4,0])
                stabledata{i,1}=num2str(i);
            end
            currentflash=1;
            set(ROI{1},'color',[1,0,0])
            set(ROItext(1),'color',[1,0,0])
            set(tablef,'data',stabledata); 
            pf=get(f0,'position');
            set(dra,'OuterPosition',[0,pf(4)*1/3,pf(3),pf(4)*2/3])
            clear pf    
            cla(dra)
            plot(dra,signal,'color',[0,1,0],'LineWidth',2)  
            axis(dra,[1,r,min(signal)-10,max(signal)+10])
            axis(dra,'on')
            axis(dra,'xy')
            legend(dra,strcat('ROI: ',num2str(currentflash)));
        end    
    end

    function autoROIfp(s,e) 
        
        clear si STATS num bm1 num im a m1  i s k1 xx yy point num data pF s iii ii k ss sss bw  x y m B iii boundary status ind pea nos
        clear  stablef  sig sig1 sig2 im mp sk me  areaf j status 
        clear jj j done1 done2 n1 n2 sss ss s pea ind rise base bw analysisvalue1 b1 spmax spmin flag b2 im num b c l tt dd n half 
        pack        
        set(f,'windowbuttonmotionfcn',@wb)
        h4=findobj(f,'tag','h4');
        h2=findobj(f,'tag','h2');
        h3=findobj(f,'tag','h3');
        h6=findobj(f,'tag','h6');
     
        if ishandle(h4)
           delete(h4) 
        end
        if ishandle(h2)
           delete(h2) 
        end
        if ishandle(h3)
           delete(h3) 
        end
        if ishandle(h6)
           delete(h6) 
        end
        
        fP=get(f,'position');
        h4 = uicontrol('parent',panel1,'style', 'slider','Units', 'Pixel','position', [150,10,fP(3)-320,10],'min',20,'max',60,'value',40,'BackgroundColor',[1 1 1],'tag','h4');
        
        function wb(s,e)
            
            pp=get(drawf.f1,'currentpoint');
            cla(drawf.f2)
            
            hp1=line('XData',[pp(1,1)-get(h4,'value'),pp(1,1)+get(h4,'value')],'YData',[pp(1,2)+get(h4,'value'),pp(1,2)+get(h4,'value')],'color','r','parent',drawf.f2);
            hp2=line('XData',[pp(1,1)+get(h4,'value'),pp(1,1)+get(h4,'value')],'YData',[pp(1,2)-get(h4,'value'),pp(1,2)+get(h4,'value')],'color','r','parent',drawf.f2);
            hp3=line('XData',[pp(1,1)-get(h4,'value'),pp(1,1)+get(h4,'value')],'YData',[pp(1,2)-get(h4,'value'),pp(1,2)-get(h4,'value')],'color','r','parent',drawf.f2);
            hp4=line('XData',[pp(1,1)-get(h4,'value'),pp(1,1)-get(h4,'value')],'YData',[pp(1,2)-get(h4,'value'),pp(1,2)+get(h4,'value')],'color','r','parent',drawf.f2);
            
            set(f,'windowbuttondownfcn',@db1)
            
            function db1(s,e)
                x=get(hp1,'XData');
                x=floor(x);
                y=get(hp2,'YData');
                y=floor(y);
                x=[max(x(1),1),min(x(2),c1)];
                y=[max(y(1),1),min(y(2),r1)];
                lsm=uint8(zeros(y(2)-y(1)+1,x(2)-x(1)+1,r));
                for i=1:r
                    lsm(:,:,i)=lsm_image(y(1):y(2),x(1):x(2),i);
                end

                set(f,'windowbuttonupfcn',@up1)
                
                function  up1(s,e)
                    
                    set(htime,'string','Busy')
                    axis(dra,'off')
                    legend(dra,'off')
                    countcopy=count;

                    [ROIpoint,stabledata,count,flashsignal]=autoffP(ROIpoint,stabledata,lsm,lsm_image,r,row,col,x,y,count,flashsignal);
                    if count>countcopy
                        
                        for i=countcopy+1:count
                            point=ROIpoint{i};
                            xx=point.x;yy=point.y;
                            hh=line('XData',xx,'YData', yy,'color',[0.8,0.4,0],'LineWidth',1,'parent',drawf.f3);
                            h5=text(mean(xx),mean(yy),num2str(i),'Parent',drawf.f4);
                            set(h5,'color',[0.8,0.8,0],'HorizontalAlignment','center')
                            ROItext(i)=h5;             
                            ROI{i}=hh;
                        end
                        
                        if countcopy>0
                            set(ROItext(currentflash),'color',[0.8,0.8,0])
                            set(ROI{currentflash},'color',[0.8,0.4,0])
                        end
                        
                        currentflash=count;
                        set(ROItext(currentflash),'color','r')
                        set(ROI{currentflash},'color','r')
                        
                        if count>1
                            set(Leftt,'enable','on');
                            set(Rightt,'enable','off');
                        elseif count==1
                            set(Leftt,'enable','off');
                            set(Rightt,'enable','off');
                        end
                        
                        set(tablef,'data',stabledata);
                        signal=flashsignal(currentflash,:);
                        pf=get(f0,'position');
                        set(dra,'OuterPosition',[0,pf(4)*1/3,pf(3),pf(4)*2/3])
                        clear pf
                        cla(dra)
                        plot(dra,signal,'color',[0,1,0],'LineWidth',2)
                        axis(dra,[1,r,min(signal)-10,max(signal)+10])
                        axis(dra,'on')
                        axis(dra,'xy')
                        legend(dra,strcat('ROI: ',num2str(currentflash)))
                        
                        status=get(hidef,'state');
                        if strcmp(status,'on')
                            for i=1:count
                                set(ROItext(i),'visible','off')
                            end
                        end
                        
                        status=get(hideROIf,'state');
                        
                        if strcmp(status,'on')
                            for i=1:count
                                set(ROItext(i),'visible','off')
                                set(ROI{i},'visible','off')
                            end
                        end
                        
                    end
                    
%                     axis(dra,'on')
%                     axis(dra,'xy')
%                     clear si STATS num bm1 num im a m1  i s k1 xx yy point num data pF s iii ii k  sss bw   m B iii boundary status ind pea nos
%                     clear jj j done1 done2 n1 n2 sss ss s pea ind rise base bw analysisvalue1 b1 spmax spmin flag b2 im num b c l tt dd n half ss1
%                     pack
                    set(htime,'string','Ready')
                    set(f,'windowbuttondownfcn',@db)
                end
            end
        end
    end

    function keyf(s,e)
        d = e.Key;
        switch d
            case 'leftarrow'
                leftf(s,e);
            case 'rightarrow'
                rightf(s,e);
            case 'delete'
                deletthis(s,e);
        end
    end

end


