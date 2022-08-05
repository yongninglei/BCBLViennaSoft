function LoadEightbarsStim(StimName,input)
%LOADEIGHTBARSSTIM Summary of this function goes here
% create some default parameters
params = retCreateDefaultGUIParams;

params.experiment       =  'experiment from file';
params.fixation         =  input.Fixation; % edit in retSetFixationParams.m
params.modality         =  'fMRI';
params.repetitions      =  1;
if ispc
    params.runPriority  =  1;
else
    params.runPriority  =  7;
end
params.skipCycleFrames  =  0;
params.prescanDuration  =  0;
if input.TR==1.25
    params.period           =  280; %In Reality the stimulus is 330 seconds long, because of the 4 * 12.5s long blanks which are inserted after each diagonal;
else
    params.period           =  288; %In Reality the stimulus is 336 seconds long, because of the 4 * 12s long blanks which are inserted after each diagonal;
end
params.numCycles        =  1;
params.motionSteps      =  2;
params.tempFreq         =  4;
params.contrast         =  1;
params.interleaves      =  [];
params.tr               =  input.TR;
params.loadMatrix       =  StimName;
params.calibration      =  []; % Was calibrated with Photometer
params.stimSize         =  'max';
StimForStimSizePixel      =  load(StimName,'stimulus');
params.StimSizePixel.x    =  size(StimForStimSizePixel.stimulus.images{1},1);
params.StimSizePixel.y    =  size(StimForStimSizePixel.stimulus.images{1},2);
clear StimForStimSizePixel
params.triggerKey       =  input.TriggerKey; % For different trigger device see pressKey2Begin.m
%Set Background Color (0=Black, 255=White)
if isfield(input,'BackgroundFullscreenColor') && ~isempty(input.BackgroundFullscreenColor)
    params.BackgroundFullscreen = input.BackgroundFullscreenColor;
else
    params.BackgroundFullscreen = 0;
end
if isfield(input,'FixationandBackgroundSizeMult') && ~isempty(input.FixationandBackgroundSizeMult)
    params.FixationandBackgroundImageSize = params.StimSizePixel.x*input.FixationandBackgroundSizeMult;
end

params.MeasurementlaptopFolderLocation=input.MeasurementlaptopFolderLocation;
params.FixationPerformanceFolder=input.FixationPerformanceFolder;
params.PatientName=input.PatientName;
params.ShiftStim=[0;0];
if input.ShiftStimX;params.ShiftStim(1)=input.ShiftStimX;end
if input.ShiftStimY;params.ShiftStim(2)=input.ShiftStimY;end


if isstruct(input.MovingFixation)
    
    if isfield(input.MovingFixation,'Center')
        
        params.MovingFixation.Center=input.MovingFixation.Center;
        
    else
        
        params.MovingFixation.Center=[0.5, 0.5];
        
    end
    
    if isfield(input.MovingFixation,'Type')
        
        params.MovingFixation.Type=input.MovingFixation.Type;
        
    else
        
        params.MovingFixation.Type='Static';
        
    end
    
    if ~strcmp(params.MovingFixation.Type,'Static')
        
        if isfield(input.MovingFixation,'Radius') && isfield(input.MovingFixation,'Speed')
            
            params.MovingFixation.Radius=input.MovingFixation.Radius;
            params.MovingFixation.Speed=input.MovingFixation.Speed;
            
        else
            
            error(['[',mfilename,'] If fixation type is not static you have to specify Radius and Speed of the moving fixation point.'])
            
        end
        
    end
    
else
    
    display(['[',mfilename,'] Fixation will be central and stationary'])
    
end

if Eyelink('IsConnected') && input.Eyetracker==1
    
    params.EyetrackerExperiment=1;
    
end

% run it


ret(params);

end

