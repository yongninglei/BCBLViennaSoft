%% This script creates the images that will be morphed later on
tbUse BCBLViennaSoft;
close all; clear all;

params = retCreateDefaultGUIParams;
PatientName = 'TestGari';   

%% EDIT THIS DIFFERENTLY IN BCBL/VIENNA
% Paste here data from both Vienna and SS
% BCBL
% {
% masks = string(fullfile(pmRootPath,'data','images','maskimages.mat'));
masks = string(fullfile(bvRootPath,"morphing","DATA","retWordsMagno","maskimages.mat")); % both are the same
stimulusdir = string(fullfile(bvRootPath,"morphing","DATA","retWordsMagno"));
% Screen size and distance
params.display.numPixels  = [1280 1024];
params.display.dimensions = [49 37]; % [49 37] [42 31.5]
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
PatientName                     = PatientName;
MeasurementlaptopFolderLocation = bvRootPath;
FixationPerformanceFolder     = fullfile(bvRootPath,'measurementlaptop','FixationPerformance');
Eyetracker                    = 0;
StimType                      = 'allInFile'; % Provide file with params and stimuli
SimulatedScotoma              = 0; 
FixationandBackgroundSizeMult = [];
StaticBlackFixation           =  'none';
MovingFixation                = 0;
CalibrationTargetSize         = 'small';
UsePlusCalibrationTarget      = 0;
CalibValidRatio               = 1;
ScotomaBorderVisualAngle      = 0; % 3.5;
TR = 1; % 0.8; % Python code is not writing it, fix it



% For Stimulus Creation (used once at the time of stimulus creation)
expname         = "103";
onlymasks       = false;
checkimages     = false;
wantdownsample  = true;
wantresize      = false;
resizedvert     = 101;
resizedhorz     = 101;
normalize01     = true;
binarize        = false;
savestimmat     = true;
shuffle         = false;
shuffleseed     = 12345;
barwidth        = 2;
totalduration   = 300;
frameduration   = 4;
stimSize        = 1024;

% For params, some where defaults within the file, load/edit them here and do
% not change them later. This travels Vienna/BCBL with the stimulus file
params.tr               = TR;
params.scanDuration     = totalduration;
params.numCycles        = 1;
params.ncycles          = params.numCycles;
params.period           = totalduration/params.numCycles;
params.motionSteps      = 1;
params.tempFreq         = 1;
params.contrast         = 1;
params.interleaves      = [];
params.experiment       = 'experiment from file';
params.fixation         = 'double disk';
params.modality         = 'fMRI';
params.repetitions      = 1;
params.BackgroundFullscreenColor = 128; % 0=Black, 255=White
params.calibration      =  []; % Was calibrated with Photometer
params.stimSize         =  'max';
params.skipCycleFrames  =  0;
params.prescanDuration  =  0;
params.numImages        = round((params.scanDuration + params.prescanDuration)/params.tr);
params.ShiftStim        = [0 0];
params.display.gammaTable = [linspace(0,1,256);linspace(0,1,256);linspace(0,1,256)]';
params.runPriority      =  7;

%% CB
if 0
% Create checkerboards to draw from, then CB and RW will be the same and I will
% be able to morph the 100 images and not the individual time points.


% This is done and stored, comment
bgfile = fullfile(stimulusdir,"ES_CB_768x768x100.mat");
%{
pixelsSide = 48; 
rowsOfTiles = 8;
K  = double(checkerboard(pixelsSide, rowsOfTiles) > 0.5);
imshow(K)
A  = load("~/soft/morphing/DATA/retWordsMagno/ES_RW_768x768x100.mat");
A  = A.images{1};
II = repmat(K,[1,1,size(A,3), size(A,4)]);
II = uint8(II * 255);
% convert to cell
images      = cell(1,1);
images{1}   = II; 

% saving
save(bgfile, 'images')
%}
lang   = 'ES';
imname = 'CB';
% Launch the stimulus function in prfModel to create the images
filename = fullfile(stimulusdir, ...
                    [lang '_' imname '_tr-' num2str(params.tr) ...
                    '_barwidth-' num2str(barwidth) ...
                    '_dur-' num2str(totalduration) ...
                    '_framedur-' num2str(frameduration) ...
                    '.mat']);
% Create the stimulus files if they don't exist, only first time
%{
  [stim, params] = pmStimulusGenerate('bgfile', bgfile, ...
                          'masks', masks, ...
                          'stimulusdir', stimulusdir, ...
                          'expname', expname,...
                          'onlymasks', onlymasks, ...
                          'checkimages', checkimages, ...
                          'wantdownsample', wantdownsample, ...
                          'wantresize', wantresize, ...
                          'resizedvert', resizedvert, ...
                          'resizedhorz', resizedhorz, ...
                          'normalize01', normalize01, ...
                          'binarize', binarize, ...
                          'savestimmat', savestimmat, ...
                          'shuffle', shuffle, ...
                          'shuffleseed', shuffleseed, ...
                          'filename', filename, ...
                          'barwidth', barwidth, ...
                          'totalduration', totalduration, ...
                          'tr', params.tr, ...
                          'saveParamStimFile', true, ...
                          'params', params, ...
                          'frameduration', frameduration);
%}

% Launch using David's Vienna Software
[fp,pn,fe] = fileparts(filename);
loadMatrix = fullfile(fp,strcat(pn,"_ParamsStims",fe));
if isfile(loadMatrix)
    RetStim('FullStimName',loadMatrix, ...
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
            'MeasurementlaptopFolderLocation', bvRootPath);
else
    error('Check the file %s exists, otherwise create it with the commented code above',loadMatrix)
end
end                   
%% PW
if 1
lang   = 'ES';
imname = 'RW';
% Launch the stimulus function in prfModel to create the images
loadMatrix = fullfile(bvRootPath,'local', ...
                    [lang '_' imname '_tr-' num2str(params.tr) ...
                    '_duration-' num2str(totalduration) 'sec' ...
                    '_size-' num2str(stimSize) ...
                    '.mat']);      
if isfile(loadMatrix)
    RetStim('FullStimName',string(loadMatrix), ...
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
            'MeasurementlaptopFolderLocation', bvRootPath);
else
    error('Check the file %s exists, otherwise create it with the commented code above',loadMatrix)
end
end        

%% Create stimulus for the tests
if 0

RetStim(...
            'PatientName', 'TestGariSeq01', ...
            'Eyetracker', 0, ...
            'StimType', 'eightbars_blanks', ...
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
            'TR',1, ...
            'Fixation','disk', ...
            'MeasurementlaptopFolderLocation', bvRootPath);
                      
 
        
        
        
        
        
        
        
        
end                  
%% Create png images that will be later morphed
if 0
for ns =1:size(stim,3)
      imwrite(stim(:,:,ns),sprintf('ES_RW_%02d.png',ns));
end





LANG: ES, AT
ST: CB, PW, FF, RW, PW10, PW20, FF10, FF20, RW10, RW20
numImages: 100
%sizeImage: 1024x1024
end







    
    