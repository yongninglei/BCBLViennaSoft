% create some default parameters
params = retCreateDefaultGUIParams; 

% modify them
params.experiment       =  'full-field, on only';
params.fixation         =  'disk';
params.modality         =  'fMRI';
params.savestimparams   =  1;
params.repetitions      =  1;  %????????
params.runPriority      =  7;
params.skipCycleFrames  =  0;
params.prescanDuration  =  0;   %???????
params.period           =  1920;
params.numCycles        =  1;
params.motionSteps      =  1;
params.tempFreq         =  1;
params.contrast         =  1;
params.interleaves      =  [];
params.tr               =  1;
params.loadMatrix       =  [];
params.saveMatrix       =  [];
%params.saveMatrix       =  [datestr(now,30),'_',mfilename,'_images'];
params.calibration      =  [];
%params.calibration      =  '3T2_projector_800x600temp';
params.stimSize         =  'max';
params.triggerKey       =  '6';
%params.trigger          = 5;


    %outerRad     = params.radius;
    %innerRad     = params.innerRad;
    %wedgeWidth   = params.wedgeWidth;
params.ringWidth = 10;

    %numSubRings  = params.numSubRings;
    %numSubWedges = params.numSubWedges;

%Gesichtsfeldausfall (Gesichtsfeld = 800x800)

%Ausfall von 1 Balken
%params.xfailure= 101:200;
%params.yfailure= 1:768;

%Ausfall alles auﬂer 1 Balken
%params.xfailure= [1:334,434:768];
%params.yfailure= 1:768;

%Ausfall von einem Kreis

%resolution= 1024 * 768 (size stimulus = 384)
% r=192;
% xm=384;
% ym=384;
% 
% params.mycircle='full';
% params.myradius=r;
% params.xfailure=xm;
% params.yfailure=ym;

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

%Ausfall alles auﬂer einem Kreis

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
