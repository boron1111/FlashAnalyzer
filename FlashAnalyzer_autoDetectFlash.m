% 这一版里面的ROIInfo是使用自动检测程序自动生成的
function FlashAnalyzer(varargin)
    % ROI是画出的ROI的线的句柄，ROIpoint是flash的参数和围成ROI的点，ROItext是标记ROI的数字的句柄，flashsignal是ROI的时间序列均值
    % drawf是图片显示的各层axes的句柄
    global newpath1 f0 th Datacursort panel12 panel112 listboxtemp Play Stop Mergebutton ShowTrackerImage Show_mean...
        HideTrackerImage ShowTracker drawline hide hider hidef hideROI hideROIr hideROIf Rectanglt Segpolyt AutoROIp...
        Leftt Rightt ROIselection listbox drawf trace slider threshold ptext statush timeh sliderB sliderC...
        BCdata bits panel111 mapAll TraceColor channelcheckbox Time Pathname Filename newpathsavestatus...
        newpathload_status xy info r rr rrchannel lastVal lastVal1 count currentflash ROI ROItext ROIpoint flg...
        flashsignal signalpoint lsmdata lsm_image signal hlabel stabledata ROIInfo flashThresh...
        drawlinearray drawlinetextarray drawlinecount sto row col zstack h_R h_P h_D channel info_extend
    if ~isempty(varargin)
        if length(varargin)>1
            feval(varargin{1},varargin{2:end});
        else
            feval(varargin{1});
        end
    else
        clc
        if ishandle(f0);return;end
        newpath1='';
        f0 = figure('Visible','on','Menubar','none','Toolbar','none','Units','Normalized','Position',[0,0,1,0.95],'numbertitle','off','resize','on');
        set(f0,'name','Superoxide Flashes Detector','tag','figure1','color',[0.94,0.94,0.94])
        warning off all;
        SetIcon(f0);
        th = uitoolbar(f0);

        Datacursort= uitoggletool(th,'CData',imread('.\bitmaps\data_cursor.bmp'),'TooltipString','Data_cursor','HandleVisibility','on');
        set(Datacursort,'OnCallback',@datacursoron)
        set(Datacursort,'OffCallback',@datacursoroff)

        Show_mean=uitoggletool(th,'cdata',imread('.\bitmaps\show_mean.bmp'),'tooltipstring','show mean image','handlevisibility','on');
        set(Show_mean,'OnCallback',@showMeanImage);

        uipushtool(th,'cdata',imread('.\bitmaps\show_trace.bmp'),'tooltipstring','show trace','clickedcallback',@showTrace);
        uipushtool(th,'cdata',imread('.\bitmaps\Merge.bmp'),'tooltipstring','MergeAll','clickedcallback',@MergeAll);
        uipushtool(th,'cdata',imread('.\bitmaps\universal.bmp'),'tooltipstring','universal','clickedcallback',@universal);

        %     panel1左侧主面板
        panel1=uipanel(f0,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[0 0 0.6 1]);

        panel11=uipanel(panel1,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[0 0 1 0.15]);
        panel12=uipanel(panel1,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[0 0.15 1 0.85]);
        panel111=uipanel(panel11,'Title','','FontSize',12,'BackgroundColor','white','units','Normalized','Position',[0 0 0.4 1]);
        panel1111=uipanel(panel111,'Title','','FontSize',12,'BackgroundColor','white','units','Normalized','Position',[0 0.2 1 0.6]);

        panel112=uipanel(panel11,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[0.4 0 0.6 1]);
        panel1121=uipanel(panel112,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[0 0.2 1 0.6]); 


         %     panel_right右侧主面板
        panel_right=uipanel(f0,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[0.6 0 0.4 1]);

        %     panel_right_down是显示flash trace及按钮的面板    
        panel_right_down=uipanel(panel_right,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[0 0 1 1/3]);   
        panel_flashTrace=uipanel(panel_right_down,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[0 1/4 1 3/4]);
        %     panel_right_button是显示按钮的面板
        panel_right_button=uipanel(panel_right_down,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[0 0 1 1/4]);

        %     panel_right_up是显示flashTrace list和file list的面板
        panel_right_up=uipanel(panel_right,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[0 1/3 1 2/3]); 

        %   panel_fileList是显示文件列表的面板
        panel_fileList=uipanel(panel_right_up,'Title','','FontSize',12,'BackgroundColor','white','bordertype','etchedin','units','Normalized','Position',[1/8 0 7/8 1]);

        %   显示flash list的容器    
        listboxtemp=uicontrol(panel_right_up,'style','listbox','units','Normalized','position',[0,0,1/8,1],'callback',@Table_Selection);

        Save_Movie= uicontrol(panel1111,'style','pushbutton','CData',imread('.\bitmaps\movie.bmp'),'units','Normalized','position',[0,1/2,1/10,1/2],'TooltipString','Save movie','HandleVisibility','off');
        set(Save_Movie,'Callback',@save_movie,'BusyAction','cancel')

        Savepng= uicontrol(panel1111,'style','pushbutton','CData',imread('.\bitmaps\area.bmp'),'units','Normalized','position',[1/10,1/2,1/10,1/2],'TooltipString','Save current figure','HandleVisibility','off');
        set(Savepng,'Callback',@savePng,'BusyAction','cancel')

        Play=imread('.\bitmaps\play.bmp');
        Stop=imread('.\bitmaps\pause.bmp');
        uicontrol(panel1111,'style','togglebutton','CData',Play,'units','Normalized','position',[2/10,1/2,1/10,1/2],'TooltipString','Play','callback',@Playf);

        Mergebutton=uicontrol(panel1111,'style','togglebutton','CData',imread('.\bitmaps\merge.bmp'),'units','Normalized','position',[3/10,1/2,1/10,1/2],'TooltipString','Merge','callback',@adjustBC); 

        [ShowTrackerImage,map]=imread('.\bitmaps\switch_up.bmp');
        ShowTrackerImage=ind2rgb(ShowTrackerImage,map);
        [HideTrackerImage,map]=imread('.\bitmaps\switch_down.bmp');
        HideTrackerImage=ind2rgb(HideTrackerImage,map);
        ShowTracker= uicontrol(panel1111,'style','togglebutton','CData',ShowTrackerImage,'units','Normalized','position',[4/10,1/2,1/10,1/2],'TooltipString','Show Tracker','HandleVisibility','off');
        set(ShowTracker,'Callback',{@ShowTrackerf})

        [framedelete,~]=imread('.\bitmaps\deletebad.bmp');
        framedelete= uicontrol(panel1111,'style','pushbutton','CData',framedelete,'units','Normalized','position',[5/10,1/2,1/10,1/2],'TooltipString','Delete bad frame','HandleVisibility','off');
        set(framedelete,'Callback',@framedeletef,'BusyAction','cancel') 

        [drawline,map]=imread('.\bitmaps\line.bmp');
        drawline=ind2rgb(drawline,map);
        drawline=uicontrol(panel1111,'style','pushbutton','CData',drawline,'units','Normalized','position',[6/10,1/2,1/10,1/2],'TooltipString','Draw line','HandleVisibility','on');
        set(drawline,'Callback',@drawlinef)

        [deleteline,map]=imread('.\bitmaps\linedelete.bmp');
        deleteline=ind2rgb(deleteline,map);
        uicontrol(panel1111,'style','pushbutton','units','Normalized','position',[7/10,1/2,1/10,1/2],'TooltipString','Delete line','CData',deleteline,'visible','on','enable','on','Callback',@deletelinef);

        [hide,map]=imread('.\bitmaps\HideLabel.bmp');
        hide=ind2rgb(hide,map);
        [hider,map]=imread('.\bitmaps\text.bmp');
        hider=ind2rgb(hider,map);
        hidef=uicontrol(panel1111,'style','togglebutton','TooltipString','Hide Label','CData',hide,'units','Normalized','position',[8/10,1/2,1/10,1/2],'visible','on','Callback',@hideon);

        [hideROI,map]=imread('.\bitmaps\HideROI.bmp');
        hideROI=ind2rgb(hideROI,map);
        [hideROIr,map]=imread('.\bitmaps\segpoly_active.bmp');
        hideROIr=ind2rgb(hideROIr,map);
        hideROIf=uicontrol(panel1111,'style','togglebutton','TooltipString','Hide ROI','CData',hideROI,'units','Normalized','position',[9/10,1/2,1/10,1/2],'visible','on','Callback',@hideROIon);

        [Rectangl,map]=imread('.\bitmaps\rectangl.bmp');
        Rectangl=ind2rgb(Rectangl,map);
        Rectanglt= uicontrol(panel1111,'style','togglebutton','CData',Rectangl,'units','Normalized','position',[0,0,1/10,1/2],'TooltipString','Rectangle','HandleVisibility','off');
        set(Rectanglt,'Callback',@retangle,'BusyAction','cancel')

        [Segpoly,map]=imread('.\bitmaps\segpoly.bmp');
        Segpoly=ind2rgb(Segpoly,map);
        Segpolyt= uicontrol(panel1111,'style','togglebutton','CData',Segpoly,'units','Normalized','position',[1/10,0,1/10,1/2],'TooltipString','Polygon','HandleVisibility','off');
        set(Segpolyt,'Callback',@poly,'BusyAction','cancel')

        [AutoROI,map]=imread('.\bitmaps\gears.bmp');
        AutoROI=ind2rgb(AutoROI,map);
        uicontrol(panel1111,'style','pushbutton','TooltipString','automatic ROI','CData',AutoROI,'units','Normalized','position',[2/10,0,1/10,1/2],'visible','on','callback',@autof,'BusyAction','cancel');
        %用于在分离线粒体上自动ROI

        [AutoROIp,map]=imread('.\bitmaps\gearsROI.bmp');
        AutoROIp=ind2rgb(AutoROIp,map);

        AutoROIp=uicontrol(panel1111,'style','togglebutton','TooltipString','Batch automatic Draw ROI','CData',AutoROIp,'units','Normalized','position',[3/10,0,1/10,1/2],'visible','on');  
        set(AutoROIp,'Callback',@BatchAutomaticDrawROI); 

        [AutoTotal,map]=imread('.\bitmaps\group.bmp');
        AutoTotal=ind2rgb(AutoTotal,map);
        AutoTotal=uicontrol(panel1111,'style','togglebutton','TooltipString','Automatic detection of whole cell','CData',AutoTotal,'units','Normalized','position',[4/10,0,1/10,1/2],'visible','on');  
        set(AutoTotal,'Callback',@AutoTotalf);     

        [Delete,map]=imread('.\bitmaps\delete.bmp');
        Delete=ind2rgb(Delete,map);
        uicontrol(panel1111,'style','pushbutton','TooltipString','Delete current ROI','CData',Delete,'units','Normalized','position',[5/10,0,1/10,1/2],'visible','on','Callback',@deletthis);

        [Deletem,map]=imread('.\bitmaps\DeleteManualROI.bmp');
        Deletem=ind2rgb(Deletem,map);
        uicontrol(panel1111,'style','pushbutton','TooltipString','Delete All ROI','CData',Deletem,'units','Normalized','position',[6/10,0,1/10,1/2],'visible','on','Callback',@delet,'BusyAction','cancel');

        [left,map]=imread('.\bitmaps\shift_left.bmp');
        left=ind2rgb(left,map);
        Leftt=uicontrol(panel1111,'style','pushbutton','TooltipString','Previous ROI','CData',left,'units','Normalized','position',[7/10,0,1/10,1/2],'visible','on','enable','off','Callback',@leftf);

        [right,map]=imread('.\bitmaps\shift_right.bmp');
        right=ind2rgb(right,map);
        Rightt=uicontrol(panel1111,'style','pushbutton','TooltipString','Next ROI','CData',right,'units','Normalized','position',[8/10,0,1/10,1/2],'visible','on','enable','off','Callback',@rightf);

        [ROIselection,map]=imread('.\bitmaps\arrow.bmp');
        ROIselection=ind2rgb(ROIselection,map);
        ROIselection=uicontrol(panel1111,'style','togglebutton','TooltipString','ROIselection','CData',ROIselection,'units','Normalized','position',[9/10,0,1/10,1/2],'visible','on','Callback',@ROIselectionf);

        Opent= uicontrol(panel_right_button,'style','pushbutton','String','Dir','units','Normalized','position',[0/15,1/4,1/15,1/2],'TooltipString','select directory','HandleVisibility','off');
        set(Opent,'Callback',@Openfile)

        [Save,map]=imread('.\bitmaps\save.bmp');
        Save=ind2rgb(Save,map);
    %   savet保存flash参数分析的结果
        Savet= uicontrol(panel_right_button,'style','pushbutton','CData',Save,'units','Normalized','position',[1/15,1/4,1/15,1/2],'TooltipString','Save flash parameters','HandleVisibility','off');
        set(Savet,'Callback',@savef)

        [Load_Status,map]=imread('.\bitmaps\importd.bmp');
        Load_Status=ind2rgb(Load_Status,map);
        Load_Statust= uicontrol(panel_right_button,'style','pushbutton','CData',Load_Status,'units','Normalized','position',[2/15,1/4,1/15,1/2],'TooltipString','Load status','HandleVisibility','off');
        set(Load_Statust,'callback',@load_status)

        [Save_Status,map]=imread('.\bitmaps\importf.bmp');
        Save_Status=ind2rgb(Save_Status,map);
        Save_Statust= uicontrol(panel_right_button,'style','pushbutton','CData',Save_Status,'units','Normalized','position',[3/15,1/4,1/15,1/2],'TooltipString','Save status','HandleVisibility','off');
        set(Save_Statust,'Callback',@savestatusf)

        uicontrol(panel_right_button,'style','popup','String','parameter to excel|traces to excel','FontSize',12,'units','Normalized','position',[4/15,1/4,2/15,1/2],'TooltipString','Save to Excel','HandleVisibility','off','Callback',@savetracef);

        ResetBCbutton=uicontrol(panel_right_button,'style','pushbutton','string','RestBC','TooltipString','Reset brightness and contrast','units','normalized','position',[6/15,1/4,1/15,1/2]);
        set(ResetBCbutton,'callback',@ResetBC); 
        openFLbutton=uicontrol(panel_right_button,'style','pushbutton','string','openFL','TooltipString','Open file with filename list','units','normalized','position',[7/15,1/4,1/15,1/2]);
        set(openFLbutton,'callback',@openFL);

        uicontrol(panel_right_button,'style','pushbutton','string','SetColor','TooltipString','Set color','units','normalized','position',[8/15,1/4,1/15,1/2],'callback',@ChangeColor);

    %     显示文件列表的列表框
        listbox=uicontrol(panel_fileList,'style','listbox','units','Normalized','position',[0,0,1,1],'callback',@listboxf);


        drawf.f1=axes('Parent',panel12,'units','Normalized','Position',[0,0,1,1],'xtick',[],'ytick',[]...
            ,'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94],'drawmode','fast');
        drawf.f2=axes('Parent',panel12,'units','Normalized','Position',[0,0,1,1],'xtick',[],'ytick',[]...
            ,'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94],'drawmode','fast');
        axis ij 
        drawf.f3=axes('Parent',panel12,'units','Normalized','Position',[0,0,1,1],'xtick',[],'ytick',[]...
            ,'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94],'drawmode','fast');
        axis ij 
        drawf.f4=axes('Parent',panel12,'units','Normalized','Position',[0,0,1,1],'xtick',[],'ytick',[]...
            ,'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94],'drawmode','fast');
        axis ij 

        set(drawf.f2,'color','none','XLimMode','manual')
        set(drawf.f3,'color','none','XLimMode','manual')
        set(drawf.f4,'color','none','XLimMode','manual')

    %  trace.f3是flash的trace
        trace.f3=axes('Parent',panel_flashTrace,'units','Normalized','Position',[0,0,1,1],'xtick',[],'ytick',[]...
            ,'xcolor',[0.94,0.94,0.94],'ycolor',[0.94,0.94,0.94],'drawmode','fast');

        slider=uicontrol(panel1121,'style','slider','units','Normalized','position',[0,1/3,1,2/3],'enable','off');
        threshold=uicontrol(panel1121,'style','edit','String','','units','Normalized','FontSize',10,'position',[0,0,1/8,1/3]);
        ptext=uicontrol(panel1121,'style','text','String','','units','Normalized','FontSize',10,'position',[1/8,0,5/4,1/3]);
        statush=uicontrol(panel1121,'style','text','String','Ready','units','Normalized','FontSize',10,'position',[3/4,0,1/8,1/3]);
        timeh=uicontrol(panel1121,'style','text','String','','units','Normalized','FontSize',10,'position',[7/8,0,1/8,1/3]);

        hJScrollBar = findjobj(slider);
        hJScrollBar.AdjustmentValueChangedCallback = @sliderf;
%         set(slider,'callback',@sliderf)

        sliderB=uicontrol(panel111,'style','slider','units','Normalized','position',[0,0,0.5,0.2],'enable','on','max',1,'min',-1,'value',0,'sliderstep',[0.02,0.2],'callback',@adjustBC);% Brightness correction
        sliderC=uicontrol(panel111,'style','slider','units','Normalized','position',[0.5,0,0.5,0.2],'enable','on','max',1,'min',-1,'value',0,'sliderstep',[0.02,0.2],'callback',@adjustBC);% Contrast correction
        BCdata=[];

        bits=8;

    %   Green, Gray, Gray, Gray

        mapAll={[zeros(256,1),(0:255)'/255,zeros(256,1)],...
                    [(0:255)'/255,(0:255)'/255,(0:255)'/255],...
                    [(0:255)'/255,(0:255)'/255,(0:255)'/255],...
                    [(0:255)'/255,(0:255)'/255,(0:255)'/255]};

        TraceColor={[0,1,0],[0.5,0.5,0.5],[1,1,1],[1,1,1]};


        channelcheckbox=[];
        Time=[];
        Pathname='';
        newpathsavestatus='';
        newpathload_status='';
        xy=[];
        stabledata={};
        info='';
        r=0;
        rr=0;
        rrchannel=0;
        lastVal=0;
        lastVal1=0;
        count=0; % 总的ROI数
        currentflash=0; % 当前选中的ROI编号
        ROI={}; % 存放ROI划的线的句柄
        ROItext=[]; % ROI的文件
        ROIpoint={}; % 存放绘ROI的点位置
        flg=[];
        flashsignal={}; % 存放所有ROI内的像素均值
        signalpoint={}; % 存放flash信号起点，峰值，终点的时间位置
        lsmdata=[];
        lsm_image=[];
        signal={}; %当前选中的ROI的像素均值
        hlabel=line('xdata',[0,1],'ydata',[0,1],'color','r','parent',trace.f3,'visible','off');

        drawlinearray=[];
        drawlinetextarray=[];
        drawlinecount=0;

        sto=1;
        row=0;
        col=0;
        zstack=1;

        h_R=[];
        h_P=[];
        h_D=[];
        
        ROIInfo={}; 
        % ROIInfo是个cell，行数是ROI总数，第一列是ROI编号的字符串，
        % 第二列是[parameter,netOutput]的矩阵，矩阵行数是检测出的峰数，列数是30，即29个parameter和一个神经网络输出值

        channel=[];
        info_extend=[];
        Filename={};

        set(f0,'resizefcn',@resizef)
        set(f0,'windowbuttonmotionfcn',@windowmotionf)
        set(f0,'CloseRequestFcn',@closereq)

        jFrame=getJFrame(f0);
        jFrame.setMaximized(1);
        
        flashThresh=0.7; % 神经网络输入判定阈值
    end
end

function ChangeColor(~,~)
%   Green, Red, Gray, None
    global mapAll TraceColor
    mapAll_color={[zeros(256,1),(0:255)'/255,zeros(256,1)],...
                [(0:255)'/255,zeros(256,1),zeros(256,1)],...
                [(0:255)'/255,(0:255)'/255,(0:255)'/255],...
                [(0:255)'/255,(0:255)'/255,(0:255)'/255]};

    TraceColor_color={[0,1,0],[1,0,0],[0.5,0.5,0.5],[1,1,1]};

    prompt={'Input color for Channel 1 (1 Green, 2 Red, 3 Gray, 4 None)',...
            'For Channel 2',...
            'For Channel 3',...
            'For Channel 4'};
    name='Set color';
    numlines=1;
    defaultanswer={'1','2','3','4'};
    answer=inputdlg(prompt,name,numlines,defaultanswer); 
    if ~isempty(answer);
        for id=1:4
            mapAll{id}=mapAll_color{str2double(answer{id})};
            TraceColor{id}=TraceColor_color{str2double(answer{id})};
        end
    end
end

function assignColor
    global mapAll TraceColor cpYFPCh TMRMCh TPMTCh
    mapAll_color={[zeros(256,1),(0:255)'/255,zeros(256,1)],...
            [(0:255)'/255,zeros(256,1),zeros(256,1)],...
            [(0:255)'/255,(0:255)'/255,(0:255)'/255],...
            [(0:255)'/255,(0:255)'/255,(0:255)'/255]};
    TraceColor_color={[0,1,0],[1,0,0],[0.5,0.5,0.5],[1,1,1]};
    for id=1:4
        switch id
            case cpYFPCh
                mapAll{id}=mapAll_color{1};
                TraceColor{id}=TraceColor_color{1};
            case TMRMCh
                mapAll{id}=mapAll_color{2};
                TraceColor{id}=TraceColor_color{2};
            case TPMTCh
                mapAll{id}=mapAll_color{3};
                TraceColor{id}=TraceColor_color{3};
            otherwise
                mapAll{id}=mapAll_color{4};
                TraceColor{id}=TraceColor_color{4};
        end
    end
end
            
function resizef(~,~)
    global row f0 lsmdata rr rrchannel bits mapAll drawf panel12 col
%         pf=get(f0,'position');
    if row ~=0
        screen=get(0,'ScreenSize');
        imshow(adjustedBCdata(uint8(lsmdata(rr).data{rrchannel})./2^(bits-8)),mapAll{rrchannel},'parent',drawf.f1)
        SetLocation(f0,drawf.f1,row,col,screen,panel12)
        SetLocation(f0,drawf.f2,row,col,screen,panel12)
        SetLocation(f0,drawf.f3,row,col,screen,panel12)
        SetLocation(f0,drawf.f4,row,col,screen,panel12)
        set(drawf.f1,'xlim',[1,row],'ylim',[1,col]);
        set(drawf.f2,'xlim',[1,row],'ylim',[1,col]);
        set(drawf.f3,'xlim',[1,row],'ylim',[1,col]);
        set(drawf.f4,'xlim',[1,row],'ylim',[1,col]);
    end
%         set(tablef,'ColumnWidth',{pf(3)*screen(3)*0.4/6});
end

function Openfile(~,~)
    % Dir按钮的响应函数
    global newpath1 Pathname
    try 
        forder_name=uigetdir;
    end
    newpath1=forder_name;
    if forder_name==0
        return;
    else
        Pathname=forder_name;
    end
opennamef;
end

function save_movie(~,~)
    global Filename newpath1 lsmdata rrchannel mapAll r row col rr
    if r
        if strcmp(Filename(end-3:end),'.lsm')||strcmp(Filename(end-3:end),'.mat')
            Filename=Filename(1:end-4);
        end
        
        choice=questdlg('choose vedio format','','AVI','GIF','AVI');
        if isempty(choice);return;end
        
        fn=[Filename,'.',char(choice+32)];
        if ~(newpath1==0)
            str1=[newpath1,'\',fn];
        end

        answer=inputdlg({'Input sstart fram','End fram','frames per second'},'',1,{'1',num2str(r),'10'});
        if isempty(answer)
            return
        end
        
        sstart=str2double(answer{1});
        final=str2double(answer{2});
        DelayTime=1/str2double(answer{3});
        
        if strcmp(choice,'GIF');
            try
                imwrite(adjustedBCdata(lsmdata(sstart).data{rrchannel}),mapAll{rrchannel},str1,'gif', 'Loopcount',inf,'DelayTime',DelayTime);
                for cou=2:final
                    imwrite(adjustedBCdata(lsmdata(cou).data{rrchannel}),mapAll{rrchannel},str1,'gif','WriteMode','append','DelayTime',DelayTime);
                end
                msgbox('done');
            catch e
                msgbox(e.message)
            end
        else
            videoobj=VideoWriter(str1);
            videoobj.FrameRate=str2double(answer{3});
            open(videoobj);
            try
                tmp=rr; %为merged图片作准备
                f=figure('menubar','none');
                pos=get(f,'position');
                set(f,'position',[pos(1) pos(2)-200 row col])
                a=axes('unit','pixel','position',[1 1 row col],...
                    'nextplot','replacechildren','parent',f,'visible','off',...
                    'xlim',[0.5 row+0.5],'ylim',[0.5 col+0.5]);
                for id=sstart:final
                    rr=id; %rr在下句的函数中会用到
                    imshow(adjustedBCdata(lsmdata(id).data{rrchannel}),mapAll{rrchannel},'parent',a);
                    writeVideo(videoobj,getframe(f));
                end
                delete(f)
            catch e
                disp(e.message)                
            end
            close(videoobj)
            rr=tmp;
        end
    end
end

function drawlinef(~,~)
    global Rectanglt Segpolyt ROIselection  xy f0 trace count...
        row col signalpoint currentflash drawf
    
    set(Rectanglt,'value',0)
    set(Segpolyt,'value',0)
    set(ROIselection,'value',0)
%         set(AutoROIp,'value',0)

    set(f0,'WindowButtonmotionfcn',@wb)

    function wb(~,~)

        p=get(f0,'currentpoint');
        pg=get(drawf.f4,'currentpoint');

        ylim=get(trace.f3,'ylim');
        xlim=get(trace.f3,'xlim');
         pd=get(trace.f3,'currentpoint');

        if p(1,1)>0&&p(1,1)<0.6&&p(1,2)>0.15&&p(1,2)<1&&pg(1,1)>0&&pg(1,1)<row&&pg(1,2)>0&&pg(1,2)<col
            set(f0,'pointer','arrow');
            set(f0,'WindowButtonDownFcn',@wbdcb)
        elseif pd(1,1)>=xlim(1)&&pd(1,1)<=xlim(2)&&pd(1,2)>=ylim(1)&&pd(1,2)<=ylim(2)
            set(f0,'pointer','cross');
            set(f0,'WindowButtonDownFcn','')
            if count>0
                point=signalpoint{currentflash};
                if ~isempty(point.ind)
                    cg=get(trace.f3,'currentpoint');
                    x1=point.ind;y1=point.pea;
                    x2=point.base;y2=point.basepea;
                    x3=point.down;y3=point.downpea;
                    x=[x1,x2,x3];y=[y1,y2,y3];
                    l=length(x);
                    for i=1:l
                        if abs(cg(1,1)-(x(i)))+abs(cg(1,2)-y(i))<2
                            set(f0,'pointer','hand')
                            set(f0,'windowbuttondownfcn','');
                            break
                        else
                            set(f0,'pointer','cross')
                        end
                    end
                end
            end
        else
            set(f0,'pointer','arrow');
            set(f0,'WindowButtonDownFcn','')
        end

    end       

    function wbdcb(~,~)
        pg=get(drawf.f4,'currentpoint');
        xinit=[pg(1,1),pg(1,1)];
        yinit=[pg(1,2),pg(1,2)];
        h1=line('XData',xinit,'YData',yinit,'color','r','linewidth',3,'parent',drawf.f4,'color','w','visible','off');
        ll=sqrt((xinit(1)-xinit(2))^2*xy.VoxelSizeX+(yinit(1)-yinit(2))^2*xy.VoxelSizeY);
        ll=floor(ll*10)/10;
        text1=text((xinit(1)+xinit(2))/2-8,(xinit(1)+xinit(2))/2-8,0,[num2str(ll),' um'],'Parent',drawf.f4...
            ,'color','w','fontsize',12,'visible','off');

        set(f0,'WindowButtonmotionfcn',@drawlinemotionf)
        set(f0,'WindowButtonupfcn',@drawlineupf)

        function drawlinemotionf(~,~)

            pg= get(drawf.f4,'CurrentPoint');
            xdat = pg(1,1);
            ydat = pg(1,2);
            xdat=[xinit(1),xdat];
            ydat=[yinit(1),ydat];
            set(h1,'XData',xdat,'YData',ydat,'visible','on')
            ll=sqrt(((xdat(1)-xdat(2))*xy.VoxelSizeX)^2+((ydat(1)-ydat(2))*xy.VoxelSizeY)^2)*10^6;

            ll=floor(ll*10)/10;
            set(text1,'position',[(xdat(1)+xdat(2))/2-15,(ydat(1)+ydat(2))/2-8,0],'String',[num2str(ll),' um'],'visible','on')
            set(f0,'WindowButtonupfcn',@drawlineupf)

        end

        function drawlineupf(~,~)
%   画比例尺                 
            pg= get(drawf.f4,'CurrentPoint');
            xdat = pg(1,1);
            ydat = pg(1,2);
            xdat=[xinit(1),xdat];
            ydat=[yinit(1),ydat];
            set(h1,'XData',xdat,'YData',ydat,'visible','on')
            ll=sqrt(((xdat(1)-xdat(2))*xy.VoxelSizeX)^2+((ydat(1)-ydat(2))*xy.VoxelSizeY)^2)*10^6;
            ll=floor(ll*10)/10;
            set(text1,'position',[(xdat(1)+xdat(2))/2-15,(ydat(1)+ydat(2))/2-8,0],'String',[num2str(ll),' um'],'visible','on')

            if ishandle(h1)
                x=get(h1,'XData');
                y=get(h1,'YData');
                if x(1)==x(2)||y(1)==y(2)
                    delete(h1)
                    delete(text1)
                end
            end
            set(f0,'WindowButtonmotionfcn',@windowmotionf1)

        end

        function windowmotionf1(~,~)
            p=get(f0,'currentpoint');
            pg=get(drawf.f4,'currentpoint');

            ylim=get(trace.f3,'ylim');
            xlim=get(trace.f3,'xlim');
            pd=get(trace.f3,'currentpoint');

            if p(1,1)>0&&p(1,1)<0.6&&p(1,2)>0.15&&p(1,2)<1&&pg(1,1)>0&&pg(1,1)<row&&pg(1,2)>0&&pg(1,2)<col
                set(f0,'pointer','arrow');
                set(f0,'WindowButtonDownFcn',@wbdcb)
            elseif pd(1,1)>=xlim(1)&&pd(1,1)<=xlim(2)&&pd(1,2)>=ylim(1)&&pd(1,2)<=ylim(2)
                set(f0,'pointer','cross');
                set(f0,'WindowButtonDownFcn','')
                if count>0
                    point=signalpoint{currentflash};
                    if ~isempty(point.ind)
                        cg=get(trace.f3,'currentpoint');
                        x1=point.ind;y1=point.pea;
                        x2=point.base;y2=point.basepea;
                        x3=point.down;y3=point.downpea;
                        x=[x1,x2,x3];y=[y1,y2,y3];
                        l=length(x);
                        for i=1:l
                            if abs(cg(1,1)-(x(i)))+abs(cg(1,2)-y(i))<2
                                set(f0,'pointer','hand')
                                set(f0,'windowbuttondownfcn','');
                                break
                            else
                                set(f0,'pointer','cross')
                            end
                        end
                    end
                end
            else
                set(f0,'pointer','arrow');
                set(f0,'WindowButtonDownFcn','')
            end


        end

    end


end

function deletelinef(~,~)
    global drawf drawlinearray drawlinetextarray drawlinecount
    
    cla(drawf.f4);
    drawlinearray=[];
    drawlinetextarray=[];
    drawlinecount=0;

    recover([],[])
end

function Playf(s,~)
    global r sto Stop rr slider timeh count ShowTracker trace hlabel Play
    
    if get(s,'value')
        if r>1
            sto=0;
            eachstep = 1/(r-1);
            set(s,'cdata',Stop);
            while 1
                if sto==1
                    break;
                end 
    %                 pause(get(slider1,'value'));
                if rr==r
                    rr=1;
                else
                    rr=rr+1;
                end
                val=(rr-1)*eachstep;
                set(slider,'value',val);
    %                 imshow(adjustedBCdata(lsmdata(rr).data{rrchannel}),mapAll{rrchannel},'parent',drawf.f1)
                drawnow
                pause(0.01);
                str=strcat(num2str(rr),'/',num2str(r)); 
                set(timeh,'string',str)   

                if count>0
                    if get(ShowTracker,'value')==1
                        ylim=get(trace.f3,'ylim');
                        if ishandle(hlabel)
                            delete(hlabel)
                        end
                        hlabel=line('xdata',[rr,rr],'ydata',ylim,'color','r','parent',trace.f3);
                    else
                        if ishandle(hlabel)
                            delete(hlabel)
                        end
                    end
                end
            end 
        else
            set(s,'value',0);
        end
    else
        set(s,'cdata',Play);
        sto=1;
    end
end

function recover(~,~)
    global f0

    set(f0,'WindowButtonmotionfcn',@windowmotionf)
    set(f0,'WindowButtonDownFcn','')
    set(f0,'WindowButtonupFcn','')

end

function windowmotionf(~,~)
    global trace f0 drawf ptext count signalpoint currentflash row col lsmdata rr rrchannel

    ylim=get(trace.f3,'ylim');
    xlim=get(trace.f3,'xlim');
    pd=get(trace.f3,'currentpoint');
    p=get(f0,'currentpoint');
    pg=get(drawf.f1,'currentpoint');

    if pd(1,1)>=xlim(1)&&pd(1,1)<=xlim(2)&&pd(1,2)>=ylim(1)&&pd(1,2)<=ylim(2)
        set(ptext,'string','')
        set(f0,'pointer','cross');
        set(f0,'WindowButtonDownFcn','')
        if count>0
            if~isempty(signalpoint)
                point=signalpoint{currentflash};
                if ~isempty(point.ind)
                    cg=get(trace.f3,'currentpoint');
                    x1=point.ind;y1=point.pea;
                    x2=point.base;y2=point.basepea;
                    x3=point.down;y3=point.downpea;
                    x=[x1,x2,x3];y=[y1,y2,y3];
                    l=length(x);
                    for i=1:l
                        if abs(cg(1,1)-(x(i)))+abs(cg(1,2)-y(i))<2
                            set(f0,'pointer','hand')
                            set(f0,'windowbuttondownfcn','');
                            break
                        else
                            set(f0,'pointer','cross')
                        end
                    end
                end
            end
        end
    elseif p(1,1)>0&&p(1,1)<0.6&&p(1,2)>0.15&&p(1,2)<1&&pg(1,1)>0&&pg(1,1)<row&&pg(1,2)>0&&pg(1,2)<col
        pg=floor(pg)+1;
        set(ptext,'string',['X:',num2str(pg(1,1)),', ','Y:',num2str(pg(1,2)),'Intensity:',num2str(lsmdata(rr).data{rrchannel}(pg(1,2),pg(1,1)))])
    else
        set(ptext,'string','')
        set(f0,'pointer','arrow');
        set(f0,'WindowButtonDownFcn','')
    end
end

function framedeletef(~,~) 
    % 这个函数功能尚不完善，不能和ROI的trace联动，慎用
    global r rr lsmdata slider timeh mapAll rrchannel drawf bits lastVal Time
    choice = questdlg('Do you detemine to detele frame?', 'Delete bad frame','Yes','No','Yes');
    switch choice
        case 'Yes'
            if r<1
                errordlg('Image data not found','Error','modal');
            else
                if r<2
                    errordlg('This is no image data','Error','modal');
                else
                    current=1:r;
                    current=setdiff(current,rr);
                    lsmdata=lsmdata(current);
                    Time=Time(current);
                    r=r-1;
                    eachstep=[1/(r-1),1/(r-1)];
                    set(slider,'sliderstep',eachstep);
                    if rr>r;rr=r;end
                    str=strcat(num2str(rr),'/',num2str(r));
                    set(timeh,'string',str)
                    lastVal=0;
                    imshow(adjustedBCdata(uint8(lsmdata(rr).data{rrchannel}./2^(bits-8))),mapAll{rrchannel},'parent',drawf.f1)
                end
            end
        case 'No'
            return
    end
end

function savePng(~,~)
    global r Filename newpath1 rr drawf row col
%     global rrchannel mapAll lsmdata

    if r
        if strcmp(Filename(end-3:end),'.lsm')||strcmp(Filename(end-3:end),'.mat')
            Filename=Filename(1:end-4);
        end
        fn=strcat(Filename,'_',num2str(rr), '.png');
        if (newpath1==0)

        else
            str1=[newpath1,'\',fn];
        end
        
        %这样可以把bar什么的也一起保存下来
        
        frame= getframe(drawf.f1);
        imind=frame2im(frame);
        imind=imresize(imind,[row col]);
        [imind,cm] = rgb2ind(imind,256);
        imwrite(imind,cm,str1,'png')
%         imwrite(adjustedBCdata(lsmdata(rr).data{rrchannel}),mapAll{rrchannel},str1,'png');
    end
end

function ShowTrackerf(s,~)
    global ShowTracker HideTrackerImage ShowTrackerImage

    if get(s,'value')==1
        set(ShowTracker,'cdata',HideTrackerImage,'TooltipString','Hide Tracker');
    else
        set(ShowTracker,'cdata',ShowTrackerImage,'TooltipString','Show Tracker');
    end

end

function retangle(~,~)
    global info Time r Rectanglt drawline Segpolyt ROIselection AutoROIp f0 drawf trace count signalpoint flashsignal...
        currentflash row col signal channel lsmdata ROIInfo Leftt Rightt ROI ROIpoint hidef ROItext listboxtemp
    if isfield(info,'TimeOffset')
        Time=info.TimeOffset;
    else
        Time=1:r;
    end
    if get(Rectanglt,'value')==1
        set(drawline,'value',0)
        set(Segpolyt,'value',0)
        set(ROIselection,'value',0)
        set(AutoROIp,'value',0)
        if r>1
            set(f0,'WindowButtonmotionfcn',@wb)                
        else
            set(f0,'WindowButtonmotionfcn','')
        end
    else
        recover([],[]);
    end

    function wb(~,~)

        p=get(f0,'currentpoint');
        pg=get(drawf.f1,'currentpoint');

        ylim=get(trace.f3,'ylim');
        xlim=get(trace.f3,'xlim');
        pd=get(trace.f3,'currentpoint');

        if p(1,1)>0&&p(1,1)<0.6&&p(1,2)>0.15&&p(1,2)<1&&pg(1,1)>0&&pg(1,1)<row&&pg(1,2)>0&&pg(1,2)<col
            set(f0,'pointer','arrow');
            set(f0,'WindowButtonDownFcn',@wbdcb)
        elseif pd(1,1)>=xlim(1)&&pd(1,1)<=xlim(2)&&pd(1,2)>=ylim(1)&&pd(1,2)<=ylim(2)
            set(f0,'pointer','cross');
            set(f0,'WindowButtonDownFcn','')
            if count>0
                point=signalpoint{currentflash};
                if ~isempty(point.ind)
                    cg=get(trace.f3,'currentpoint');
                    x1=point.ind;y1=point.pea;
                    x2=point.base;y2=point.basepea;
                    x3=point.down;y3=point.downpea;
                    x=[x1,x2,x3];y=[y1,y2,y3];
                    l=length(x);
                    for i=1:l
                        if abs(cg(1,1)-(x(i)))+abs(cg(1,2)-y(i))<2
                            set(f0,'pointer','hand')
                            set(f0,'windowbuttondownfcn','');
                            break
                        else
                            set(f0,'pointer','cross')
                        end
                    end
                end
            end
        else
            set(f0,'pointer','arrow');
            set(f0,'WindowButtonDownFcn','')
        end

    end

    function wbdcb(src,~)
        if strcmp(get(src,'SelectionType'),'normal')
            cp = get(drawf.f1,'CurrentPoint');

            xinit = cp(1,1);
            yinit = cp(1,2);
            point.x=[];
            point.y=[];
            h1 = line('XData',xinit,'YData',yinit,'color','r','parent',drawf.f3);
            h2 = line('XData',xinit,'YData',yinit,'color','r','parent',drawf.f3);
            h3 = line('XData',xinit,'YData',yinit,'color','r','parent',drawf.f3);
            h4 = line('XData',xinit,'YData',yinit,'color','r','parent',drawf.f3);
            set(src,'WindowButtonMotionFcn',@wbmcb)
            set(src,'WindowButtonUpFcn',@wbucb)
        end

        function wbmcb(~,~)
            cp = get(drawf.f1,'CurrentPoint');
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

        function wbucb(~,~)
            set(src,'WindowButtonMotionFcn','')
            set(src,'WindowButtonUpFcn','')
            x=get(h1,'XData');
            y=get(h2,'YData');
            if length(x)==1
                delete(h1)
                delete(h2)
                delete(h3)
                delete(h4)
            elseif length(x)==2
                if x(1)==x(2)||y(1)==y(2)
                    delete(h1)
                    delete(h2)
                    delete(h3)
                    delete(h4)
                else
                    count=count+1;
                    x=floor(x);
                    y=floor(y);
                    x=sort(x);
                    y=sort(y);
                    x1=max(x(1),1);
                    x2=min(x(2),row);
                    y1=max(y(1),1);
                    y2=min(y(2),col);                  
                    x=[x1,x2];
                    y=[y1,y2];

                    signal=cell(1,channel);
                    for j=1:channel
                        signal1=zeros(1,r);
                        for i=1:r
                            imag=lsmdata(i).data{j};
                            %矩形ROI
                            imag=imag(y(1):y(2),x(1):x(2));
                            imag=double(imag);
                            signal1(i)=mean(imag(:));
                        end
                        signal{j}=signal1;
                    end
                    
                    plotOnTracef3;
                    %                   set(tablef,'data',stabledata);
                    hh(1)=h1;
                    hh(2)=h2;
                    hh(3)=h3;
                    hh(4)=h4;
                    set(Rightt,'enable','off'); %next flash button is unenable
                    ROI{count}=hh;

                    point.x=[x(1),x(2),x(2),x(1),x(1)];
                    point.y=[y(1),y(1),y(2),y(2),y(1)];
                    ROIpoint{count}=point;

                    if get(hidef,'value')==0
                        h5=text((x(1)+x(2))/2,(y(1)+y(2))/2,num2str(count),'Parent',drawf.f2);
                        set(h5,'color','r','HorizontalAlignment','center')
                    else
                        h5=text((x(1)+x(2))/2,(y(1)+y(2))/2,num2str(count),'visible','off','Parent',drawf.f2);
                        set(h5,'color','r','HorizontalAlignment','center')
                    end

                    ROItext(count)=h5;

                    if currentflash>0
                        set(ROI{currentflash},'color',[1,1,1]);
                        set(ROItext(currentflash),'color',[0.8,0.8,0]);
                    end                    

                                        
                    currentflash=count;
                    flashsignal{count}=signal;
                    ROIInfo{count,1}=num2str(count);
                    formROIInfoAndsignalpoint;
                    
                    set(listboxtemp,'string',ROIInfo(:,1),'value',count);

                    currentmark([],[]);
                    if currentflash>1
                        set(Leftt,'enable','on')
                        set(Rightt,'enable','off')
                    else
                        set(Leftt,'enable','off')
                        set(Rightt,'enable','off')
                    end
                    set(f0,'windowbuttonmotionfcn',@wb)
                end
            end
        end
    end
end

function poly(~,~)
    global info Time r Rectanglt drawline Segpolyt ROIselection AutoROIp f0 drawf trace count ROIInfo...
        currentflash row col signal channel lsmdata flashsignal Leftt Rightt ROI ROIpoint hidef ROItext listboxtemp
    
    x=[];
    y=[];
    hh=[];
    if isfield(info,'TimeOffset')
        Time=info.TimeOffset;
    else
        Time=1:r;
    end
    if get(Segpolyt,'value')==1
        set(Rectanglt,'value',0)
        set(ROIselection,'value',0)
        set(drawline,'value',0)
        set(AutoROIp,'value',0)
        if r>1
            set(f0,'WindowButtonmotionfcn',@wb)
        else
            set(f0,'WindowButtonmotionfcn','')
        end

    else
        recover([],[]);
    end

    function wb(~,~)
        p=get(f0,'currentpoint');
        pg=get(drawf.f1,'currentpoint');
        ylim=get(trace.f3,'ylim');
        xlim=get(trace.f3,'xlim');
        pd=get(trace.f3,'currentpoint');            
        if p(1,1)>0&&p(1,1)<0.6&&p(1,2)>0.15&&p(1,2)<1&&pg(1,1)>0&&pg(1,1)<row&&pg(1,2)>0&&pg(1,2)<col&&pg(1,3)==1
            set(f0,'WindowButtonDownFcn',@wbdcb)
        elseif pd(1,1)>=xlim(1)&&pd(1,1)<=xlim(2)&&pd(1,2)>=ylim(1)&&pd(1,2)<=ylim(2)
            set(f0,'pointer','cross');
            set(f0,'WindowButtonDownFcn','')
        else
            set(f0,'pointer','arrow');
            set(f0,'WindowButtonDownFcn','')
        end
    end

    function wbdcb(src,~)

        if strcmp(get(src,'SelectionType'),'normal')
            cp = get(drawf.f1,'CurrentPoint');
            xinit = cp(1,1);yinit = cp(1,2);
            h1=line('XData',xinit,'YData',yinit,'color','r','parent',drawf.f3);
            x=[x,xinit];
            y=[y,yinit];
            hh=[hh,h1];
            set(src,'WindowButtonMotionFcn',@wbmcb)
            set(src,'WindowButtonUpFcn',@wbucb)
        end

        function wbmcb(~,~)
            cp = get(drawf.f1,'CurrentPoint');
            xdat = [xinit,cp(1,1)];
            ydat = [yinit,cp(1,2)];
            set(h1,'XData',xdat,'YData',ydat);drawnow
        end

        function wbucb(src,~)
            if strcmp(get(src,'SelectionType'),'open')
                set(src,'WindowButtonMotionFcn',@wb)
                %画ROI的线
                h1=line('XData',[x(1),x(end)],'YData',[y(1),y(end)],'color','r','Parent',drawf.f3);
                hh=[hh,h1];
                if length(x)==1
                    delete(hh)
                    x=[];y=[];
                else
                    count=count+1;
                    if get(hidef,'value')==0
                        %加ROI的文字说明
                        h5=text(mean(x),mean(y),num2str(count),'Parent',drawf.f2);
                        set(h5,'color','r','HorizontalAlignment','center')
                    else
                        h5=text(mean(x),mean(y),num2str(count),'Parent',drawf.f2,'visible','off');
                        set(h5,'color','r','HorizontalAlignment','center')
                    end

                    ROItext(count)=h5;
                    ROI{count}=hh;
                    if currentflash>0
                        set(ROI{currentflash},'color',[1,1,1]);
                        set(ROItext(currentflash),'color',[0.8,0.8,0]);
                    end

                    currentflash=count;
                    
                    if currentflash>1
                        set(Leftt,'enable','on')
                        set(Rightt,'enable','off')
                    else
                        set(Leftt,'enable','off')
                        set(Rightt,'enable','off')
                    end

                    x=[x,x(1)];
                    y=[y,y(1)];
                    point.x=x;
                    point.y=y;
                    ROIpoint{count}=point;
                    imag=lsmdata(1).data{1};
                    
                    %多边形ROI二值图
                    bw=roipoly(imag, x, y);

                    signal=cell(1,channel);
                    for j=1:channel
                        signal1=zeros(1,r);
                        for i=1:r
                            imag=lsmdata(i).data{j};
                            signal1(i)=mean(double(imag(bw==1)));
                        end
                        signal{j}=signal1;
                    end

                    plotOnTracef3;

                    flashsignal{count}=signal;
                    ROIInfo{count,1}=num2str(count);
                    formROIInfoAndsignalpoint;
                    set(listboxtemp,'string',ROIInfo(:,1),'value',count);
                    currentmark([],[]);
                    x=[];y=[];
                    hh=[];
                end
            end
        end
    end
end

function deletthis(~,~)
    global count drawf ROI ROItext flashsignal signalpoint ROIInfo...
        currentflash signal trace listboxtemp ROIselection Rectanglt Segpolyt AutoROIp...
        ROIpoint Leftt Rightt

    if count>0
        str=get(findobj(drawf.f2,'color','r'),'string');
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
                ROIpoint=ROIpoint(current);
                flashsignal=flashsignal(current);
                signalpoint=signalpoint(current);
                ROIInfo=ROIInfo(current,:);
                if length(str)==1
                    if currentflash>count
                        currentflash=count;
                    end
                else
                    currentflash=1;
                end
                for i=1:count
                    set(ROItext(i),'string',num2str(i));
                    stabledata{i,1}=num2str(i);
                end 

                set(ROI{currentflash},'color','r')
                set(ROItext(currentflash),'color','r')
                signal=flashsignal{currentflash};
                plotOnTracef3;
                %更新ROI列表
                currentmark([],[]);
                set(listboxtemp,'string',stabledata(:,1),'value',currentflash);
%                     set(tablef,'data',stabledata);
            else
                set(ROIselection,'value',0)
                set(Rectanglt,'value',0)
                set(Segpolyt,'value',0)
                set(AutoROIp,'value',0)
                cla(drawf.f2)
                cla(drawf.f3)
                cla(trace.f3)
                axis(trace.f3,'off')
                legend(trace.f3,'off')
                signal={};
                count=0;
                ROIpoint={};
                ROIInfo={};
                currentflash=0;
                flashsignal={};% will delete in the future
                signalpoint={};
                recover([],[]);
                set(listboxtemp,'string','');
                set(Leftt,'enable','off')
                set(Rightt,'enable','off')
            end
        end
    end
end

function delet(~,~)
    global Leftt Rightt ROIselection Rectanglt Segpolyt AutoROIp f0 signal count ROIpoint currentflash...
        signalpoint ROI ROIInfo ROItext drawf trace listboxtemp flashsignal

    choice = questdlg('Do you detemine to detele all manual ROI?','Delete all manual ROI','Yes','No','No');
    switch choice
        case 'Yes'
            set(Leftt,'enable','off');
            set(Rightt,'enable','off');
            set(ROIselection,'value',0);
            set(Rectanglt,'value',0)
            set(Segpolyt,'value',0)
            set(AutoROIp,'value',0)
            set(f0,'WindowButtonmotionfcn','')
            set(f0,'WindowButtonDownFcn','')
            set(f0,'WindowButtonUpFcn','')

            signal={};
            count=0;
            ROIpoint={};
            ROIInfo={};
            currentflash=0;
            flashsignal={};% will delete in the future
            signalpoint={};
            ROI={};
            ROItext=[];
            cla(drawf.f2)
            cla(drawf.f3)
            cla(drawf.f4)
            cla(trace.f3)
            axis(trace.f3,'off')
            legend(trace.f3,'off')
            set(listboxtemp,'string','');
        case 'No'
            return
    end 
end

function hideon(s,~)
    global count ROItext hidef hide hider
    if get(s,'value')==1
        for i=1:count
            set(ROItext(i),'visible','off');
        end
        set(hidef,'CData',hide)
    else
        for i=1:count
            set(ROItext(i),'visible','on');
        end
        set(hidef,'CData',hider)
    end

end

function hideROIon(s,~)
    global count ROI hideROIf hideROI hideROIr
    if get(s,'value')==1
        for i=1:count
            set(ROI{i},'visible','off');
        end
        set(hideROIf,'CData',hideROI)
    else
        for i=1:count
            set(ROI{i},'visible','on');
        end
        set(hideROIf,'CData',hideROIr)
    end

end 

function leftf(~,~)
    global currentflash ROI ROItext signal flashsignal...
        count Rightt Leftt listboxtemp
     if currentflash>1
        set(ROI{currentflash},'color',[1,1,1])
        set(ROItext(currentflash),'color',[0.8,0.8,0])
        currentflash=currentflash-1;
        set(ROI{currentflash},'color','r')
        set(ROItext(currentflash),'color','r')
        signal=flashsignal{currentflash};
        plotOnTracef3;
        if currentflash<count
            set(Rightt,'enable','on')
        else
            set(Rightt,'enable','off')
        end 
        if currentflash==1
            set(Leftt,'enable','off')
        end
        currentmark([],[]);
        set(listboxtemp,'value',currentflash);
    else
        set(Leftt,'enable','off')
    end        

end

function rightf(~,~)
    global currentflash ROI ROItext signal flashsignal...
        count Rightt Leftt listboxtemp
    if currentflash<count

        set(ROI{currentflash},'color',[1,1,1])
        set(ROItext(currentflash),'color',[0.8,0.8,0])
        currentflash=currentflash+1;
        set(ROI{currentflash},'color','r')
        set(ROItext(currentflash),'color','r')            

        signal=flashsignal{currentflash};
        plotOnTracef3;
        if currentflash>1
            set(Leftt,'enable','on')
        else
            set(Leftt,'enable','off')
        end
        if currentflash==count
            set(Rightt,'enable','off')
        end 
        currentmark([],[]);
        set(listboxtemp,'value',currentflash);

    else
        set(Rightt,'enable','off')
    end       

end

function ROIselectionf(~,~)
    global ROIselection drawline Rectanglt Segpolyt count f0
    if get(ROIselection,'value')==1
        set(drawline,'value',0)
        set(Rectanglt,'value',0)
        set(Segpolyt,'value',0)
        if count>0
            set(f0,'WindowButtonMotionFcn',@cb2c);
        else
            set(f0,'WindowButtonMotionFcn','');
        end
        set(f0,'WindowButtonDownFcn','');
    else
        recover([],[]);
    end        

end

function downff(~,~)
    global f0 drawf count ROIpoint ROItext ROI
    if strcmp(get(f0,'SelectionType'),'normal')
        cp = get(drawf.f2,'CurrentPoint');
        xinit = cp(1,1);yinit = cp(1,2);
        str1=get(findobj(drawf.f2,'color','r'),'string');

        h1 = line('XData',xinit,'YData',yinit,'color','w','LineStyle',':','parent',drawf.f4);
        h2 = line('XData',xinit,'YData',yinit,'color','w','LineStyle',':','parent',drawf.f4);
        h3 = line('XData',xinit,'YData',yinit,'color','w','LineStyle',':','parent',drawf.f4);
        h4 = line('XData',xinit,'YData',yinit,'color','w','LineStyle',':','parent',drawf.f4);

        set(f0,'WindowButtonMotionFcn',@cb2c1);
        set(f0,'WindowButtonUpFcn',@cb2cup);
    else
        set(f0,'WindowButtonMotionFcn','');
        set(f0,'WindowButtonUpFcn',''); 
    end
    function cb2c1(~,~)
        get(drawf.f4,'CurrentPoint');
        cp = get(drawf.f1,'CurrentPoint');
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
                if ~isempty(find(IN==1, 1))
                    set(ROI{i},'color','r');
                    set(ROItext(i),'color','r');
                else
                    set(ROI{i},'color',[1,1,1]);
                    set(ROItext(i),'color',[0.8,0.8,0]);
                end
            end
        end
        drawnow
    end
    function cb2cup(~,~)
        if count==0
            set(f0,'WindowButtonMotionFcn','');
            set(f0,'WindowButtonDownFcn',@downff);
        else
            set(f0,'WindowButtonMotionFcn',@cb2c);
            set(f0,'WindowButtonDownFcn',@downff);
        end

        if ishandle(h1)
            x=get(h1,'XData');
            y=get(h2,'YData');
            if length(x)>1
                if x(1)~=x(2)
                    x=[x(1),x(2),x(2),x(1)];
                    y=[y(1),y(1),y(2),y(2)];
                    str=get(findobj(drawf.f2,'color','r'),'string');
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
    end
end

function cb2c(~,~)
    global drawf f0 trace row col count ROIpoint ROI ROItext currentflash Leftt Rightt signal...
        flashsignal listboxtemp signalpoint
    ggca=get(drawf.f1,'currentpoint');
    p=get(f0,'currentpoint');
    ylim=get(trace.f3,'ylim');
    xlim=get(trace.f3,'xlim');
    pd=get(trace.f3,'currentpoint');

    if p(1,1)>0&&p(1,1)<0.6&&p(1,2)>0.15&&p(1,2)<1&&ggca(1,1)>0&&ggca(1,1)<row&&ggca(1,2)>0&&ggca(1,2)<col
        for i=1:count
            IN=inpolygon(ggca(1,1),ggca(1,2),ROIpoint{i}.x,ROIpoint{i}.y);
            if IN(1)
                set(f0,'Pointer','hand')
                set(f0,'windowbuttondownfcn',@down)
                return
            else
                set(f0,'Pointer','arrow')
                set(f0,'windowbuttondownfcn',@downff)
            end

        end
    elseif pd(1,1)>=xlim(1)&&pd(1,1)<=xlim(2)&&pd(1,2)>=ylim(1)&&pd(1,2)<=ylim(2)
        set(f0,'pointer','cross');
        set(f0,'WindowButtonDownFcn','')
        if count>0
            point=signalpoint{currentflash};
            if ~isempty(point.ind)
                cg=get(trace.f3,'currentpoint');
                x1=point.ind;y1=point.pea;
                x2=point.base;y2=point.basepea;
                x3=point.down;y3=point.downpea;
                x=[x1,x2,x3];y=[y1,y2,y3];
                l=length(x);
                for i=1:l
                    if abs(cg(1,1)-(x(i)))+abs(cg(1,2)-y(i))<2
                        set(f0,'pointer','hand')
                        set(f0,'windowbuttondownfcn','');
                        break
                    else
                        set(f0,'pointer','cross')
                    end
                end
            end
        end
    else
        set(f0,'pointer','arrow');
        set(f0,'WindowButtonDownFcn','')
    end

    function down(s,e)
        for jj=1:count
            set(ROI{jj},'color',[1,1,1]);
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
        signal=flashsignal{i};
        set(trace.f3,'OuterPosition',[0,0,1,1])
        plotOnTracef3;
        currentmark([],[]);
        set(listboxtemp,'value',currentflash);
    end
end

function savestatusf(~,~)
    global newpathsavestatus Filename Leftt Rightt ROIselection Rectanglt Segpolyt AutoROIp f0 xy count...
        currentflash flashsignal lsmdata mapAll ROIpoint ROIInfo TraceColor TraceToShow...
        info_extend channel signalpoint info newpath1 Pathname lastVal signal BCdata...
        drawf ROI ROItext trace listboxtemp r rr panel112 panel111 TMRMCh cpYFPCh TPMTCh Time
     if ~exist('newpath','var')||isempty(newpathsavestatus)
        newpathsavestatus=cd;
     end
    if strcmp(Filename(end-3:end),'.lsm')||strcmp(Filename(end-3:end),'.mat')
        Filename=Filename(1:end-4);
    end

    name=Filename;
    if (newpath1==0)
        fn=[Pathname,'\',name];
    else
        fn=[newpath1,'\',name];
    end
    
    saveFlag=true;
    if exist(strcat(fn,'_MultipleStatus','.mat'),'file')
        saveFlag=false;
        choice = questdlg('File exists, overwrite?','discard the previous status','Yes','No','Cancel','No');
        switch choice
            case 'Yes'
                saveFlag=true;
            case 'No'
            case 'Cancel'
                return;
        end
    end
    
    if saveFlag
        if r
            set(Leftt,'enable','off');
            set(Rightt,'enable','off');
            set(ROIselection,'value',0);
            set(Rectanglt,'value',0)
            set(Segpolyt,'value',0)
            set(AutoROIp,'value',0)
            set(f0,'WindowButtonmotionfcn','')
            set(f0,'WindowButtonDownFcn','')
            set(f0,'WindowButtonUpFcn','')

            status.tag='Flash';
            status.filename=name;
            status.xy=xy;
            status.count=count;
            status.currentflash=currentflash;
            status.flashsignal=flashsignal;
            status.image=lsmdata;
            status.map=mapAll;
            status.ROIpoint=ROIpoint;
            status.ROIInfo=ROIInfo;
            status.info_extend=info_extend;
            status.channel=channel;
            status.signalpoint=signalpoint;
            status.info=info;
            status.TraceColor=TraceColor;
            status.TMRMCh=TMRMCh;
            status.cpYFPCh=cpYFPCh;
            status.TPMTCh=TPMTCh;
            status.BCdata=BCdata;
            status.TraceToShow=TraceToShow;
            status.Time=Time;
         
            save(strcat(fn,'_MultipleStatus','.mat'), 'status')

            Filename='';
            lastVal=0;
            signal={};
            count=0;
            ROIpoint={};
            currentflash=0;
            flashsignal={};% will delete in the future
            signalpoint={};
            ROI={};
            ROItext=[];
            cla(drawf.f1)
            cla(drawf.f2)
            cla(drawf.f3)
            cla(drawf.f4)
            cla(trace.f3)
            axis(trace.f3,'off')
            legend(trace.f3,'off')
            set(listboxtemp,'string','');
            r=0;
            rr=0;
            if ~isempty(findobj(panel112,'tag','sliderchannel'))
                delete(findobj(panel112,'tag','sliderchannel'))
            end
            if ~isempty(findobj(panel111,'Style','Checkbox'))
                delete(findobj(panel111,'Style','Checkbox'))
            end
        end
    end
    set(f0,'name','Flash Analysis');
end

function savetracef(~,~) 
    global ROI info_extend channel info Time r signal flashsignal Filename newpath1 Pathname count ROIInfo
%     val = get(s,'Value'); %自动化时此句注释掉，改为下面那句
    val=1;
    if val==2
        roisize=length(ROI);
        if roisize
            namecolor=info_extend.ChannelColors.Names;
            wavelength=info_extend.ScanInfo.WAVELENGTH;
            l=length(wavelength);
            wavelengthC=cell(1,channel);
            if ~iscell(wavelength)
                wavelengthC{1}=wavelength;
            else
                wavelengthC(1:l)=wavelength;
            end
            wavelength=wavelengthC;
%             clear wavelengthC
            if isfield(info,'TimeOffset')
                Time=info.TimeOffset;
            else
                Time=1:r;
            end
            Time=Time';
%                 Name=cell(1,2*channel*roisize);
            data=zeros(r,2*channel*roisize);
            dd=zeros(r,2*channel);

            Name=cell(1,2*channel);
            for j=1:channel
                Name{j}=[namecolor{j},':',num2str(wavelength{j}),''];
            end
            for j=channel+1:2*channel
                Name{j}=['Normal,',namecolor{j-channel},':',num2str(wavelength{j-channel}),''];
            end
            Name=repmat(Name,[1,roisize]);
            for i=1:roisize
                signal=flashsignal{i};
                for j=1:channel
                    dd(:,j)=signal{j};
                end
                for j=channel+1:2*channel
                    dd(:,j)=signal{j-channel}/signal{j-channel}(1);
                end
                data(:,2*channel*(i-1)+1:2*i*channel)=dd;
                for j=1:2*channel
                    Name{2*channel*(i-1)+j}=['ROI','',num2str(i),' ',Name{2*channel*(i-1)+j}];
                end
            end

            Name=cat(2,'Time',Name);
            data=[Time,data];
            if strcmp(Filename(end-3:end),'.lsm')||strcmp(Filename(end-3:end),'.mat')
                Filename=Filename(1:end-4);
            end                
            fn=strcat(Filename, '.xlsx');
            if (newpath1==0)
                fn=[Pathname,'\',fn];
            else
                fn=[newpath1,'\',fn];
            end

            data=num2cell(data);
            data=[Name;data];
            if exist(fn,'file')
                delete(fn)
            end
            xlswrite(fn,data,1,'A1');
        end

    elseif  val==1
        if count
            data=[];
            cname={'ROI','F0','Peak','F_end','deltaF/F0','TimetoPeak','R50','T50','FDHM','class'};
            for id=1:count
                if ~isempty(ROIInfo{id,2})
                    flashpeaks=logical(ROIInfo{id,2}(:,31));
                    if sum(flashpeaks)
                        data=cat(1,data,[id*ones(sum(flashpeaks),1) ROIInfo{id,2}(flashpeaks,[1,3,2,8,12,10,11,9,31])]);
                    end
                end
            end
            xlswrite1(data,'',cname);
        else
            errordlg('There is no data output!','','modal');
        end
    end        
end

function f0Downf(~,~)
    % Figure 上 trace 的buttondown function
    global info Time r f0 trace currentflash signalpoint signal h_R h_P h_D
    if isfield(info,'TimeOffset')
        Time=info.TimeOffset;
    else
        Time=1:r;
    end
%         TimeOffset为相对的绝对时间，单位是秒，为double类型
    if strcmp(get(f0,'selectiontype'),'alt') 
%             'alt'表示单击鼠标右键
        if strcmp(get(f0,'pointer'),'cross')
%                 'cross'表示光标为十字
            curr=get(trace.f3,'currentpoint');
            curr=curr(1,1);
            curr=floor(curr);
%                 floor(curr)取整
            point=signalpoint{currentflash};
            down=point.down;
%                 down为flash终点的横坐标，是最高点后15个以内的最低点的位置。
            base=point.base;
%                 base为flash的起点横坐标，就是直接在trace上选取的点。
            ind=point.ind;
%                 ind为flash峰值的横坐标，是起点15个点以内的最高值所在位置。
            if isempty(base)
                if curr+15<=r
                    ind=find(signal{1}(curr:curr+15)==max(signal{1}(curr:curr+15)));
                    ind=ind(1)+curr-1;
                    if ind>curr
                        pea=signal{1}(ind);
                        down=find(signal{1}(ind:min(r,ind+15))==min(signal{1}(ind:min(r,ind+15))));
                        down=down(1)+ind-1;
                        downpea=signal{1}(down);
                        base=curr;basepea=signal{1}(base);
                        point.base=base;point.basepea=basepea;
                        point.ind=ind;point.pea=pea;
                        point.down=down;point.downpea=downpea;
                    else
                        he=errordlg('Can not creat here!');
                        SetIcon(he);                            
                    end
                elseif r-curr<15
                    ind=find(signal{1}(curr:r)==max(signal{1}(curr:r)));
                    ind=ind(1)+curr-1;
                    if ind<r&&ind>curr
                        pea=signal{1}(ind);
                        down=find(signal{1}(ind:r)==min(signal{1}(ind:r)));
                        down=down(1)+ind-1;
                        downpea=signal{1}(down);
                        base=curr;basepea=signal{1}(base);
                        point.base=base;point.basepea=basepea;
                        point.ind=ind;point.pea=pea;
                        point.down=down;point.downpea=downpea;
                    else
                        he=errordlg('Can not creat here!');
                        SetIcon(he); 
                    end
                end
            else
                small=find(base>curr);
                big=find(base<curr);
                if ~isempty(small)&&~isempty(big)
                    if curr>down(big(end))   
                        id=find(signal{1}(curr:base(small(1)))==max(signal{1}(curr:base(small(1)))));
                        id=id(1)+curr-1;
                        if id<base(small(1))&&id>curr
                            dd=find(signal{1}(id:base(small(1)))==min(signal{1}(id:base(small(1)))));
                            dd=dd(1)+id-1;
                            base=[base(big),curr,base(small)];
                            basepea=[signal{1}(base(big)),signal{1}(curr),signal{1}(base(small))];
                            ind=[ind(big),id,ind(small)];
                            pea=[signal{1}(base(big)),signal{1}(id),signal{1}(base(small))];
                            down=[down(big),dd,down(small)];
                            downpea=[signal{1}(down(big)),signal{1}(dd),signal{1}(down(small))];
                            point.base=base;point.basepea=basepea;
                            point.ind=ind;point.pea=pea;
                            point.down=down;point.downpea=downpea;
                        else
                            he=errordlg('Can not creat here!');
                            SetIcon(he);
                        end
                    else
                        he=errordlg('Can not creat here!');
                        SetIcon(he);                             
                    end
                elseif  ~isempty(small)&&isempty(big)
                    id=find(signal{1}(curr:base(small(1)))==max(signal{1}(curr:base(small(1)))));
                    id=id(1)+curr-1;
                    if id<base(small(1))&&id>curr
                        dd=find(signal{1}(id:base(small(1)))==min(signal{1}(id:base(small(1)))));
                        dd=dd(1)+id-1;
                        base=[curr,base(small)];
                        basepea=signal{1}(base);
                        ind=[id,ind(small)];
                        pea=signal{1}(ind);
                        down=[dd,down(small)];
                        downpea=signal{1}(down);
                        point.base=base;point.basepea=basepea;
                        point.ind=ind;point.pea=pea;
                        point.down=down;point.downpea=downpea;                           
                    else
                        he=errordlg('Can not creat here!');
                        SetIcon(he);
                    end

                elseif isempty(small)&&~isempty(big)
                    if curr+15<=r
                        id=find(signal{1}(curr:curr+15)==max(signal{1}(curr:curr+15)));
                        id=id(1)+curr-1;
                        if id>curr
                            dd=find(signal{1}(id:min(id+15,r))==min(signal{1}(id:min(id+15,r))));
                            dd=dd(1)+id-1;
                            base=[base(big),curr];
                            basepea=signal{1}(base);
                            ind=[ind(big),id];
                            pea=signal{1}(ind);
                            down=[down(big),dd];
                            downpea=signal{1}(down);
                            point.base=base;point.basepea=basepea;
                            point.ind=ind;point.pea=pea;
                            point.down=down;point.downpea=downpea;
                        else
                            he=errordlg('Can not creat here!');
                            SetIcon(he);
                        end
                    elseif r-curr<15
                        id=find(signal{1}(curr:r)==max(signal{1}(curr:r)));
                        id=id(1)+curr-1;
                        if id<r&&id>curr
                            dd=find(signal{1}(id:r)==min(signal{1}(id:r)));
                            dd=dd(1)+id-1;                                
                            base=[base(big),curr];
                            basepea=signal{1}(base);
                            ind=[ind(big),id];
                            pea=signal{1}(ind);
                            down=[down(big),dd];
                            downpea=signal{1}(down);
                            point.base=base;point.basepea=basepea;
                            point.ind=ind;point.pea=pea;
                            point.down=down;point.downpea=downpea;
                        else
                            he=errordlg('Can not creat here!');
                            SetIcon(he);
                        end
                    end
                end
            end  
            signalpoint{currentflash}=point;
%             if ~isempty(point.ind)
%                 [ind,pea,base,basepea,down,~,RiseTime,DownTime,hd,ha]=PointFlashAnalysis(signal{1},point,Time);
%                 ind=[];
%                     pea=[];
%                     base=[];
%                     basepea=[];
%                     down=[];
%                     downpea=[];
%                     RiseTime=[];
%                     DownTime=[];
%                     hd=[];
%                     ha=[];
%                 Rise{currentflash}=RiseTime;
%                 Down{currentflash}=DownTime;
%                 stabledata{currentflash,2}=num2str(ind-base+1);
%                 stabledata{currentflash,3}=num2str((pea-basepea)/basepea);
%                 stabledata{currentflash,4}=num2str(down-ind+1);
%                 stabledata{currentflash,6}=[];
%                 DeltF_F0{currentflash}=(pea-basepea)/basepea;
%                 FDHM{currentflash}=hd;
% %                     FDHM半高宽
%                 FAHM{currentflash}=ha;
% %                     FAHM半高以上面积，没有单位
%                 if RiseTime-DownTime>1
%                     if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
%                         if length(ind)==1
%                             Classf(currentflash)=111;
%                             stabledata{currentflash,5}=111;
%                         else
%                             Classf(currentflash)=112;
%                             stabledata{currentflash,5}=112;
%                         end
%                     else
%                         if length(ind)==1
%                             Classf(currentflash)=121;
%                             stabledata{currentflash,5}=121;
%                         else
%                             Classf(currentflash)=122;
%                             stabledata{currentflash,5}=121;
%                         end
%                     end
%                 elseif DownTime-RiseTime>1
%                     if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
%                         if length(ind)==1
%                             Classf(currentflash)=211;
%                             stabledata{currentflash,5}=211;
%                         else
%                             Classf(currentflash)=212;
%                             stabledata{currentflash,5}=212;
%                         end
%                     else
%                         if length(ind)==1
%                             Classf(currentflash)=221;
%                             stabledata{currentflash,5}=221;
%                         else
%                             Classf(currentflash)=222;
%                             stabledata{currentflash,5}=222;
%                         end
%                     end
%                 else
%                     if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
%                         if length(ind)==1
%                             Classf(currentflash)=311;
%                             stabledata{currentflash,5}=311;
%                         else
%                             Classf(currentflash)=312;
%                             stabledata{currentflash,5}=312;
%                         end
%                     else
%                         if length(ind)==1
%                             Classf(currentflash)=321;
%                             stabledata{currentflash,5}=321;
%                         else
%                             Classf(currentflash)=322;
%                             stabledata{currentflash,5}=322;
%                         end
%                     end
%                 end
%             else
%                 Rise{currentflash}=[];
%                 Down{currentflash}=[];
%                 DeltF_F0{currentflash}=[];
%                 FDHM{currentflash}=[];
%                 FAHM{currentflash}=[];
%                 stabledata{currentflash,2}=[];
%                 stabledata{currentflash,3}=[];
%                 stabledata{currentflash,4}=[];
%                 stabledata{currentflash,5}=[];
%                 stabledata{currentflash,6}=[];
%                 Classf(currentflash)=0;
%             end
%             flg(currentflash)=0;
            if ishandle(h_R)
                delete(h_R)
                delete(h_P)
                delete(h_D)  
            end
            currentmark([],[]);
        end
    end        
end

function PointDownf(obj,e)
    % trace.f3（ROI trace）上的点击响应
    global info Time r f0 signalpoint currentflash h_R h_P h_D signal Rise Down stabledata DeltF_F0 FDHM FAHM...
        Classf flg ROIselection Rectanglt Segpolyt trace line
    if isfield(info,'TimeOffset')
        Time=info.TimeOffset;
    else
        Time=1:r;
    end
    if strcmp(get(f0,'selectiontype'),'normal')
%             'normal'为单击鼠标左键
        current_selected=obj;
        if strcmp(get(obj,'tag'),'0')
            x=get(current_selected,'xdata');
            x=x(1,1);
            point=signalpoint{currentflash};
            ind=point.ind;
            x=find(ind==x);
            set(h_R(x),'Selected','on');
            set(h_P(x),'Selected','on');
            set(h_D(x),'Selected','on');
        elseif strcmp(get(obj,'tag'),'1')
            x=get(current_selected,'xdata');
            x=x(1,1);
            point=signalpoint{currentflash};                
            base=point.base;
            x=find(base==x);
            set(h_R(x),'Selected','on');
            set(h_P(x),'Selected','on');
            set(h_D(x),'Selected','on');                
        elseif strcmp(get(obj,'tag'),'2')
            x=get(current_selected,'xdata');
            x=x(1,1);
            point=signalpoint{currentflash};
            down=point.down;
            x=find(down==x);
            set(h_R(x),'Selected','on');
            set(h_P(x),'Selected','on');
            set(h_D(x),'Selected','on');                
        end


        set(f0,'windowbuttonupfcn',@PointUpf)
        set(f0,'windowbuttonmotionfcn',@PointMotionf)

    elseif strcmp(get(f0,'selectiontype'),'open')
%             'open'为双击鼠标左键
        current_selected=obj;
        if strcmp(get(current_selected,'tag'),'0')
            x=get(current_selected,'xdata');
            x=x(1);
            point=signalpoint{currentflash};
            down=point.down;base=point.base;
            ind=point.ind;

            delete(h_R)
            delete(h_P)
            delete(h_D) 
            x=find(ind==x);
            x=x(1);
            ind(x)=[];
            base(x)=[];
            down(x)=[];

            if ~isempty(ind)
                point.ind=ind;
                point.pea=signal{1}(ind);
                point.down=down;
                point.downpea=signal{1}(down);
                point.base=base;
                point.basepea=signal{1}(base);
            else
                point.ind=ind;
                point.pea=[];
                point.down=down;
                point.downpea=[];
                point.base=base;
                point.basepea=[];
%                     FDHM{currentflash}=[];
%                     FAHM{currentflash}=[];
            end

        elseif strcmp(get(current_selected,'tag'),'1')
            x=get(current_selected,'xdata');
            x=x(1);
            point=signalpoint{currentflash};
            down=point.down;base=point.base;
            ind=point.ind;

            delete(h_R)
            delete(h_P)
            delete(h_D) 
            x=find(base==x);
            x=x(1);
            ind(x)=[];
            base(x)=[];
            down(x)=[];

            if ~isempty(ind)
                point.ind=ind;
                point.pea=signal{1}(ind);                    
                point.down=down;
                point.downpea=signal{1}(down);
                point.base=base;
                point.basepea=signal{1}(base);                    
            else
                point.ind=ind;
                point.pea=[];                    
                point.down=down;
                point.downpea=[];
                point.base=base;
                point.basepea=[];
%                     FDHM{currentflash}=[];
%                     FAHM{currentflash}=[];                   
            end

        elseif strcmp(get(current_selected,'tag'),'2')
            x=get(current_selected,'xdata');
            x=x(1);
            point=signalpoint{currentflash};
            down=point.down;base=point.base;
            ind=point.ind;

            delete(h_R)
            delete(h_P)
            delete(h_D) 
            x=find(down==x);
            x=x(1);                
            ind(x)=[];
            base(x)=[];
            down(x)=[];

            if ~isempty(ind)
                point.ind=ind;
                point.pea=signal{1}(ind);
                point.down=down;
                point.downpea=signal{1}(down);
                point.base=base;
                point.basepea=signal{1}(base);              
            else
                point.ind=ind;
                point.pea=[];                    
                point.down=down;
                point.downpea=[];
                point.base=base;
                point.basepea=[]; 
%                     FDHM{currentflash}=[];
%                     FAHM{currentflash}=[];                   
            end

        end
        signalpoint{currentflash}=point;
        ind=point.ind;
%         if ~isempty(ind)
%             [ind,pea,base,basepea,down,downpea,RiseTime,DownTime,hd,ha]=PointFlashAnalysis(signal{1},point,Time);
%             Rise{currentflash}=RiseTime;
%             Down{currentflash}=DownTime;
%             stabledata{currentflash,2}=num2str(ind-base+1);
%             stabledata{currentflash,3}=num2str((pea-basepea)/basepea);
%             stabledata{currentflash,4}=num2str(down-ind+1);
%             stabledata{currentflash,6}=[];
%             DeltF_F0{currentflash}=(pea-basepea)/basepea;
%             FDHM{currentflash}=hd;
%             FAHM{currentflash}=ha;
%             if RiseTime-DownTime>1
%                 if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
%                     if length(ind)==1
%                         Classf(currentflash)=111;
%                         stabledata{currentflash,5}=111;
%                     else
%                         Classf(currentflash)=112;
%                         stabledata{currentflash,5}=112;
%                     end
%                 else
%                     if length(ind)==1
%                         Classf(currentflash)=121;
%                         stabledata{currentflash,5}=121;
%                     else
%                         Classf(currentflash)=122;
%                         stabledata{currentflash,5}=121;
%                     end
%                 end
%             elseif DownTime-RiseTime>1
%                 if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
%                     if length(ind)==1
%                         Classf(currentflash)=211;
%                         stabledata{currentflash,5}=211;
%                     else
%                         Classf(currentflash)=212;
%                         stabledata{currentflash,5}=212;
%                     end
%                 else
%                     if length(ind)==1
%                         Classf(currentflash)=221;
%                         stabledata{currentflash,5}=221;
%                     else
%                         Classf(currentflash)=222;
%                         stabledata{currentflash,5}=222;
%                     end
%                 end
%             else
%                 if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
%                     if length(ind)==1
%                         Classf(currentflash)=311;
%                         stabledata{currentflash,5}=311;
%                     else
%                         Classf(currentflash)=312;
%                         stabledata{currentflash,5}=312;
%                     end
%                 else
%                     if length(ind)==1
%                         Classf(currentflash)=321;
%                         stabledata{currentflash,5}=321;
%                     else
%                         Classf(currentflash)=322;
%                         stabledata{currentflash,5}=322;
%                     end
%                 end
%             end
%         else
%             FDHM{currentflash}=[];
%             FAHM{currentflash}=[];
%             Rise{currentflash}=[];
%             Down{currentflash}=[];
%             DeltF_F0{currentflash}=[];
%             stabledata{currentflash,2}=[];
%             stabledata{currentflash,3}=[];
%             stabledata{currentflash,4}=[];
%             stabledata{currentflash,5}=[];
%             stabledata{currentflash,6}=[];
%             FDHM{currentflash}=[];
%             FAHM{currentflash}=[];
%             Classf(currentflash)=0;
%         end
% 
%         flg(currentflash)=0;
        currentmark(obj,e);
    end

    function PointUpf(s,e)
        if current_selected~=0
            set(h_R,'Selected','off');
            set(h_P,'Selected','off');
            set(h_D,'Selected','off');

%             [ind,pea,base,basepea,down,downpea,RiseTime,DownTime,hd,ha]=PointFlashAnalysis(signal{1},point,Time);

%             if ~isempty(ind)
%                 Rise{currentflash}=RiseTime;
%                 Down{currentflash}=DownTime;
%                 stabledata{currentflash,2}=num2str(ind-base+1);
%                 stabledata{currentflash,3}=num2str((pea-basepea)/basepea);
%                 stabledata{currentflash,4}=num2str(down-ind+1);
%                 stabledata{currentflash,6}=[];
%                 DeltF_F0{currentflash}=(pea-basepea)./basepea;
%                 FDHM{currentflash}=hd;
%                 FAHM{currentflash}=ha;
%                 if RiseTime-DownTime>1
%                     if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
%                         if length(ind)==1
%                             Classf(currentflash)=111;
%                             stabledata{currentflash,5}=111;
%                         else
%                             Classf(currentflash)=112;
%                             stabledata{currentflash,5}=112;
%                         end
%                     else
%                         if length(ind)==1
%                             Classf(currentflash)=121;
%                             stabledata{currentflash,5}=121;
%                         else
%                             Classf(currentflash)=122;
%                             stabledata{currentflash,5}=121;
%                         end
%                     end
%                 elseif DownTime-RiseTime>1
%                     if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
%                         if length(ind)==1
%                             Classf(currentflash)=211;
%                             stabledata{currentflash,5}=211;
%                         else
%                             Classf(currentflash)=212;
%                             stabledata{currentflash,5}=212;
%                         end
%                     else
%                         if length(ind)==1
%                             Classf(currentflash)=221;
%                             stabledata{currentflash,5}=221;
%                         else
%                             Classf(currentflash)=222;
%                             stabledata{currentflash,5}=222;
%                         end
%                     end
%                 else
%                     if (pea(1)-signal{1}(ind(1)-1))>(pea(1)-basepea(1))/(ind(1)-base(1))
%                         if length(ind)==1
%                             Classf(currentflash)=311;
%                             stabledata{currentflash,5}=311;
%                         else
%                             Classf(currentflash)=312;
%                             stabledata{currentflash,5}=312;
%                         end
%                     else
%                         if length(ind)==1
%                             Classf(currentflash)=321;
%                             stabledata{currentflash,5}=321;
%                         else
%                             Classf(currentflash)=322;
%                             stabledata{currentflash,5}=322;
%                         end
%                     end
%                 end
%             else
%                 Rise{currentflash}=[];
%                 Down{currentflash}=[];
%                 DeltF_F0{currentflash}=[];
%                 stabledata{currentflash,2}=[];
%                 stabledata{currentflash,3}=[];
%                 stabledata{currentflash,4}=[];
%                 stabledata{currentflash,5}=[];
%                 stabledata{currentflash,6}=[];
%                 FDHM{currentflash}=[];
%                 FAHM{currentflash}=[];
%                 Classf(currentflash)=0;
%             end
%             flg(currentflash)=0;
            current_selected=0;
            if get(ROIselection,'value')==1
                ROIselectionf(s,e);
            elseif get(Rectanglt,'value')==1
                retangle(s,e);
            elseif get(Segpolyt,'value')==1
                poly(s,e);
            end
        end
    end

    function PointMotionf(~,~)

        ylim=get(trace.f3,'ylim');
        xlim=get(trace.f3,'xlim');
        pd=get(trace.f3,'currentpoint');

        if pd(1,1)>=xlim(1)&&pd(1,1)<=xlim(1)+xlim(2)&&pd(1,2)>=ylim(1)&&pd(1,2)<=ylim(1)+ylim(2)
            if current_selected~=0

                set(f0,'pointer','hand')
                xy_sstart=pd;
                xy_sstart=xy_sstart(1,1);
                [~,xy_sstart]=min(abs(Time-xy_sstart));
                try
                    set(current_selected,'XData',[xy_sstart,xy_sstart],'YData',[signal{1}(xy_sstart),signal{1}(xy_sstart)]);
                catch e
                    disp(xy_sstart)
                end
                if strcmp(get(current_selected,'tag'),'1')
                    point=signalpoint{currentflash};
                    line=findobj('parent',trace.f3,'tag','1');
                    base=zeros(1,length(line));
                    for i=1:length(line)
                        x=get(line(i),'xdata');
                        base(i)=x(1);
                    end
                    base=sort(base);
                    basepea=signal{1}(base);
                    point.base=base;
                    point.basepea=basepea;
                    signalpoint{currentflash}=point;

                elseif strcmp(get(current_selected,'tag'),'0')
                    point=signalpoint{currentflash};
                    line=findobj('parent',trace.f3,'tag','0');
                    base=zeros(1,length(line));
                    for i=1:length(line)
                        x=get(line(i),'xdata');
                        base(i)=x(1);
                    end
                    basepea=signal{1}(base);
                    point.ind=base;
                    point.pea=basepea;
                    signalpoint{currentflash}=point;                        
                elseif strcmp(get(current_selected,'tag'),'2')
                    point=signalpoint{currentflash};
                    line=findobj('parent',trace.f3,'tag','2');
                    base=zeros(1,length(line));
%                         basepea=zeros(1,length(line));
                    for i=1:length(line)
                        x=get(line(i),'xdata');
                        base(i)=x(1);                          
                    end
                    base=sort(base);
                    basepea=signal{1}(base);
                    point.down=base;
                    point.downpea=basepea;
                    signalpoint{currentflash}=point;                        
                end
                set(f0,'windowbuttonupfcn',@PointUpf)

            end                

        else
            set(f0,'pointer','arrow');
        end
    end
end

function listboxf(~,~)
    % 文件列表点击响应
    global Filename panel112 panel111 listbox
    % 自动化时不问是否保存
    if ~strcmp(Filename,'')
        choice = questdlg('save the previous status?','discard the previous status','Yes','No','Cancel','No');
            switch choice
                case 'Yes'
                    savestatusf;
                case 'No'
                case 'Cancel'
                    return;
            end
    end

    if ~isempty(findobj(panel112,'tag','sliderchannel'))
        delete(findobj(panel112,'tag','sliderchannel'))
    end
    if ~isempty(findobj(panel111,'Style','Checkbox'))
        delete(findobj(panel111,'Style','Checkbox'))
    end

    filename1=get(listbox,'String');  

    Filename=filename1{get(listbox,'value')};
    showImageWithFilename;
end

function showImageWithFilename(~,~) 
%     tic
    global Filename panel112 panel111 listboxtemp Leftt Rightt ROIselection Rectanglt Segpolyt AutoROIp f0 signal count...
        ROIpoint stabledata currentflash flashsignal signalpoint ROI ROIInfo ROItext drawf...
        trace Pathname lsmdata info xy r row col zstack bits lsm_image info_extend channel channelcheckbox imAll...
        lastVal1 rrchannel BCdata sliderB sliderC panel12 slider rr lastVal mapAll...
        th threshold namecolor Time timeh TMRMCh cpYFPCh TPMTCh TraceToShow offsets Mergebutton
    
    set(Leftt,'enable','off');
    set(Rightt,'enable','off');
    set(ROIselection,'value',0);
    set(Rectanglt,'value',0)
    set(Segpolyt,'value',0)
    set(AutoROIp,'value',0)
    set(f0,'WindowButtonmotionfcn','')
    set(f0,'WindowButtonDownFcn','')
    set(f0,'WindowButtonUpFcn','')
    set(Mergebutton,'value',0);
    
    wb=waitbar(0);
        
    signal=0;
    count=0;
    ROIpoint={};
    stabledata={};
    currentflash=0;
    flashsignal={};% will delete in the future
    signalpoint={};
    ROIInfo={};
    ROI={};
    ROItext=[];
    cla(drawf.f2)
    cla(drawf.f3)
    cla(drawf.f4)
    cla(trace.f3)
    axis(trace.f3,'off')
    legend(trace.f3,'off')
    set(listboxtemp,'string','');

    if isempty(Filename)
        return;
    end

    str=[Pathname,'\', Filename];
    clipboard('copy',Filename);
    [~, ~, ext] = fileparts(Filename);

    if strcmp(ext,'.lsm')
        lsmdata=tiffread(str);
        info=lsmdata(1).lsm;
        xy.VoxelSizeX=info.VoxelSizeX;
        xy.VoxelSizeY=info.VoxelSizeY;
        r=length(lsmdata);
        row=info.DimensionX;
        col=info.DimensionY;
        zstack=info.DimensionZ;
        bits=lsmdata(1).bits ;

    elseif strcmp(ext,'.tif')
        [lsm_image,info,xy]=tifread(str);
        disp('row,col')
        [row,col]=size(lsm_image(:,:,1));
    end
    [lsminf,~,~]=lsminfo(str);
    info_extend=lsminf;
    channel=lsminf.NUMBER_OF_CHANNELS;
    namecolor=lsminf.ChannelColors.Names;
    
    if isfield(info,'TimeOffset')
        Time=info.TimeOffset;
    else
        Time=1:r;
    end

%     toc
    if channel>1
        channelcheckbox=zeros(1,channel);
        for i=1:channel
            ss=[namecolor{i}];
            channelcheckbox(i)=uicontrol(panel111,'Style', 'checkbox', 'String', ss,'units','Normalized','position',[(i-1)/4,0.8,1/4,0.2],'callback',@adjustBC,'value',1);
        end
        sliderchannel=uicontrol(panel112,'style','slider','units','Normalized','position',[0,0.8,1,0.2],'enable','on','value',0,'callback',@SelectChannelf,'tag','sliderchannel');
        set(sliderchannel,'enable','on');
        eachstep=[1/(channel-1),1/(channel-1)];
        set(sliderchannel,'sliderstep',eachstep,'value',0);
        lastVal1 = get(sliderchannel, 'Value');
        eachstep=get(sliderchannel,'sliderstep');
        rrchannel=round(lastVal1/eachstep(1))+1;
    else
        rrchannel=1;
        ss=[namecolor{1}];
        uicontrol(panel111,'Style', 'checkbox', 'String', ss,'units','Normalized','position',[(1-1)/4,0.8,1/4,0.2],'tag',['Checkbox',num2str(1)],'value',1);
    end

    BCdata=[0;0]*ones(1,channel);
    set(sliderB,'value',0);
    set(sliderC,'value',0);
    screen=get(0,'ScreenSize');

    SetLocation(f0,drawf.f1,row,col,screen,panel12)
    SetLocation(f0,drawf.f2,row,col,screen,panel12)
    SetLocation(f0,drawf.f3,row,col,screen,panel12)
    SetLocation(f0,drawf.f4,row,col,screen,panel12)
    set(drawf.f1,'xlim',[1,row],'ylim',[1,col]);
    set(drawf.f2,'xlim',[1,row],'ylim',[1,col]);
    set(drawf.f3,'xlim',[1,row],'ylim',[1,col]);
    set(drawf.f4,'xlim',[1,row],'ylim',[1,col]);
    if channel==1
        for i=1:r
            lsm(i).data{1}=lsmdata(i).data;
        end
        lsmdata=lsm;
%         clear lsm;
    end
    
    offsets=zeros(r,2);
    count1=1;
    total=r;
    for i=2:r
        offsets(i,:)=image_correlation_offset(lsmdata(1).data{3},lsmdata(i).data{3}); %以Ch-1 T-1，通常是cpYFP来配准
        count1=count1+1;
        waitbar(count1/total,wb)
    end
    imAll=zeros(col,row,channel,r);
    for i1=1:channel
        imAll(:,:,i1,1)=lsmdata(1).data{i1};
        for i=2:r
            lsmdata(i).data{i1}=translate_offset(lsmdata(i).data{i1},offsets(i,1),offsets(i,2));
            imAll(:,:,i1,i)=lsmdata(i).data{i1};
        end
    end
    delete(wb)
% toc
    
    imAll=uint8(mean(imAll,4));

    if r==1
        set(slider,'enable','off');
        rr=1;
    else
        set(slider,'enable','on');
        eachstep=[1/(r-1),1/(r-1)];
        set(slider,'sliderstep',eachstep,'value',0);
        lastVal = get(slider, 'Value');
        rr=round(lastVal/eachstep(1))+1;
        str=strcat(num2str(rr),'/',num2str(r)); 
        set(timeh,'string',str) 
    end
    
    for id=1:length(namecolor)
        try
            if strcmp(namecolor{id},'Ch1-T1');cpYFPCh=id;end
            if strcmp(namecolor{id},'Ch2-T2');TMRMCh=id;end
            if strcmp(namecolor{id}(1:5),'T PMT');TPMTCh=id;end
        end
    end
    assignColor;
    TraceToShow=TMRMCh;
    
    imshow(uint8(lsmdata(1).data{1}./2^(bits-8)),mapAll{1},'parent',drawf.f1)
    im=lsmdata(1).data{1};
    level=graythresh(im);
    th=double(max(max(im))-min(min(im)))*level+double(min(min(im)));
    th=floor(th);
    set(threshold,'string',num2str(th));

    set(f0,'name',['Flash Analysis              ',Filename]);
%     toc

% %以下两句自动化
% autof([],[])
% savetracef([],[])
% extractAllFlashes
% calMeanFluorescence;
% calTMRMSum
end

function SelectChannelf(s,~)
    % 通道选择滚动条
    global lsmdata lastVal1 rrchannel sliderB BCdata sliderC rr bits mapAll drawf BCChangeFlag
    BCChangeFlag=true;
     if ~isempty(lsmdata)
        if get(s, 'Value') ~= lastVal1
            lastVal1 = get(s, 'Value');
            eachstep=get(s,'sliderstep');
            rrchannel=round(lastVal1/eachstep(1))+1;
            set(sliderB,'value',BCdata(1,rrchannel));
            set(sliderC,'value',BCdata(2,rrchannel));
            imshow(adjustedBCdata(uint8(lsmdata(rr).data{rrchannel}./2^(bits-8))),mapAll{rrchannel},'parent',drawf.f1)
        end
     end
end

function sliderf(~,~)
    % 桢选择滚动条
    global lsmdata slider lastVal rr rrchannel bits mapAll drawf timeh r count ShowTracker trace hlabel
    if ~isempty(lsmdata)
%             get(slider,'Value')
        if get(slider, 'Value') ~= lastVal
            lastVal = get(slider, 'Value');
            eachstep=get(slider,'sliderstep');
            tmp=rr;
            rr=round(lastVal/eachstep(1))+1;
%                 rrchannel
            if tmp==rr;return;end
            imshow(adjustedBCdata(uint8(lsmdata(rr).data{rrchannel}./2^(bits-8))),mapAll{rrchannel},'parent',drawf.f1)
            str=strcat(num2str(rr),'/',num2str(r)); 
            set(timeh,'string',str) 

            if count>0
                if get(ShowTracker,'value')==1
                    ylim=get(trace.f3,'ylim');
                    if ishandle(hlabel)
                        delete(hlabel)
                    end
                    hlabel=line('xdata',[rr,rr],'ydata',ylim,'color','r','parent',trace.f3);
                else
                    if ishandle(hlabel)
                        delete(hlabel)
                    end
                end
            end                
        end
    end
end

function closereq(~,~)
    % 关闭主窗口
    global f0
    delete(f0)
    delete('lsm_image.mat')
end

function Table_Selection(s,~)
    % ROI列表选取的响应
    global currentflash trace ROI ROItext count Leftt Rightt signal flashsignal
    if currentflash>0
        cla(trace.f3);
        set(ROI{currentflash},'color',[1,1,1])
        set(ROItext(currentflash),'color',[0.8,0.8,0])
        selected_cells = get(s,'value');
        if ~isempty(selected_cells)
            currentflash=selected_cells;
            if count==1
                set(Leftt,'enable','off')
                set(Rightt,'enable','off')
            else
                if currentflash==1
                    set(Leftt,'enable','off')
                    set(Rightt,'enable','on')
                elseif currentflash==count
                    set(Leftt,'enable','on')
                    set(Rightt,'enable','off')
                else
                    set(Leftt,'enable','on')
                    set(Rightt,'enable','on')
                end
            end

            set(ROI{currentflash},'color','r')
            set(ROItext(currentflash),'color','r')              
            signal=flashsignal{currentflash};
            plotOnTracef3;
            currentmark([],[]);
        end

%         clear selected_cells l x1 point x1 x2 y2 hh
%         pack
    end

end

function currentmark(~,~)
    % 在ROI的trace上做flash的三点标记
    global signalpoint currentflash h_R h_P h_D trace
    if ~isempty(signalpoint)
        point=signalpoint{currentflash};
        if ~isempty(point.ind)
            hold(trace.f3,'on')
            h_R=[];h_P=[];h_D=[];
            for i=1:length(point.ind)
                h_R(i)=line('XData',point.ind(i),'YData',point.pea(i),'Marker','s','color','r','markersize',10,'tag','0','parent',trace.f3);
                h_P(i)=line('XData',point.base(i),'YData',point.basepea(i),'Marker','*','color','r','markersize',10,'tag','1','parent',trace.f3);
                h_D(i)=line('XData',point.down(i),'YData',point.downpea(i),'Marker','o','color','r','markersize',10,'tag','2','parent',trace.f3);
            end
            hold(trace.f3,'off')
            set(h_R,'buttondownfcn',@PointDownf)
            set(h_P,'buttondownfcn',@PointDownf)
            set(h_D,'buttondownfcn',@PointDownf)
        end
    end
end

function load_status(~,~)
    % 加载状态
    global newpathload_status Filename Leftt Rightt ROIselection Rectanglt Segpolyt AutoROIp f0 xy count...
        currentflash flashsignal lsmdata mapAll ROIpoint ROIInfo channelcheckbox TraceColor BCdata...
        info_extend channel signalpoint info Pathname lastVal signal slider bits Time TMRMCh cpYFPCh TPMTCh...
        drawf ROI ROItext trace listboxtemp r rr panel112 panel111 row col lastVal1 rrchannel panel12 TraceToShow
    
    exFilename=Filename;
    if ~exist('newpath','var')||isempty(newpathload_status)
        newpathload_status=Pathname;
    end
    if ~isempty(Filename)
        if Filename==0
            [Filename, pathname] = uigetfile({'*.mat'},'Load status',newpathload_status);
        else
            try 
                str=[newpathload_status,'\',Filename];
                [Filename, pathname] = uigetfile({'*.mat'},'Load status',str);
            catch ex 
                [Filename, pathname] = uigetfile({'*.mat'},'Load status',newpathload_status);
            end
        end
    else
        [Filename, pathname] = uigetfile({'*.mat'},'Load status',newpathload_status);

    end
    if Filename~=0
        newpathload_status=pathname;
    end

    if Filename
        if ~isempty(findobj(panel112,'tag','sliderchannel'))
            delete(findobj(panel112,'tag','sliderchannel'))
        end
        if ~isempty(findobj(panel111,'Style','Checkbox'))
            delete(findobj(panel111,'Style','Checkbox'))
        end

        str=[pathname,Filename];
        clipboard('copy',Filename);
        status=load(str);
        status=status.status;
        if strcmp(status.tag,'Flash')
            set(Leftt,'enable','off');
            set(Rightt,'enable','off');
            set(ROIselection,'value',0);
            set(Rectanglt,'value',0)
            set(Segpolyt,'value',0)
            set(AutoROIp,'value',0)
            set(f0,'WindowButtonmotionfcn','')
            set(f0,'WindowButtonDownFcn','')
            set(f0,'WindowButtonUpFcn','')

            signal=0;
            signalpoint={};
            ROIInfo={};
            ROI={};
            ROItext=[];
            info_extend=[];

            cla(drawf.f2)
            cla(drawf.f3)
            cla(drawf.f4)
            cla(trace.f3)
            axis(trace.f3,'off')
            legend(trace.f3,'off')
            set(listboxtemp,'string','');
            flashsignal={};% will delete in the future
%             Filename=status.filename;
            xy=status.xy;
            count=status.count;
            currentflash=status.currentflash;

            tf = isfield(status, 'info_extend');
            if tf==0
                info_extend.ChannelColors.Names=[];
                info_extend.ScanInfo.WAVELENGTH=[];
                info.DimensionX=0;
                info.DimensionY=0;
                mapAll{1}=status.map;
                ROIpoint=status.ROIpoint;
                info='';
                channel=1;
                lsmdata=status.image;
                [row,col,~]=size(lsmdata);
                if channel==1
                    for i=1:r
                        lsm(i).data{1}=lsmdata(:,:,i);
                    end
                    lsmdata=lsm;
                end
                namecolor{1}='Ch-T1';
                wavelength{1}=488;
                info_extend.ChannelColors.Names=namecolor;
                info_extend.ScanInfo.WAVELENGTH=wavelength;
                info.DimensionX=row;
                info.DimensionY=col;
            else
                info_extend=status.info_extend;
                mapAll=status.map;
                lsmdata=status.image;
                TraceColor=status.TraceColor;
                flashsignal=status.flashsignal;
                info=status.info;                
                row=info.DimensionX;
                col=info.DimensionY;
                namecolor=info_extend.ChannelColors.Names;
                wavelength=info_extend.ScanInfo.WAVELENGTH;
                channel=status.channel;
                ROIpoint=status.ROIpoint;
                ROIInfo=status.ROIInfo;
                signalpoint=status.signalpoint;
                TMRMCh=status.TMRMCh;
                cpYFPCh=status.cpYFPCh;
                TPMTCh=status.TPMTCh;
                BCdata=status.BCdata;
                TraceToShow=status.TraceToShow;
                Time=status.Time;
            end

            if ~iscell(wavelength)
                wave{1}=488;
                wavelength=wave;
                color{1}='Ch-T1';
                namecolor{1}=color;
                info_extend.ChannelColors.Names=namecolor;
                info_extend.ScanInfo.WAVELENGTH=wavelength;
            end
            l=length(wavelength);
            wavelengthC=cell(1,channel);
            wavelengthC(1:l)=wavelength;
            wavelength=wavelengthC;

            if count>0
                currentflash=count;
                for k=1:count
                    poin=ROIpoint{k};
                    x=poin.x;
                    y=poin.y;
                    hh=line('XData',x,'YData', y,'color',[1,1,1],'LineWidth',1,'parent',drawf.f3);
                    ROI{k}=hh;
                    h5=text(mean(x),mean(y),num2str(k),'color',[0.8,0.8,0],'Parent',drawf.f2);
                    ROItext(k)=h5;
                    
                end          
                set(ROItext(currentflash),'color','r');
                set(ROI{currentflash},'color','r');
                currentflash=count;
                signal=flashsignal{currentflash};
                plotOnTracef3;
                currentmark([],[]);
                set(listboxtemp,'string',ROIInfo(:,1),'value',currentflash);      
            end
            screen=get(0,'ScreenSize');
            SetLocation(f0,drawf.f1,row,col,screen,panel12)
            SetLocation(f0,drawf.f2,row,col,screen,panel12)
            SetLocation(f0,drawf.f3,row,col,screen,panel12)
            SetLocation(f0,drawf.f4,row,col,screen,panel12)
            set(drawf.f1,'xlim',[1,row],'ylim',[1,col]);
            set(drawf.f2,'xlim',[1,row],'ylim',[1,col]);
            set(drawf.f3,'xlim',[1,row],'ylim',[1,col]);
            set(drawf.f4,'xlim',[1,row],'ylim',[1,col]);

            r=length(lsmdata);
            if r==1
                set(slider,'enable','off');
                rr=1;
            else
                set(slider,'enable','on');
                eachstep=[1/(r-1),1/(r-1)];
                set(slider,'sliderstep',eachstep,'value',0);
                lastVal = get(slider, 'Value');
                eachstep=get(slider,'sliderstep');
                rr=round(lastVal/eachstep(1))+1;
            end
            imshow(uint8(lsmdata(1).data{1}./2^(bits-8)),mapAll{1},'parent',drawf.f1)
            set(ROIselection,'value',0);
            set(Rectanglt,'value',0)
            set(Segpolyt,'value',0)
            set(f0,'name',['Flash Analysis              ',Filename]);
        else
            he=errordlg('There is no data output!','','modal');
            SetIcon(he);
            return;
        end
        
        if channel>1
            channelcheckbox=zeros(1,channel);
            for i=1:channel
                ss=[namecolor{i}];
                channelcheckbox(i)=uicontrol(panel111,'Style', 'checkbox', 'String', ss,'units','Normalized','position',[(i-1)/4,0.8,1/4,0.2],'callback',@adjustBC,'value',1);
            end
            sliderchannel=uicontrol(panel112,'style','slider','units','Normalized','position',[0,0.8,1,0.2],'enable','on','value',0,'callback',@SelectChannelf,'tag','sliderchannel');
            set(sliderchannel,'enable','on');
            eachstep=[1/(channel-1),1/(channel-1)];
            set(sliderchannel,'sliderstep',eachstep,'value',0);
            lastVal1 = get(sliderchannel, 'Value');
            eachstep=get(sliderchannel,'sliderstep');
            rrchannel=round(lastVal1/eachstep(1))+1;
        else
            rrchannel=1;
            ss=[namecolor{1}];
            uicontrol(panel111,'Style', 'checkbox', 'String', ss,'units','Normalized','position',[(1-1)/4,0.8,1/4,0.2],'tag',['Checkbox',num2str(1)],'value',1);
        end
        Filename=status.filename;
    else
        Filename=exFilename;
    end
end

function savef(~,~)
    global currentflash ROIInfo
%         data=get(stabledata,'data');
    if isempty(ROIInfo)
        he=errordlg('There is no data output!','modal');
        SetIcon(he);
    else
        cname={'F0','Peak','F_end','deltaF/F0','TimetoPeak','R50','T50','FDHM','class'};
        flashpeaks=logical(ROIInfo{currentflash,2}(:,31));
        if sum(flashpeaks)
            data=ROIInfo{currentflash,2}(flashpeaks,[1,3,2,8,12,10,11,9,31]);
        end
        xlswrite1(data,'',cname);
    end
end

function opennamef(~,~)
    % 列出文件夹中全部lsm文件
    global Pathname listbox
    %         fid=fopen(OpenTxt());
    namelist=dir([Pathname,'\*.lsm']);
    try 
        fname=cell(length(namelist),1);
        for ind=1:length(namelist)
            fname{ind}=namelist(ind).name;
        end
        set(listbox,'string',fname,'value',1);
    catch ex 
    end
end

function openFL(~,~)
    %打开txt的文件列表
    global listbox
    fid=fopen(OpenTxt());  

    try 
        tline=fgetl(fid);
        j=1;
        fname{j}=tline;        
        while ischar(tline)
            tline=fgetl(fid); 
            j=j+1;
            fname{j}=tline;            
        end
        set(listbox,'String',fname(1:(j-1)));
        fclose(fid);
    catch ex 
    end
end

function fullname=OpenTxt()
    % 打开有文件名的txt
    global newpath1
    [filename, pn] = uigetfile({'*.txt'},'select file',newpath1,'MultiSelect','off');

    if ~isempty(filename)
        fullname=[pn,'\',filename];
    else
        fullname='';
    end
end

function adjustBC(~,~)
    % 调亮度对比度
    global lsmdata BCdata sliderB sliderC rrchannel bits mapAll drawf rr Show_mean imAll BCChangeFlag
    BCChangeFlag=true;
    if ~isempty(lsmdata)
        BCdata(1,rrchannel)=get(sliderB,'value');
        BCdata(2,rrchannel)=get(sliderC,'value');
        if strcmp(get(Show_mean,'state'),'off')
            imshow(adjustedBCdata(uint8(lsmdata(rr).data{rrchannel}./2^(bits-8))),mapAll{rrchannel},'parent',drawf.f1);
        else
            imshow(adjustedBCdata(uint8(imAll(:,:,rrchannel)./2^(bits-8))),mapAll{rrchannel},'parent',drawf.f1)
        end
    end
end

function Rt=adjustedBCdata(origindata)
    % 调亮度对比度
    global lsmdata BCdata rrchannel Mergebutton channelcheckbox channel mapAll rr MergedImage BCChangeFlag
    Rt=origindata*10^BCdata(2,rrchannel)+BCdata(1,rrchannel)*255;
    if get(Mergebutton,'value')
        if BCChangeFlag
            channelchecked=cell2mat(get(channelcheckbox,'value'));
            if sum(channelchecked)==0
                set(channelcheckbox(1),'value',1);
                channelchecked(1)=1;
            end
            imagedata=zeros(size(origindata,1),size(origindata,2),3,sum(channelchecked));
            for ind=1:channel
                if channelchecked(ind)
                    imagedata(:,:,:,ind)=ind2rgb(lsmdata(rr).data{ind}*10^BCdata(2,ind)+BCdata(1,ind)*255,mapAll{ind});
                end
            end
            Rt=sum(imagedata,4);
            BCChangeFlag=false;
        else
            if ~isempty(MergedImage)
                Rt=MergedImage{rr};
            end
        end
    end
end

function MergeAll(varargin)
    global MergedImage lsmdata BCdata channelcheckbox channel mapAll r
    channelchecked=cell2mat(get(channelcheckbox,'value'));
    imagedata=zeros(size(lsmdata(1).data{1},1),size(lsmdata(1).data{1},2),3,sum(channelchecked));
    MergedImage=cell(1,r);
    wb=waitbar(0);
    for id=1:r
        for ind=1:channel
            if channelchecked(ind)
                imagedata(:,:,:,ind)=ind2rgb(lsmdata(id).data{ind}*10^BCdata(2,ind)+BCdata(1,ind)*255,mapAll{ind});
            end
        end
        MergedImage{id}=sum(imagedata,4);
        waitbar(id/r,wb);
    end
    delete(wb)
end

function autof(~,~)
    % 自动画ROI
    global f0 r drawf trace count currentflash imAll hideROIf...
        statush ROIInfo flashsignal signal...
        ROItext ROI ROIpoint Leftt Rightt hidef listboxtemp...
        TMRMCh cpYFPCh

    channelForAutoROI=num2str(cpYFPCh);
%     channelForAutoROI=num2str(TMRMCh);        
    if r>1
% 自动化时以下三句注释掉
%         channelForAutoROI1=inputdlg('input the channel for auto ROI','',1,{channelForAutoROI});
%         if isempty(channelForAutoROI1);return;end
%         channelForAutoROI=channelForAutoROI1{1};
        set(statush,'string','Busy')
        set(f0,'WindowButtonMotionFcn','')
        cla(trace.f3)
        % imAll是所有通道的时间序列平均值
        meanIm=imAll(:,:,str2double(channelForAutoROI));
        autoROI(meanIm,[cpYFPCh TMRMCh]);
        ROItext=zeros(1,count);
        ROI=cell(1,count);
        if count
            for i=1:count
                point=ROIpoint{i};
                xx=point.x;yy=point.y;   
                hh=line('XData',xx,'YData', yy,'color',[1,1,1],'LineWidth',1,'parent',drawf.f3);
                h5=text(mean(xx(1:end-1)),mean(yy(1:end-1)),num2str(i),'Parent',drawf.f2);
                set(h5,'color',[0.8,0.8,0],'HorizontalAlignment','center')
                ROItext(i)=h5;             
                ROI{i}=hh;
            end
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
        
        signal=flashsignal{currentflash};        
        plotOnTracef3;
        status=get(hidef,'value');
        if status==1
            for i=1:count
                set(ROItext(i),'visible','off')
            end
        end

        status=get(hideROIf,'value');

        if status==1
            for i=1:count
                set(ROItext(i),'visible','off')
                set(ROI{i},'visible','off')
            end
        end

        set(listboxtemp,'string',ROIInfo(:,1),'value',count);

        currentmark([],[]);
        if currentflash>1
            set(Leftt,'enable','on')
            set(Rightt,'enable','off')
        else
            set(Leftt,'enable','off')
            set(Rightt,'enable','off')
        end
        recover([],[]);
        set(statush,'string','Ready')
    end
end

function datacursoron(~,~)
    global Select
    datacursormode on
    set(Select,'state','off')
end

function datacursoroff(~,~)
    datacursormode off
end

function BatchAutomaticDrawROI(~,~)
    %批量自动画ROI
    global Pathname Filename ROIpoint count flashsignal lsmdata r channel ...
        imAll meanIm TMRMCh cpYFPCh
    clc

    [filename, pathname] = uigetfile({'*.lsm'},'select file',Pathname,'MultiSelect','on');
    
    if ~iscell(filename)
        if filename==0
            return
        end
        filename={filename};
    end
    Pathname=pathname;

    if ~isempty(filename)
        if Pathname
            mkdir(Pathname,'AutoROI')
        end
        ll=length(filename);
        for ii=1:ll
            Filename=filename{ii}; 
            showImageWithFilename;
            
            channelForAutoROI=num2str(TMRMCh);
            
            meanIm=imAll(:,:,str2double(channelForAutoROI));
            [ROIpoint count flashsignal]=autoROI(meanIm,lsmdata,r,channel,[cpYFPCh TMRMCh]);
            
            save([Pathname,'AutoROI\',Filename(1:end-4),'.mat'],'ROIpoint','count','flashsignal','Time','namecolor');
            disp([num2str(ii),' / ',num2str(ll)])
        end
    end
end

function ResetBC(~,~)
    % 亮度对比度归中
    global sliderB sliderC
    set(sliderB,'value',0);
    set(sliderC,'value',0);
    adjustBC;
end

function showMeanImage(~,~)
    % 显示时间序列上所有图片叠加后的图像
    global imAll bits mapAll drawf rrchannel
    imshow(adjustedBCdata(uint8(imAll(:,:,rrchannel)./2^(bits-8))),mapAll{rrchannel},'parent',drawf.f1)
end

function plotOnTracef3
    % 把trace画出来
    global trace TraceColor signal TraceToShow

    cla(trace.f3)
    h=plot(trace.f3,signal{1},'color',TraceColor{1},'LineWidth',2,'tag','hs');
    set(h,'buttondownfcn',@f0Downf);
    hold(trace.f3,'on');
    for j=TraceToShow
        plot(trace.f3,signal{j},'color',TraceColor{j},'LineWidth',2,'tag','hs');
    end
    hold(trace.f3,'off')
    set(trace.f3,'outerposition',[0,0,1,1]);
    axis(trace.f3,'on')
%     set(trace.f3,'ylim',[0 100]);
end

function formROIInfoAndsignalpoint
%生成ROIInfo的第二列
    global flashThresh TMRMCh cpYFPCh flashsignal currentflash ROIInfo signalpoint
    
    trace=flashsignal{currentflash}{cpYFPCh};
    para=analyze_flash_parameter(trace);
    para=para';
    paraMat=cell2mat(para);
    if ~isempty(paraMat)
        netOut=netPatternRecogIDL(paraMat);
        flashType=zeros(size(netOut));
        isFlash=netOut>flashThresh;
        flashType(isFlash)=1;
        TMRMTrace=flashsignal{currentflash}{TMRMCh};
        TMRMDowns=TMRMTrace(fix(paraMat(:,17))+1);
        isType2=TMRMDowns<10;
        flashType(isFlash&isType2)=2;
        ROIInfo{currentflash,2}=[paraMat netOut' flashType'];
    else
        ROIInfo{currentflash,2}=[];
        flashType=[];
    end
    
    if ~isempty(find(flashType, 1))
        point.ind=fix(paraMat(isFlash,16))+1;
        point.base=fix(paraMat(isFlash,15))+1;
        point.down=fix(paraMat(isFlash,17))+1;
        point.pea=trace(point.ind);
        point.basepea=trace(point.base);
        point.downpea=trace(point.down);        
    else
        point.ind=[];
        point.base=[];
        point.down=[];
        point.pea=[];
        point.basepea=[];
        point.downpea=[];
    end
    signalpoint{currentflash}=point;
end

function autoROI(meanIm,channels_analyze)
    % r是总帧数，channel是总通道数
global ROIpoint ROIInfo signalpoint count flashsignal lsmdata r channel currentflash
    
wb=waitbar(0);

H=fspecial('average',30);
averaged=imfilter(meanIm,H)*1.5;

bw=meanIm>averaged;
bw=bwareaopen(bw,20);
bw=imclose(bw,strel('square',3));

level=graythresh(meanIm(bw));
bw1=im2bw(meanIm,level*0.4);
bw=bw1&bw;

D=bwdist(~bw);
D=-D;

D(~bw)=-inf;
L=watershed(D);

L(L==mode(double(L(:))))=0;
bw=L;
bw=bwareaopen(bw,20);

[L,n]=bwlabel(bw);

imCalMean=cell(1,n);
ROIpoint=cell(1,n);

total=2*r*n;
countWaitbar=0;
for id=1:n
    bw1=L==id;
%     disp(id);
    pos=find(bw1==1,1);
    pos2=[mod(pos,size(bw1,1)) ceil(pos/size(bw1,1))];
    pos2(pos2==0)=size(bw1,1);
    try
        boundaryv=bwtraceboundary(bw1,pos2,'se');
    catch e
%         disp(e.message)
%         disp(id);
    end
    ROIpoint{id}.x=boundaryv(:,2)';
    ROIpoint{id}.y=boundaryv(:,1)';
    
    imCalMean{id}=ones(channel,r,sum(bw1(:)))*100;
    for id1=1:r
        for id2=sort(channels_analyze)
            imCalMean{id}(id2,id1,:)=lsmdata(id1).data{id2}(bw1);
        end
    end
    countWaitbar=countWaitbar+2*r;
    waitbar(countWaitbar/total,wb)
end

count=n;
flashsignal=cell(1,n);

ROIInfo=cell(n,2);
signalpoint=cell(1,n);
for id=1:n
    tmp=mean(imCalMean{id},3);
    tmp=num2cell(tmp,2);
    flashsignal{id}=tmp';
    currentflash=id;
    formROIInfoAndsignalpoint;
    ROIInfo{id,1}=num2str(id);
end

delete(wb)
end

function calFluorescenceArea
    global xy imAll WholeArea lsmdata
    if isempty(imAll)
        imAll=lsmdata(1).data{3};
    end
    bw=im2bw(imAll(:,:,3),graythresh(imAll(:,:,3)));
    pixels=sum(bw(:));
    WholeArea=pixels*xy.VoxelSizeX*xy.VoxelSizeY*1e12;  %平方微米
    figure('name',['Total Area: ',num2str(WholeArea)])
    imshow(bw)
    clipboard('copy',WholeArea);
end

function universal(~,~)
    calFluorescenceArea
end