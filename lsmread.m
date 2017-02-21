%lsm_read
function [lsm_image1,info,xy]=lsmread(str)
    lsm=tiffread(str);
    clear pathstr name
    pack
    info=lsm(1).lsm;
    xy.VoxelSizeX=info.VoxelSizeX;
    xy.VoxelSizeY=info.VoxelSizeY;
    l=length(lsm);
    image=lsm(1).data;
    if isa(image,'cell')
        image=image{1};
        [row,col]=size(image);
        ap=row/col;
        m=max(row,col);
        
        if row>500&&col>500
            if row==m
                image=imresize(image,[500,floor(500/ap)]);
                xy.VoxelSizeX=xy.VoxelSizeX*row/500;
                xy.VoxelSizeY=xy.VoxelSizeY*row/500;
                row=500;
                col=floor(500/ap);
            else
                image=imresize(image,[floor(500*ap),500]);
                xy.VoxelSizeX=xy.VoxelSizeX*col/500;
                xy.VoxelSizeY=xy.VoxelSizeY*col/500;
                row=floor(500*ap);
                col=500;
            end
            
        end
        lsm_image1=uint8(zeros(row,col,l));
        if isa(image,'uint16')
            for i=1:l
                imag=lsm(i).data{1};
                
                imag=imresize(imag,[row,col]);
                imag=double(imag)/20;
                imag=uint8(imag);
                lsm_image1(:,:,i)=imag;
            end
        else
            for i=1:l
                imag=lsm(i).data{1};
                imag=imresize(imag,[row,col]);
                lsm_image1(:,:,i)=imag;
            end
            
        end
    else
        [row,col]=size(image);
        if row>500&&col>500
            ap=row/col;
            m=max(row,col);
            if row==m
                image=imresize(image,[500,floor(500/ap)]);
                xy.VoxelSizeX=xy.VoxelSizeX*row/500;
                xy.VoxelSizeY=xy.VoxelSizeY*row/500;
                row=500;
                col=floor(500/ap);
            else
                image=imresize(image,[floor(500*ap),500]);
                xy.VoxelSizeX=xy.VoxelSizeX*col/500;
                xy.VoxelSizeY=xy.VoxelSizeY*col/500;
                row=floor(500*ap);
                col=500;
            end
            
        end
        lsm_image1=uint8(zeros(row,col,l));
        if isa(image,'uint16')
            for i=1:l
                imag=lsm(i).data;
                imag=imresize(imag,[row,col]);
                imag=double(imag)/20;
                imag=uint8(imag);
                lsm_image1(:,:,i)=imag;
            end
        else
            for i=1:l
                imag=lsm(i).data;
                imag=imresize(imag,[row,col]);
                lsm_image1(:,:,i)=imag;
            end
            
        end
    end

end