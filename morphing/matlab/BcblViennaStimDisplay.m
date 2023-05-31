%% This script creates the images that will be morphed lsqater on

% RUN THIS LINE FIRST, THEN USE THE RUN COMMAND FOR THE WHOLE FILE
% EVERY TIME WE ARE RUNNING THE STIMULUS
%{ 
   tbUse BCBLViennaSoft;
%} 
close all; clear all;
cd('/Users/experimentaluser/toolboxes/BCBLViennaSoft/measurementlaptop')

PatientName = 'votcloc-p002_001-GLU';  

% Edit EyeTracker. Options: 0 | 1
Eyetracker = 0;

% SENSOTIVE:
% Edit TR. Options: 1 | 0.8
% Select right sequence in scanner: 
%  - for TR=1   > 305 = (300+5); 
%  - for TR=0.8 > 380 = (300/0.8+5) volumes
% Gari: David made changes and added 10 volumes at the beginning, we are
% acquiring 390
%      TR=0.8 > 380 (10+300/0.8+5) volumes
% 
% VOTCLOC
% Edit TR. Options: 2 | 1.5
% Select right sequence in scanner:
%  - for TR=2   > 165 (10+300/2 + 5) volumes   >> Voxel Size: 1 x 1 x 1 mm
%  - for TR=1.5 > 215 (10+300/1.5+5) volumes   >> Voxel Size: 1.2 x 1.2 x 1.2

TR = 1.5; 

% Edit imageName. Options: 'CB'|'RW'|'RW10'|'RW20'|'PW'|'FF'
imageName = 'CB'; 


lang = 'ES'; 

% Edit macEcc. Options: 8 | 9
maxEcc = 9; % Vienna = 9, , BCBL = 9. 

% No options for these for now
stimSize     = 1024;  % pixels
barWidth     = 2;  % deg
scanDuration = 300; % secs

%% EDIT THIS DIFFERENTLY IN BCBL/VIENNA
params = retCreateDefaultGUIParams;
% Paste here data from both Vienna and SS

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

% VIENNA
%{
masks = string(fullfile(pmRootPath,'data','images','maskimages.mat'));
% masks = "~/soft/morphing/DATA/retWordsMagno/maskimages.mat"; % both are the same
stimulusdir="/Users/glerma/soft/morphing/DATA/retWordsMagno";
params.display.numPixels  = [1280 1024];
params.display.dimensions = [24.6000 18.3000];
params.display.pixelSize = params.display.dimensions(2)/params.display.numPixels(2);
params.display.distance = 43.0474;
params.display.frameRate = 60; % VGA Projector
% Calculate radius (calculator: https://www.sr-research.com/visual-angle-calculator/)
params.radius = rad2deg(atan(params.display.dimensions(2)/params.display.distance)/2);
TriggerKey = 'prisma'; % In Vienna use the same thing as always
triggerDeviceDetector = '904';
%}

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
switch TR
    case {0.8, 1, 2}
        params.startScan = 8; %s 8 for all TRs, but for 1.5 error because it is not multiple
    case {1.5}
        params.startScan = 9; %s 8 for all TRs, but for 1.5 error because it is not multiple
    otherwise
        error('Check the TR and be sure that you have the stimuli prepared and that it is multiple of presScan')
end
params.tempFreq         = 2.5;
% params.numImages        = round((params.scanDuration + params.prescanDuration)/params.tr);
params.ShiftStim        = [0 0];
params.display.gammaTable = [linspace(0,1,256);linspace(0,1,256);linspace(0,1,256)]';
params.runPriority      =  7;


totalduration = params.scanDuration;

%% RUN RetStim


% Generate file name to read (created with the python code)
fname = [lang '_' imageName '_tr-' num2str(params.tr) ...
                    '_duration-' num2str(totalduration) 'sec' ...
                    '_size-' num2str(stimSize) 'pix' ...
                    '_maxEcc-' num2str(maxEcc) 'deg' ...
                    '_barWidth-' num2str(barWidth) 'deg' ...
                    '.mat'];
loadMatrix = fullfile(bvRP,'images', fname);   
                
if ~isfile(loadMatrix)
    % Try to download it from osf.io
%     projectID = 'gwsj7';
%     folderName = 'SENSOTIVE_VOTCLOC_STIMS';
%     folderID = '6477482aa8dbe90615cb5503';
%     
%     apiURL = sprintf('https://api.osf.io/v2/nodes/%s/files/osfstorage/?filter[name]=%s', ...
%                      projectID,fname);
%     
%     response = webread(apiURL);
    
    error(['The file does not exist locally or in osf.io. ' ...
           'Make the stimulus and upload it to osf.io'])
end

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