function showTrace(varargin)
global sliderTrace f flashsignal count r Time a TMRM cpYFP ind_sort...
    para1 namecolor belongs res
if ishandle(f)
    delete(f)
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

para1={};
belongs=[];

for id=1:length(flashsignal)
    para=analyze_flash_parameter(flashsignal{id}{1});
    para1=cat(2,para1,para);
    belongs=cat(2,belongs,ones(1,length(para))*id);
end

para1=para1';
para1=cell2mat(para1);

res=netPatternRecogIDL(para1);

res(isnan(res))=0;
[~,ind_res]=sort(res,'descend');
ind_sort=ind_res;


start1=1;
end1=length(para1);

f=figure('menubar','none','name',[num2str(res(ind_sort(1))),'   ',num2str(belongs(ind_sort(1)))]);
pos=get(f,'position');
a=axes('unit','pixel',...
    'nextplot','replacechildren','parent',f,'visible','on',...
    'xlim',[0 r]);
set(a,'ylim',[0 150]);
sliderTrace=uicontrol('parent',f,'style','slider','position',[0 0 pos(3),30],'callback',@sliderTracef);
set(sliderTrace,'min',start1,'max',end1,'sliderstep',[1/(end1-start1) 10/(end1-start1)],'value',start1);

start_arr=floor(para1(ind_sort(1),15))+1;
peak_arr=floor(para1(ind_sort(1),16))+1;
end_arr=floor(para1(ind_sort(1),17))+1;

plot(Time'+1,cpYFP(belongs(ind_sort(1)),:),'g',Time'+1,TMRM(belongs(ind_sort(1)),:),'r'...
    ,start_arr,cpYFP(belongs(ind_sort(1)),start_arr),'b*',...
    peak_arr,cpYFP(belongs(ind_sort(1)),peak_arr),'bs',end_arr,cpYFP(belongs(ind_sort(1)),end_arr),'bo',...
    'parent',a);

% hJScrollBar = findjobj(sliderTrace);
% hJScrollBar.AdjustmentValueChangedCallback = @sliderTracef;

function sliderTracef(varargin)

global sliderTrace f Time ind_sort a cpYFP belongs res para1 TMRM
id=round(get(sliderTrace,'value'));
set(sliderTrace,'value',id);

start_arr=floor(para1(ind_sort(id),15))+1;
peak_arr=floor(para1(ind_sort(id),16))+1;
end_arr=floor(para1(ind_sort(id),17))+1;

plot(Time'+1,cpYFP(belongs(ind_sort(id)),:),'g',Time'+1,TMRM(belongs(ind_sort(id)),:),'r',...
    start_arr,cpYFP(belongs(ind_sort(id)),start_arr),'b*',...
    peak_arr,cpYFP(belongs(ind_sort(id)),peak_arr),'bs',end_arr,cpYFP(belongs(ind_sort(id)),end_arr),'bo',...
    'parent',a);
set(f,'name',[num2str(res(ind_sort(id))),'   ',num2str(belongs(ind_sort(id)))]);
