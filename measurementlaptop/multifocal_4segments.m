% create some default parameters
params = retCreateDefaultGUIParams; 

% modify them
%params.experiment       =  'multifocal';
params.experiment       =  'experiment from file';
params.fixation         =  'disk'; % edit in retSetFixationParams.m
params.modality         =  'fMRI';
 params.savestimparams   =  1;
% %params.savestimparams   =  0;
 params.repetitions      =  1;  
 params.runPriority      =  7;
 params.skipCycleFrames  =  0;
 params.prescanDuration  =  0;  
 params.period           =  360; % 240 scans
 params.numCycles        =  1;
 params.motionSteps      =  2;
 params.tempFreq         =  4;
 params.contrast         =  1;
 params.interleaves      =  [];
 params.tr               =  1.5;
 %params.loadMatrix       =  [];
 params.loadMatrix       =  ['/Users/fmri/Dropbox/measurementlaptop/images/',mfilename,'_images.mat'];
 params.saveMatrix       =  [];
 %params.saveMatrix       =  [datestr(now,30),'_',mfilename,'_images'];
 params.calibration      =  []; % Was calibrated with Photometer
 %params.calibration      =  '3T2_projector_800x600temp';
 params.stimSize         =  'max';
 params.triggerKey       =  '6'; % For different trigger device see pressKey2Begin.m
 %params.trigger          = '5';

%Gesichtsfeldausfall (Gesichtsfeld = 800x800)

%Ausfall von 1 Balken
%params.xfailure= 101:200;
%params.yfailure= 1:768;

%Ausfall alles au?er 1 Balken
%params.xfailure= [1:334,434:768];
%params.yfailure= 1:768;

%Ausfall von einem Kreis

%resolution= 1024 * 768 (size stimulus = 384)
 %r=64;
 %xm=512;
 %ym=512;
% 
 %params.mycircle='full';
 %params.myradius=r;
 %params.xfailure=xm;
 %params.yfailure=ym;

%resolution= 1024 * 768 (size stimulus = 384)
% r=192;
% xm=384;
% ym=384;

% params.mycircle='fullhalfleft';
% params.myradius=r;
% params.xfailure=xm;
% params.yfailure=ym;

% r=192;
% xm=384;
% ym=384;
% 
% params.mycircle='fullhalfright';
% params.myradius=r;
% params.xfailure=xm;
% params.yfailure=ym;

%Ausfall alles au?er einem Kreis

%  r=192;
%  xm=384;
%  ym=384;
%  
%  params.mycircle='empty';
%  params.myradius=r;
%  params.xfailure=xm;
%  params.yfailure=ym;

%  r=192;
%  xm=384;
%  ym=384;
%  
%  params.mycircle='emptyhalfleft';
%  params.myradius=r;
%  params.xfailure=xm;
%  params.yfailure=ym;

%  r=192;
%  xm=384;
%  ym=384;
%  
%  params.mycircle='emptyhalfright';
%  params.myradius=r;
%  params.xfailure=xm;
%  params.yfailure=ym;


% run it
ret(params)
