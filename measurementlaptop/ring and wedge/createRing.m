function createRing(TR)

params = retCreateDefaultGUIParams; 

% modify them
params.experiment       =  'expanding ring with blanks (45% duty)';
%params.experiment       = 'expanding ring (45% duty)'
%params.experiment       = 'experiment from file';
params.fixation         =  'disk'; % edit in retSetFixationParams.m
params.modality         =  'fMRI';
params.savestimparams   =  1;
params.repetitions      =  1;  
params.runPriority      =  7;
params.skipCycleFrames  =  0;
params.prescanDuration  =  0;  
params.period           =  36;
params.numCycles        =  8;
params.motionSteps      =  2;%8;
params.tempFreq         =  4;%2;
params.contrast         =  1;
params.interleaves      =  [];
params.tr               =  TR;
params.loadMatrix       =  [];%'ring with blanks'
params.saveMatrix       =  'ring with blanks';
params.calibration      =  []; % Was calibrated with Photometer
params.stimSize         =  'max';
params.triggerKey       =  '6'; % For different trigger device see pressKey2Begin.m

params.CustomInnerRad         =   0.5;

ret(params)



end

