function image_translated=translate_offset(I,xoffset,yoffset)

se=translate(strel(1),[-xoffset -yoffset]);
image_translated=imdilate(I,se);