%% This script creates the images that will be morphed lsqater on

% RUN THIS LINE FIRST, THEN USE THE RUN COMMAND FOR THE WHOLE FILE
% EVERY TIME WE ARE RUNNING THE STIMULUS
%{ 
   tbUse BCBLViennaSoft;
%} 
close all; clear all;

cd(fullfile(bvRP, 'measurementlaptop'))


%% IMPORTANT TO CHECK ALWAYS, EDIT AND CHECK SCANNER NAME
%%%%%% EDIT THIS BEFORE ANY SCAN, CHECK NAME OF SEQUENCE IN SCANNER %%%%%
% This program is not caring how long is the PatientName, so it´s easier
PatientName = 'sub-04_ses-02';  

% Edit EyeTracker. Options: 0 | 1
Eyetracker = 1;


% Edit imageName. Options: 'CB'|'RW'|'RW10'|'RW20'|'PW'|'FF'
imageName = 'CB'; 

lang = 'AT'; 

TR = 2; 
flickerFrequency = 4; % always 2, except 2.5 for TR=0. BE careful, checking 4 for the first VOTCLOC adquisition Giada VOTCLOC_03
site = 'BCBL';

% No options for these for now
stimSize     = 1024;  % pixels
barWidth     = 4;  % deg
scanDuration = 300; % secs

%%%%%% EDIT THIS BEFORE ANY SCAN, CHECK NAME OF SEQUENCE IN SCANNER %%%%%




% Always delete this number of scans in the beggining. 
% Multiply with TR for secs, for calculating startScan, for example
preScanVolumes = 5;

% SENSOTIVE:
% Edit TR. Options: 1 | 0.8
% Select right sequence in scanner: 
%  - for TR=1   > 310 vols = (5+ (300/1) +5); % preScans + length of stimuli/TR + Nordic scans 
%  - for TR=0.8 > 385 vols = (5 + (300/0.8) + 5) volumes
% NOTES: at some point David made changes and added 10 volumes at the beginning, we were
% acquiring 390 vols for TR=0.8 > (10+300/0.8+5) volumes. In June 2023 we
% decided to go with 5 volumes in the beginning regardless of TR (already
% edited above) >> CHECK THE SEQUENCES IN THE SCANNER
% 
% VOTCLOC
% Edit TR. Options: 2 | 1.5
% Select right sequence in scanner, BE SURE it has the right volumes (see
% below):
%  - for TR=2   > 160 volumes (5+300/2 + 5) >> Voxel Size: 1 x 1 x 1 mm
%  - for TR=1.5 > 210 volumes (5+300/1.5+5) >> Voxel Size: 1.2 x 1.2 x 1.2
%  >> CHECK THE SEQUENCES IN THE SCANNER


% Edit macEcc. Options: 8 | 9
maxEcc = 9; % Vienna = 9, , BCBL = 9. 






