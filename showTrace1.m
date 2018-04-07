function showTrace(varargin)
global sliderTrace f flashsignal count r Time a TMRM cpYFP ind_sort namecolor
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

% meancpYFP=mean(cpYFP,2);
% figure;hist(meancpYFP,100)
% [mean_sorted,ind_mean]=sort(meanTMRM,'descend');

% meanTMRM=mean(TMRM,2);
% [mean_sorted,ind_mean]=sort(meanTMRM,'descend');

% stdTMRM=std(TMRM,0,2);
% [std_sorted,ind_std]=sort(stdTMRM,'descend');

TMRM_lessThanTwo=sum(TMRM<2,2);
[~,ind_TMRM_LTT]=sort(TMRM_lessThanTwo,'descend');
ind_sort=ind_TMRM_LTT;

% figure;hist(meanTMRM,100)
% figure;hist(stdTMRM,100)

start1=1;
end1=count;

f=figure('menubar','none','name',[num2str(ind_sort(1)),'   ',num2str(1)]);
pos=get(f,'position');
a=axes('unit','pixel',...
    'nextplot','replacechildren','parent',f,'visible','on',...
    'xlim',[0 r]);
set(a,'ylim',[0 50]);
sliderTrace=uicontrol('parent',f,'style','slider','position',[0 0 pos(3),30],'callback',@sliderTracef);
set(sliderTrace,'min',start1,'max',end1,'sliderstep',[1/(end1-start1) 10/(end1-start1)],'value',start1);
plot(Time',TMRM(ind_sort(1),:),'r',Time',cpYFP(ind_sort(1),:),'g',...
    'parent',a);

% hJScrollBar = findjobj(sliderTrace);
% hJScrollBar.AdjustmentValueChangedCallback = @sliderTracef;

function sliderTracef(varargin)

global sliderTrace f Time ind_sort a TMRM cpYFP 
id=round(get(sliderTrace,'value'));
set(sliderTrace,'value',id);
plot(Time',TMRM(ind_sort(id),:),'r',Time',cpYFP(ind_sort(id),:),'g',...
    'parent',a);
set(f,'name',[num2str(ind_sort(id)),'   ',num2str(id)]);
