function showTrace(varargin)
global sliderTrace f flashsignal count r Time mean_sorted ind_mean ...
    ind_std a TMRM std_sorted cpYFP

if ishandle(f)
    delete(f)
end

TMRM=zeros(count,r);
cpYFP=zeros(count,r);

for id=1:count
    TMRM(id,:)=flashsignal{id}{3};
    cpYFP(id,:)=flashsignal{id}{1};
end

meanTMRM=mean(TMRM,2);
stdTMRM=std(TMRM,0,2);

% figure;hist(meanTMRM,100)
% figure;hist(stdTMRM,100)

[mean_sorted,ind_mean]=sort(meanTMRM,'descend');
[std_sorted,ind_std]=sort(stdTMRM,'descend');

start1=1;
end1=count;

f=figure('menubar','none','name',[num2str(ind_std(1)),'   ',num2str(1)]);
pos=get(f,'position');
a=axes('unit','pixel',...
    'nextplot','replacechildren','parent',f,'visible','on',...
    'xlim',[0 r]);
set(a,'ylim',[0 100]);
sliderTrace=uicontrol('parent',f,'style','slider','position',[0 0 pos(3),30],'callback',@sliderTracef);
set(sliderTrace,'min',start1,'max',end1,'sliderstep',[1/(end1-start1) 10/(end1-start1)],'value',start1);
plot(Time',TMRM(ind_std(1),:),'r',Time',cpYFP(ind_std(1),:),'g','parent',a);

% hJScrollBar = findjobj(sliderTrace);
% hJScrollBar.AdjustmentValueChangedCallback = @sliderTracef;

function sliderTracef(varargin)

global sliderTrace f Time ind_std a TMRM cpYFP
id=round(get(sliderTrace,'value'));
set(sliderTrace,'value',id);
plot(Time',TMRM(ind_std(id),:),'r',Time',cpYFP(ind_std(id),:),'g','parent',a);
set(f,'name',[num2str(ind_std(id)),'   ',num2str(id)]);
