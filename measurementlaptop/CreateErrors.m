% create some default parameters
params = retCreateDefaultGUIParams; 

% modify them
params.experiment       =  '8 bars with blanks';
%params.experiment       =  'experiment from file';
params.fixation         =  'disk'; % edit in retSetFixationParams.m
params.modality         =  'fMRI';
params.savestimparams   =  1;
%params.savestimparams   =  0;
params.repetitions      =  1;  
params.runPriority      =  7;
params.skipCycleFrames  =  0;
params.prescanDuration  =  0;  
params.period           =  288;
params.numCycles        =  1;
params.motionSteps      =  2;
params.tempFreq         =  4;
params.contrast         =  1;
params.interleaves      =  [];
params.tr               =  4.5; %1.5
params.loadMatrix       =  [];
%params.loadMatrix       =  ['/Users/allan/Dropbox/measurementlaptop/images/',mfilename,'_images.mat'];
%params.saveMatrix       =  [];
params.saveMatrix       =  [datestr(now,30),'_',mfilename,'_images'];
params.calibration      =  []; % Was calibrated with Photometer
%params.calibration      =  '3T2_projector_800x600temp';
params.stimSize         =  'max';
params.triggerKey       =  '6'; % For different trigger device see pressKey2Begin.m
%params.trigger          = '5';
%params.bottomonly       = 1;

%Gesichtsfeldausfall (Gesichtsfeld = 800x800)

%Ausfall von 1 Balken
%params.xfailure= 101:200;
%params.yfailure= 1:768;

%Ausfall alles auﬂer 1 Balken
%params.xfailure= [1:334,434:768];
%params.yfailure= 1:768;

%Ausfall von einem Kreis

%resolution= 1024 * 1024 (size stimulus = 384)

 xm=512;%+128;%+102;%+256;
 ym=512;%+128;

 r=64;
 %xm=10;%512;
 %ym=10;%512;
 
 %xm2=1024-10;%512;
 %ym2=10;%512;
 
 %xm3=10;%512;
 %ym3=1024-10;%512;
 
 %xm4=1024-10;%512;
 %ym4=1024-10;%512;
 
 %Parameter setzen

 params.mycircle='full';
 params.myradius=r;
 params.xfailure=xm;
 params.yfailure=ym;
 
 %params.xfailure2=xm2;
 %params.yfailure2=ym2;

 %params.xfailure3=xm3;
 %params.yfailure3=ym3;
 
 %params.xfailure4=xm4;
 %params.yfailure4=ym4;

%resolution= 1024 * 768 (size stimulus = 384)
%  r=192;
%  xm=384;
%  ym=384;
%  
%  params.mycircle='full';
%  params.myradius=r;
%  params.xfailure=xm;
%  params.yfailure=ym;

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
