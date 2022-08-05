function StopEyetracker(width,height)

Eyelink('StopRecording');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%transfer image to host
imgfile='Black.bmp';
transferimginfo=imfinfo(imgfile);

fprintf('img file name is %s\n',transferimginfo.Filename);


% image file should be 24bit or 32bit bitmap
% parameters of ImageTransfer:
% imagePath, xPosition, yPosition, width, height, trackerXPosition, trackerYPosition, xferoptions
transferStatus =  Eyelink('ImageTransfer',transferimginfo.Filename,0,0,transferimginfo.Width,transferimginfo.Height,width/2-transferimginfo.Width/2 ,height/2-transferimginfo.Height/2,1);
if transferStatus ~= 0
    fprintf('*****Image transfer Failed*****-------\n');
end

WaitSecs(0.1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end