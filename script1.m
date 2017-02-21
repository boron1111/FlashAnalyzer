global currentflash flashsignal
a=flashsignal{currentflash};
figure;plot(1:length(a{1}),a{1},'g',1:length(a{1}),a{2},'r');
% figure;plot(1:length(a{1}),a{1},'g')