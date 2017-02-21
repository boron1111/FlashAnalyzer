function [image_registered offset]=image_register_correlation(image_reference,image_motion)
% ;This function deals with the problem of registration, with the correlation method
% ;It is achieved by doing the FFT and match the position of images
% ;Then shift the image to the new position
% ;The shifted part can be cut because of information lost.

sz=size(image_reference);
ff_refer=fft2(image_reference);
ff_motion=fft2(image_motion);
ff_con=conj(ff_refer);
correlation=ff_con.*ff_motion;
corr_real=ifft2(correlation);
corr_real=real(corr_real);
% corr_real=rot90(corr_real,2);
[~, pos]=max(corr_real(:));
pos=pos-1;
xoffset=mod(pos,sz(1));  %row
if xoffset>sz(1)/2;xoffset=-sz(1)+xoffset;end
yoffset=floor(pos/sz(1));  %column
if yoffset>sz(2)/2;yoffset=-sz(2)+yoffset;end
se=translate(strel(1),[-xoffset -yoffset]);
image_registered=imdilate(image_motion,se);
offset=[xoffset yoffset];