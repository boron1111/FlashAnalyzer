function loadAutoTraces

[filename, pathname] = uigetfile({'*.mat'},'select file','MultiSelect','on');

if ~iscell(filename)
    if filename==0
        return
    end
    filename={filename};
end

f1=figure('menubar','none','position', [141,245,599,759]);
list=uicontrol(f1,'style','listbox','unit','normalized');
set(list,'position',[0,0,1,1],'string',filename,'callback',{@choosefile,pathname});

function choosefile(handle,~,pathname)
str=get(handle,'string');
load([pathname,str{get(handle,'value')}]);
showTrace