%% EDIT THIS DIFFERENTLY IN BCBL/VIENNA
params = retCreateDefaultGUIParams;
% Paste here data from both Vienna and SS
switch site
    case 'BCBL'
        % BCBL
        % {
        % masks = string(fullfile(pmRootPath,'data','images','maskimages.mat'));
        masks = string(fullfile(bvRP,"morphing","DATA","retWordsMagno","maskimages.mat")); % both are the same
        stimulusdir = string(fullfile(bvRP,"morphing","DATA","retWordsMagno"));
        % Screen size and distance
        params.display.numPixels  = [1280 1024];
        params.display.dimensions = [51 41];
        params.display.pixelSize = params.display.dimensions(2)/params.display.numPixels(2);
        params.display.distance = 128;
        params.display.frameRate = 60; % VGA Projector
        params.display.backColorIndex=128;
        % Calculate radius (calculator: https://www.sr-research.com/visual-angle-calculator/)
        params.radius = rad2deg(atan(params.display.dimensions(2)/params.display.distance)/2);
        TriggerKey = 'bcbl';
        triggerDeviceDetector = 'KeyWarrior8 Flex';
        %}

    case 'VIENNA'
        masks = string(fullfile(pmRootPath,'data','images','maskimages.mat'));
        masks = "~/soft/morphing/DATA/retWordsMagno/maskimages.mat"; % both are the same
        stimulusdir="/Users/glerma/soft/morphing/DATA/retWordsMagno";
        params.display.numPixels  = [1280 1024];
        params.display.dimensions = [24.6000 18.3000];
        params.display.pixelSize = params.display.dimensions(2)/params.display.numPixels(2);
        params.display.distance = 43.0474;
        params.display.frameRate = 60; % VGA Projector
        Calculate radius (calculator: https://www.sr-research.com/visual-angle-calculator/)
        params.radius = rad2deg(atan(params.display.dimensions(2)/params.display.distance)/2);
        TriggerKey = 'prisma'; % In Vienna use the same thing as always
        triggerDeviceDetector = '904';

    case 'OKAZAKI'
    	% OKAZAKI
    	% {
    	% masks = string(fullfile(pmRootPath,'data','images','maskimages.mat'));
    	masks = string(fullfile(bvRP,"morphing","DATA","retWordsMagno","maskimages.mat")); % both are the same
    	stimulusdir = string(fullfile(bvRP,"morphing","DATA","retWordsMagno"));
    	% Screen size and distance
    	params.display.numPixels  = [1280 1024];
    	params.display.dimensions = [39 30];
    	params.display.pixelSize = params.display.dimensions(2)/params.display.numPixels(2);
    	params.display.distance = 170;
    	params.display.frameRate = 60; % VGA Projector
    	params.display.backColorIndex=128;
    	% Calculate radius (calculator: https://www.sr-research.com/visual-angle-calculator/)
    	params.radius = rad2deg(atan(params.display.dimensions(2)/params.display.distance)/2);
    	TriggerKey = 'okazaki';
    	triggerDeviceDetector = 'KeyWarrior8 Flex';
    	%}

    otherwise
        error('Site not defined, only BCBL or VIENNA are defined for now')
end



% This values modify the retstim, these are all the vars that it takes that are
% not in the call

%% EDIT THIS AT EXPERIMENT LEVEL, SHOULD BE SAME IN BCBL/VIENNA
% For RetStim (pass them all, always)
MeasurementlaptopFolderLocation = bvRP;
FixationPerformanceFolder       = fullfile('measurementlaptop',...
                                  'FixationPerformance');
StimType                        = 'allInFile'; % Provide file with params and stimuli
SimulatedScotoma                = 0; 
FixationandBackgroundSizeMult   = [];
StaticBlackFixation             =  'none';
MovingFixation                  = 0;
CalibrationTargetSize           = 'small';
UsePlusCalibrationTarget        = 0;
CalibValidRatio                 = 1;
ScotomaBorderVisualAngle        = 0; % 3.5;
Repetitions                     = 1;



% For params, some where defaults within the file, load/edit them here and do
% not change them later. This travels Vienna/BCBL with the stimulus file
params.PatientName      = PatientName;
params.tr               = TR;
params.scanDuration     = scanDuration;
params.experiment       = 'experiment from file';
params.fixation         = 'double disk';
params.modality         = 'fMRI';
params.repetitions      = Repetitions;
params.BackgroundFullscreenColor = 128; % 0=Black, 255=White
params.calibration      = []; % Was calibrated with Photometer
params.stimSize         = 'max';
params.skipCycleFrames  = 0;
params.prescanDuration  = 0; %s
params.startScan        = preScanVolumes * TR; 
params.tempFreq         = flickerFrequency;
% params.numImages        = round((params.scanDuration + params.prescanDuration)/params.tr);
params.ShiftStim        = [0 0];
params.display.gammaTable = [linspace(0,1,256);linspace(0,1,256);linspace(0,1,256)]';
params.runPriority      =  7;


totalduration = params.scanDuration;

%% RUN RetStim


% Generate file name to read (created with the python code)
fname = [lang '_' imageName '_tr-' num2str(params.tr) ...
                    '_duration-' num2str(totalduration) 'sec' ...
                    '_flickfreq-' num2str(flickerFrequency) 'Hz' ...
                    '_size-' num2str(stimSize) 'pix' ...
                    '_maxEcc-' num2str(maxEcc) 'deg' ...
                    '_barWidth-' num2str(barWidth) 'deg' ...
                    '.mat'];
loadMatrix = fullfile(bvRP,'images', fname);
                
if ~isfile(loadMatrix); download_from_OSF(loadMatrix); end

RetStim('FullStimName', loadMatrix, ...
            'PatientName', PatientName, ...
            'Eyetracker', Eyetracker, ...
            'StimType', StimType, ...
            'SimulatedScotoma', SimulatedScotoma, ...
            'FixationandBackgroundSizeMult', FixationandBackgroundSizeMult, ...
            'FixationPerformanceFolder', FixationPerformanceFolder, ...
            'StaticBlackFixation', StaticBlackFixation, ...
            'MovingFixation', MovingFixation, ...
            'CalibrationTargetSize', CalibrationTargetSize, ...
            'UsePlusCalibrationTarget', UsePlusCalibrationTarget, ...
            'CalibValidRatio', CalibValidRatio, ...
            'ScotomaBorderVisualAngle', ScotomaBorderVisualAngle, ...
            'TriggerKey', TriggerKey, ...
            'TR', TR, ...
            'Repetitions', Repetitions, ...
            'MeasurementlaptopFolderLocation', MeasurementlaptopFolderLocation, ...
            'pre_params', params ...
        );



%{
fname = 'ES_RW30_1024x1024x100.mat';
loadMatrix = fullfile(bvRP,'DATA','retWordsMagno', fname);
if ~isfile(loadMatrix); download_from_OSF(loadMatrix); end
%}

