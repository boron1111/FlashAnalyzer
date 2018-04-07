function calTMRMSum

global flashsignal TMRMCh cpYFPCh count r Time Pathname Filename offsets

TMRMSum=zeros(count,r);
cpYFPSum=zeros(count,r);
try
for id=1:count
    TMRMSum(id,:)=flashsignal{id}{TMRMCh};
    cpYFPSum(id,:)=flashsignal{id}{cpYFPCh};
end
catch
    beep
end
TMRMSumMean=mean(TMRMSum,1);
cpYFPSumMean=mean(cpYFPSum,1);
assignin('base','TMRMSumMean',TMRMSumMean)
assignin('base','cpYFPSumMean',cpYFPSumMean)

save([Pathname,'\',Filename(1:end-4),'_MeanFluorescence.mat'],'Time','TMRMSumMean','cpYFPSumMean')

% figure;plot(Time/60,TMRMSumMean,Time/60,cpYFPSumMean);
figure;
% subplot(2,1,1)
plot(Time/60,TMRMSumMean,'r')
ylim([0 10])
xlabel('Time(minute)')
ylabel('Average Fluorescence of TMRM')
disp([Pathname,'\',Filename(1:end-4)])
% subplot(2,1,2)
% plot(Time/60,(offsets(:,1).^2+offsets(:,2).^2).^0.5);
% xlabel('Time(minute)')
% ylabel('Image offsets(pixel)')