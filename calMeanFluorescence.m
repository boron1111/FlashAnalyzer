function calMeanFluorescence

global flashsignal cpYFPCh TMRMCh count meanStdN
meanFluorescence=zeros(count,2);
meanStdN=zeros(2,3);
% row1 for cpYFP row2 for TMRM, column1 for mean, column2 for std, column3
% for n
for id=1:count
    meanFluorescence(id,1)=mean(flashsignal{id}{cpYFPCh});
    meanFluorescence(id,2)=mean(flashsignal{id}{TMRMCh});
end
meanStdN(:,1)=(mean(meanFluorescence))';
meanStdN(:,2)=(std(meanFluorescence))';
meanStdN(:,3)=[count;count];