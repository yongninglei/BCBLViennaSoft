function StartEyetracker(width,height)

% Start of Experiment

imgfile='VisualAngleDegree.bmp';


% Eyelink('Message', 'Experiments Starts...');

% This supplies the title at the bottom of the eyetracker display
Eyelink('command', 'record_status_message "Experiments Eightbars %s"', imgfile);

% Before recording, we place reference graphics on the host display
% Must be offline to draw to EyeLink screen
Eyelink('Command', 'set_idle_mode');
% clear tracker display and draw box at center
Eyelink('Command', 'clear_screen 0')
%Eyelink('command', 'draw_box %d %d %d %d 15', width/2-50, height/2-50, width/2+50, height/2+50);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%transfer image to host
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

% start recording eye position (preceded by a short pause so that
% the tracker can finish the mode transition)
% The paramerters for the 'StartRecording' call controls the
% file_samples, file_events, link_samples, link_events availability
Eyelink('Command', 'set_idle_mode');
WaitSecs(0.05);
%         Eyelink('StartRecording', 1, 1, 1, 1);

Eyelink('StartRecording');



        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %transfer image to host
        %imgfile='town.bmp';
        %transferimginfo=imfinfo(imgfile);

        %fprintf('img file name is %s\n',transferimginfo.Filename);


        % image file should be 24bit or 32bit bitmap
        % parameters of ImageTransfer:
        % imagePath, xPosition, yPosition, width, height, trackerXPosition, trackerYPosition, xferoptions
        %transferStatus =  Eyelink('ImageTransfer',transferimginfo.Filename,0,0,transferimginfo.Width,transferimginfo.Height,width/2-transferimginfo.Width/2 ,height/2-transferimginfo.Height/2,1);
        %if transferStatus ~= 0
        %    fprintf('*****Image transfer Failed*****-------\n');
        %end

        %WaitSecs(0.1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% record a few samples before we actually start displaying
% otherwise you may lose a few msec of data
WaitSecs(0.1);