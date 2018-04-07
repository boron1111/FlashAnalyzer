function gif2avi(varargin)

if isempty(varargin)
    [filename,pathname,~]=uigetfile('*.gif');
else
    pathname=varargin{1};
    filename=varargin{2};
end

videoobj=VideoWriter([pathname,filename(1:end-4),'.avi']);
open(videoobj);
info=imfinfo([pathname,filename]);

try
    f=figure('menubar','none');
    pos=get(f,'position');
    set(f,'position',[pos(1) pos(2)-200 info(1).Width info(1).Height])
    a=axes('unit','pixel','position',[1 1 info(1).Width info(1).Height],...
        'nextplot','replacechildren','parent',f,'visible','off',...
        'xlim',[0.5 info(1).Width+0.5],'ylim',[0.5 info(1).Height+0.5]);
    [I,map]=imread([pathname,filename],1:length(info));
    for id=1:length(info)
        imshow(I(:,:,:,id),map,'parent',a);
        writeVideo(videoobj,getframe(f));
    end
catch e
    close(videoobj);
    disp(e.message)
    % videoobj=close(videoobj);
end
close(videoobj);
delete(f)