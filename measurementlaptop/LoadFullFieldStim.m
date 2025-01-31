function LoadFullFieldStim(StimName,input)
% create some default parameters
params = retCreateDefaultGUIParams;

% modify them
%params.experiment       =  'full-field, on-off';
params.experiment       =  'experiment from file';
params.fixation         =  input.Fixation; % edit in retSetFixationParams.m
params.modality         =  'fMRI';
%params.savestimparams   =  1;
params.savestimparams   =  0;
params.repetitions      =  1;
if ispc
    params.runPriority  =  1;
else
    params.runPriority  =  7;
end
params.skipCycleFrames  =  0;
params.prescanDuration  =  0;
if input.TR==1.25
    params.period           =  20; %Period of on+off
else
    params.period           =  18; %Period of on+off
end
params.numCycles        =  15; %How often is the  345789
% Stimulus presented during one run
params.motionSteps      =  2;
params.tempFreq         =  4;
params.contrast         =  1;
params.interleaves      =  [];
params.tr               =  input.TR;
params.loadMatrix       =  StimName;
params.calibration      =  []; % Was calibrated with Photometer
%params.calibration      =  '3T2_projector_800x600temp';
params.stimSize         =  '3'%'max';
StimForStimSizePixel      =  load(StimName,'stimulus');
params.StimSizePixel.x    =  size(StimForStimSizePixel.stimulus.images{1},1);
params.StimSizePixel.y    =  size(StimForStimSizePixel.stimulus.images{1},2);
clear StimForStimSizePixel
params.triggerKey       =  input.TriggerKey; % For different trigger device see pressKey2Begin.m
%params.trigger          = '5';
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

display(['[',mfilename,'] Fixation will be central and stationary'])
display(['[',mfilename,'] MovingFixation disabeled for fullfield'])

if Eyelink('IsConnected') && input.Eyetracker==1
    
    params.EyetrackerExperiment=1;
    
end

% run it
ret(params);

end