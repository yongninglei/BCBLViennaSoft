function EIGHTBARSLoadEightbarsStim(StimName,input)
%LOADEIGHTBARSSTIM Summary of this function goes here
%   Detailed explanation goes here
% create some default parameters

params = retCreateDefaultGUIParams;

params.experiment       =  'experiment from file';
params.fixation         =  'disk'; % edit in retSetFixationParams.m
params.modality         =  'fMRI';
params.repetitions      =  1;
params.runPriority      =  7;
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
params.loadMatrix       =  ['/Users/fmri/Dropbox/measurementlaptop/images/',StimName,'_tr',num2str(input.TR),'_images.mat'];
params.calibration      =  []; % Was calibrated with Photometer
params.stimSize         =  'max';
params.triggerKey       =  input.TriggerKey; % For different trigger device see pressKey2Begin.m
%Set Background Color (0=Black, 255=White)
if isfield(input,'BackgroundFullscreenColor') && ~isempty(input.BackgroundFullscreenColor)
    params.BackgroundFullscreen = input.BackgroundFullscreenColor;
else
    params.BackgroundFullscreen = 0;
end


%IMPORTANT: Saves Experiment starting to logfile

params.PatientName=input.PatientName;

if Eyelink('IsConnected') && input.Eyetracker==1
    
    params.EyetrackerExperiment=1;
    
end

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


% run it


ret(params)

end

