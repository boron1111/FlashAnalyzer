function autoROI

figure;imshow(a)
title('ԭʼͼ');
imcontrast

level=graythresh(a);
bw=im2bw(a,level);
bw=bwareaopen(bw,20);
bw=imclose(bw,strel('square',3));
figure;imshow(bw)
title('ȫ����ֵ');

% bw1=imclose(bw,strel('disk',1));
% figure;imshow(bw1);

H=fspecial('average',20);
averaged=imfilter(a,H);
% figure;imshow(averaged);
% title('�ֲ�ƽ��');
% imcontrast

b=a>averaged;
b=b&~bw;
b=logical(b);
b=imopen(b,strel('square',5));
b=imclose(b,strel('square',3));
figure;imshow(b)
title('�����ֲ���ֵ')

bw=b|bw;
D=bwdist(~bw);
D=-D;
D(~bw)=-inf;
L=watershed(D);
% rgb = label2rgb(L,'jet',[.5 .5 .5]);
% imtool(rgb)
L(L==1)=0;
bw=L;
bw=bwareaopen(bw,20);

figure;imshow(bw);
title('�ۺ�')
% imcontrast


% bw1=bw;
% str=strel('disk',3);
% bw1=imopen(bw1,str);
% figure;imshow(bw1)
% title('������')
% 
% cc=bwconncomp(bw1, 4);
% labeled=labelmatrix(cc);
% RGB_label=label2rgb(labeled, @spring, 'c', 'shuffle');
% figure;imshow(RGB_label)
%

% imwrite(flipud(lsmdata(1).data{3}),'lsm.tif');
% 
% for id=2:100
%     imwrite(flipud(lsmdata(id).data{3}),'lsm.tif','writemode','append')
% end