function showTrace(varargin)
% tic
global sliderTrace f_showTrace flashsignal count r Time a_showTrace TMRM cpYFP ind_sort...
    para1 namecolor belongs res ROIInfo but0 but1 but2
if ishandle(f_showTrace)
    delete(f_showTrace)
end

for id=1:length(namecolor)
    if strcmp(namecolor{id},'Ch1-T1');cpYFPCh=id;end
    if strcmp(namecolor{id},'Ch2-T2');TMRMCh=id;end
end

% count是ROI的总数，r是帧数
TMRM=zeros(count,r);
cpYFP=zeros(count,r);

for id=1:count
    TMRM(id,:)=flashsignal{id}{TMRMCh};
    cpYFP(id,:)=flashsignal{id}{cpYFPCh};
end

para1=[];
belongs=[];

for id=1:length(flashsignal)
    para1=cat(1,para1,ROIInfo{id,2});
    belongs=cat(1,belongs,[ones(size(ROIInfo{id,2},1),1)*id (1:size(ROIInfo{id,2},1))']);
    % beglongs第一列是所在trace的ROI编号，第二列是这一个trace中的peak的编号
end

res=para1(:,30);
res(isnan(res))=0;
[~,ind_res]=sort(res,'descend');
ind_sort=ind_res;


start1=1;
end1=size(para1,1);

f_showTrace=figure('menubar','none','name',[num2str(res(ind_sort(1))),'   ',num2str(belongs(ind_sort(1),1))]);
set(f_showTrace,'closerequestfcn',@closereq);
pos=get(f_showTrace,'position');
a_showTrace=axes('unit','normalize','position',[0.1300 0.1100 0.7050 0.8150],...
    'nextplot','replacechildren','parent',f_showTrace,'visible','on',...
    'xlim',[0 r]);
zoom on
set(a_showTrace,'ylim',[0 50]);

but2=uicontrol('style','radiobutton','string','2','parent',f_showTrace,'unit','normalized','position',[0.88 0.11 0.1 0.05],'callback',@butfcn);
but1=uicontrol('style','radiobutton','string','1','parent',f_showTrace,'unit','normalized','position',[0.88 0.16 0.1 0.05],'callback',@butfcn);
but0=uicontrol('style','radiobutton','string','0','parent',f_showTrace,'unit','normalized','position',[0.88 0.21 0.1 0.05],'callback',@butfcn);

uicontrol('style','pushbutton','unit','normalized','parent',f_showTrace,'position',[0.88 0.3 0.1 0.1],'string','goto main','callback',@gotoMain);

sliderTrace=uicontrol('parent',f_showTrace,'style','slider','position',[0 0 pos(3),30],'callback',@sliderTracef);
set(sliderTrace,'min',start1,'max',end1,'sliderstep',[1/(end1-start1) 10/(end1-start1)],'value',start1,'unit','normalize');

start_arr=floor(para1(ind_sort(1),15))+1;
peak_arr=floor(para1(ind_sort(1),16))+1;
end_arr=floor(para1(ind_sort(1),17))+1;

plot(Time',cpYFP(belongs(ind_sort(1),1),:),'g',Time',TMRM(belongs(ind_sort(1),1),:),'r'...
    ,Time(start_arr),cpYFP(belongs(ind_sort(1),1),start_arr),'b*',...
    Time(peak_arr),cpYFP(belongs(ind_sort(1),1),peak_arr),'bs',Time(end_arr),cpYFP(belongs(ind_sort(1),1),end_arr),'bo',...
    'parent',a_showTrace);
updateChoose(1);
% toc

function sliderTracef(varargin)

global sliderTrace f_showTrace Time ind_sort a_showTrace cpYFP belongs res para1 TMRM
id=round(get(sliderTrace,'value'));
set(sliderTrace,'value',id);

start_arr=floor(para1(ind_sort(id),15))+1;
peak_arr=floor(para1(ind_sort(id),16))+1;
end_arr=floor(para1(ind_sort(id),17))+1;

plot(Time',cpYFP(belongs(ind_sort(id),1),:),'g',Time',TMRM(belongs(ind_sort(id),1),:),'r',...
    Time(start_arr),cpYFP(belongs(ind_sort(id),1),start_arr),'b*',...
    Time(peak_arr),cpYFP(belongs(ind_sort(id),1),peak_arr),'bs',Time(end_arr),cpYFP(belongs(ind_sort(id),1),end_arr),'bo',...
    'parent',a_showTrace);
set(f_showTrace,'name',[num2str(res(ind_sort(id))),'   ',num2str(belongs(ind_sort(id),1)),'   ',...
    num2str(id),'/',num2str(size(para1,1))]);
updateChoose(id);

function closereq(varargin)
global f_showTrace
delete(f_showTrace)
clear global f_showTrace a_showTrace

function butfcn(hobj,~)
% 三个单选框的响应
global sliderTrace para1 ind_sort

if get(hobj,'value')==0
    set(hobj,'value',1);
else
    choose=str2double(get(hobj,'string'));
    id=round(get(sliderTrace,'value'));
    para1(ind_sort(id),31)=choose;
    updateChoose(id);
    updateROIInfo(id);
end
uicontrol(sliderTrace);

function updateChoose(id)
% 将三个单选框的选择情况要看para1的内容更新
global para1 ind_sort but0 but1 but2

switch para1(ind_sort(id),31)
    case 0
        set(but0,'value',1);
        set(but1,'value',0);
        set(but2,'value',0);
    case 1
        set(but0,'value',0);
        set(but1,'value',1);
        set(but2,'value',0);
    case 2
        set(but0,'value',0);
        set(but1,'value',0);
        set(but2,'value',1);
end

function gotoMain(~,~)
% 显示主窗口上相应的trace
global listboxtemp sliderTrace ind_sort belongs f0

id=round(get(sliderTrace,'value'));
set(listboxtemp,'value',belongs(ind_sort(id),1));
FlashAnalyzer('Table_Selection',listboxtemp,[]);
figure(f0);

function updateROIInfo(id)

global ind_sort belongs ROIInfo para1 signalpoint flashsignal
ROIId=belongs(ind_sort(id),1);
flashPeakId=belongs(ind_sort(id),2);
ROIInfo{ROIId,2}(flashPeakId,31)=para1(ind_sort(id),31);

isFlash=logical(ROIInfo{belongs(ind_sort(id),1),2}(:,31));
paraMat=ROIInfo{ROIId,2};
trace=flashsignal{ROIId}{1};
point.ind=fix(paraMat(isFlash,16))+1;
point.base=fix(paraMat(isFlash,15))+1;
point.down=fix(paraMat(isFlash,17))+1;
point.pea=trace(point.ind);
point.basepea=trace(point.base);
point.downpea=trace(point.down);
signalpoint{ROIId}=point;