function SetIcon(f)
    newIcon = javax.swing.ImageIcon('.\bitmaps\Flash.jpg');
    javaFrame = get(f,'JavaFrame');
    javaFrame.setFigureIcon(newIcon);
end