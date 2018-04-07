function extractAllFlashes

global count signalpoint AllFlashes flashsignal cpYFPCh Pathname Filename

flashCount=0;
for id=1:count
    for id1=1:size(signalpoint{id}.ind,1)
        flashCount=flashCount+1;
        AllFlashes{flashCount}=flashsignal{id}{cpYFPCh}(signalpoint{id}.base:signalpoint{id}.down);
    end
end

save([Pathname,'\',Filename(1:end-4),'_AllFlashes.mat'],'AllFlashes')