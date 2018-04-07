function Rt=motionValue(im1,im2)

x=uint8(double(im2)-double(im1)+255);
figure;imshow(x)
end

