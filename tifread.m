function [mov,info,xy]=tifread(fn)
% clear all;
% clc
% fn='F:\peace\Flash\YA 71.tif';
nt=tiff_frames(fn);
mm=zeros(nt,1);
info=imfinfo(fn);
info=info(1).ImageDescription;
if length(info)<21
   errordlg('Image information not complete','Error');
else
   info=info(21:end);
   l=strfind(info,'XCalibrationMicrons');
   x=info(l+20:l+24);
   
%    x= str2double(cell2mat(regexp(x,'\d', 'match')));
   x=x(isletter(x)==0);
   x= str2double(x);
   xy.VoxelSizeX=x/10^6;
   xy.VoxelSizeY=x/10^6;
   clear l x
end

im=imread(fn,1);
if size(im,3)>1
    im=im(:,:,2);
end
% im=resize(im,[500,500]);
[row,col]=size(im);
if row>500&&col>500
    ap=row/col;
    m=max(row,col);                       
    if row==m
        im=imresize(im,[500,floor(500/ap)]);
        xy.VoxelSizeX=xy.VoxelSizeX*row/500;
        xy.VoxelSizeY=xy.VoxelSizeY*row/500;
        row=500;
        col=floor(500/ap);
    else
        im=imresize(im,[floor(500*ap),500]);
        xy.VoxelSizeX=xy.VoxelSizeX*col/500;
        xy.VoxelSizeY=xy.VoxelSizeY*col/500;
        row=floor(500*ap);
        col=500;                            
    end

end 
if isa(im,'uint8')
    mov=uint8(zeros(row,col,nt));
    for i=1:nt
       im=imread(fn,i);
       if size(im,3)>1
           im=im(:,:,2);
       end
       im=imresize(im,[row,row]);
       m=max(max(im));
       mm(i)=m;
       mov(:,:,i)=im;
    end    
else
    mov=uint16(zeros(row,col,nt));
    for i=1:nt
%        im=uint8(double(imread(fn,i)));
       im=imread(fn,i);
       if size(im,3)>1
           im=im(:,:,2);
       end       
       im=imresize(im,[row,row]);
       m=max(max(im));
       mm(i)=m;       
       mov(:,:,i)=im;
    end
end

mm=max(mm);
mm=mm/255;
mov1=uint8(zeros(row,col,nt));
for i=1:nt
   im=mov(:,:,i);
   im=uint8(double(im)/mm);
   mov1(:,:,i)=im;
end
mov=mov1;
function j = tiff_frames(fn)
status = 1; j=0;
jstep = 10^3;
while status
    try
        j=j+jstep;
        imread(fn,j);
    catch
        if jstep>1
            j=j-jstep;
            jstep = jstep/10;
        else
            j=j-1;
            status = 0;
        end
    end
end
clear jstep fn status im nt row col i ap mov1 
