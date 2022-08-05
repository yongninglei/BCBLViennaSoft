function createwedge(TR)

params = retCreateDefaultGUIParams; 

% modify them
%params.experiment       =  'rotating wedge with blanks (45deg duty)';
params.experiment       =  'rotating wedge (45deg duty)';
%params.experiment       =  'experiment from file'; 
params.fixation         =  'disk'; % edit in retSetFixationParams.m
params.modality         =  'fMRI';
params.savestimparams   =  1;
params.repetitions      =  1;  
params.runPriority      =  7;
params.skipCycleFrames  =  0;
params.prescanDuration  =  0;  
params.period           =  36;
params.numCycles        =  8;
params.motionSteps      =  2;
params.tempFreq         =  4;
params.contrast         =  1;
params.interleaves      =  [];
params.tr               =  TR;
params.loadMatrix       =  [];%'wedge with blanks';
params.saveMatrix       =  'wedge with blanks';
params.calibration      =  []; % Was calibrated with Photometer
params.stimSize         =  'max';
params.triggerKey       =  '6'; % For different trigger device see pressKey2Begin.m

params.CustomInnerRad         =   0.5;

ret(params)



end

