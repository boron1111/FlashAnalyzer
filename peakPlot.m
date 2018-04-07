function peakPlot

global lsmdata r col row cpYFPCh TMRMCh
cpYFPImage=zeros(col,row,r);
TMRMImage=zeros(col,row,r);
for id=1:r
    cpYFPImage(:,:,id)=lsmdata(id).data{cpYFPCh};
    TMRMImage(:,:,id)=lsmdata(id).data{TMRMCh};
end
TMRMImage=cpYFPImage;
TMRMImageStd=max(TMRMImage,[],3)./mean(TMRMImage,3);
figure;imshow(TMRMImageStd/max(TMRMImageStd(:)));
beep