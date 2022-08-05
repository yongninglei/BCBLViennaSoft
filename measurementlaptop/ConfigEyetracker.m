function [el, edfFile, width, height]=ConfigEyetracker(PresentRun,CalibrationTargetSize,UsePlusCalibrationTarget,CalibValidRatio)

dummymode=0;

%Enable dark config screen
%Screen('Preference', 'VisualDebugLevel', 1);

edfFile = [datestr(now,'yymmdd'),'_1'];
fprintf('EDFFile: %s\n', edfFile );


% Open a graphics window on the main screen
% using the PsychToolbox's Screen function.
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 0);
screenNumber=max(Screen('Screens'));
[window, wRect]=Screen('OpenWindow', screenNumber, 0,[],32,2);


Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);


% Provide Eyelink with details about the graphics environment
% and perform some initializations. The information is returned
% in a structure that also contains useful defaults
% and control codes (e.g. tracker state bit and Eyelink key values).
el=EyelinkInitDefaults(window);

% Initialization of the connection with the Eyelink Gazetracker.
% exit program if this fails.
if ~EyelinkInit(dummymode)
    fprintf('Eyelink Init aborted.\n');
    % Shutdown Eyelink:
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

% the following code is used to check the version of the eye tracker
% and version of the host software

[v, vs]=Eyelink('GetTrackerVersion');
fprintf('Running experiment on a ''%s'' tracker.\n', vs );

% open file to record data to
i = Eyelink('Openfile', edfFile);
if i~=0
    fprintf('Cannot create EDF file ''%s'' ', edfFile);
    Eyelink( 'Shutdown');
    Screen('CloseAll');
    return;
end


Eyelink('command', 'add_file_preamble_text ''Recorded by EyelinkToolbox''');
[width, height]=Screen('WindowSize', screenNumber);


% Setting the proper recording resolution, proper calibration type,
% as well as the data file content;
Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1);
% set calibration type.
%Eyelink('command', 'calibration_type = HV9');
Eyelink('command', 'calibration_type = HV13');
% set parser (conservative saccade thresholds)

% set EDF file contents using the file_sample_data and
% file-event_filter commands
% set link data thtough link_sample_data and link_event_filter
Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');

Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT');
Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');

% make sure we're still connected.
if Eyelink('IsConnected')~=1 && dummymode == 0
    fprintf('not connected, clean up\n');
    Eyelink( 'Shutdown');
    Screen('CloseAll');
    return;
end

% Calibrate the eye tracker
% setup the proper calibration foreground and background colors
el.backgroundcolour = [128 128 128];
el.calibrationtargetcolour = [0 0 0];

switch CalibrationTargetSize
    
    case 'giant'
        
        el.calibrationtargetsize= 20;
        el.calibrationtargetwidth= 8;
    

    case 'large'
        
        el.calibrationtargetsize= 10;
        el.calibrationtargetwidth= 4; 

    case 'medium'

        el.calibrationtargetsize= 5;
        el.calibrationtargetwidth= 2;

    case 'small'
        
        el.calibrationtargetsize= 2.5;
        el.calibrationtargetwidth= 1;
        
        
    
end

% Check if instead of circle calibration targets, crosses should be used

if isfield(el,'pluscalibrationtarget')
    
    el=rmfield(el,'pluscalibrationtarget');
    
end

if UsePlusCalibrationTarget==1
   
    el.pluscalibrationtarget=1;
    
end

% Modify calibration area size

CalibStr=['calibration_area_proportion  = ',num2str(CalibValidRatio(1)),' ',num2str(CalibValidRatio(2))];
ValidStr=['validation_area_proportion  = ',num2str(CalibValidRatio(1)),' ',num2str(CalibValidRatio(2))];

Eyelink('command', CalibStr);
Eyelink('command', ValidStr);

% parameters are in frequency, volume, and duration
% set the second value in each line to 0 to turn off the sound
el.cal_target_beep=[600 0.5 0.05];
el.drift_correction_target_beep=[600 0.5 0.05];
el.calibration_failed_beep=[400 0.5 0.25];
el.calibration_success_beep=[800 0.5 0.25];
el.drift_correction_failed_beep=[400 0.5 0.25];
el.drift_correction_success_beep=[800 0.5 0.25];
% you must call this function to apply the changes from above
EyelinkUpdateDefaults(el);

% Hide the mouse cursor;
Screen('HideCursorHelper', window);

if PresentRun==1
    EyelinkDoTrackerSetup(el,'v');
end

Screen('CloseAll');

end
% % Start of Experiment
% 
% imgfile='VisualAngleDegree.bmp';
% 
% 
% Eyelink('Message', 'Experiments Starts...');
% 
% % This supplies the title at the bottom of the eyetracker display
% Eyelink('command', 'record_status_message "Experiments Eightbars %s"', imgfile);
% 
% % Before recording, we place reference graphics on the host display
% % Must be offline to draw to EyeLink screen
% Eyelink('Command', 'set_idle_mode');
% % clear tracker display and draw box at center
% Eyelink('Command', 'clear_screen 0')
% Eyelink('command', 'draw_box %d %d %d %d 15', width/2-50, height/2-50, width/2+50, height/2+50);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %transfer image to host
% transferimginfo=imfinfo(imgfile);
% 
% fprintf('img file name is %s\n',transferimginfo.Filename);
% 
% 
% % image file should be 24bit or 32bit bitmap
% % parameters of ImageTransfer:
% % imagePath, xPosition, yPosition, width, height, trackerXPosition, trackerYPosition, xferoptions
% transferStatus =  Eyelink('ImageTransfer',transferimginfo.Filename,0,0,transferimginfo.Width,transferimginfo.Height,width/2-transferimginfo.Width/2 ,height/2-transferimginfo.Height/2,1);
% if transferStatus ~= 0
%     fprintf('*****Image transfer Failed*****-------\n');
% end
% 
% WaitSecs(0.1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% %Do a drift correction at the beginning of each trial
% %EyelinkDoDriftCorrection(el)
% 
% % start recording eye position (preceded by a short pause so that
% % the tracker can finish the mode transition)
% % The paramerters for the 'StartRecording' call controls the
% % file_samples, file_events, link_samples, link_events availability
% Eyelink('Command', 'set_idle_mode');
% WaitSecs(0.05);
% %         Eyelink('StartRecording', 1, 1, 1, 1);
% Eyelink('StartRecording');
% % record a few samples before we actually start displaying
% % otherwise you may lose a few msec of data
% WaitSecs(0.1);










