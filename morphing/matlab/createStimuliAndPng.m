%% This script creates the images that will be morphed later on
tbUse PRFmodel;

rootPath='/Users/glerma/soft/ViennaSoft';
addpath(genpath(rootPath));
addpath(genpath('/Users/glerma/toolboxes/Psychtoolbox-3'));

close all; clear all;

params = retCreateDefaultGUIParams;


PatiendName = 'TestGari';


%% EDIT THIS
% Paste here data from both Vienna and SS
% BCBL
% {
masks = string(fullfile(pmRootPath,'data','images','maskimages.mat'));
% masks = "~/soft/morphing/DATA/retWordsMagno/maskimages.mat"; % both are the same
stimulusdir="/Users/glerma/soft/morphing/DATA/retWordsMagno";
% Screen size and distance
params.display.numPixels  = [1280 1024];
params.display.dimensions = [42 31.5];
params.display.pixelSize = params.display.dimensions(2)/params.display.numPixels(2);
params.display.distance = 128;
params.display.frameRate = 100; % VGA Projector
% Calculate radius (calculator: https://www.sr-research.com/visual-angle-calculator/)
params.radius = rad2deg(atan(params.display.dimensions(2)/params.display.distance)/2);
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
%}

% This values modify the retstim, these are all the vars that it takes that are
% not in the call


%% EDIT THIS AT EXPERIMENT LEVEL, SHOULD BE SAME IN BCBL/VIENNA
% For RetStim
Eyetracker                    = 0;
StimType                      = 'allInFile'; % Provide file with params and stimuli
SimulatedScotoma              = 0; 
FixationandBackgroundSizeMult = [];
StaticBlackFixation           =  'none';
MovingFixation                = 0;
CalibrationTargetSize         = 'small';
UsePlusCalibrationTarget      = 0;
CalibValidRatio               = 1;
ScotomaBorderVisualAngle      = 3.5;

% For Stimulus Creation
expname         = "103";
onlymasks       = false;
checkimages     = true;
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

% For params, some where defaults within the file, load/edit them here and do
% not change them later
params.MeasurementlaptopFolderLocation = rootPath;
params.FixationPerformanceFolder=fullfile(rootPath,'measurementlaptop','FixationPerformance');
params.PatientName =PatiendName;
params.tr               = 2;
params.numCycles        = 1;
params.motionSteps      = 2;
params.tempFreq         = 4;
params.contrast         = 1;
params.interleaves      = [];
params.experiment       = 'experiment from file';
params.fixation         = 'double disk';
params.modality         = 'fMRI';
params.repetitions      = 1;
params.BackgroundFullscreenColor = 0; % 0=Black, 255=White
params.calibration      =  []; % Was calibrated with Photometer
params.stimSize         =  'max';
params.skipCycleFrames  =  0;
params.prescanDuration  =  0;
params.triggerKey       = 's';
params.ShiftStim        = [0 0];



%% CB
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
                stim = pmStimulusGenerate('bgfile', bgfile, ...
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

%% Launch using David's Vienna Software
[fp,pn,fe] = fileparts(filename);
loadMatrix = fullfile(fp,strcat(pn,"_ParamsStims",fe));

RetStim('FullStimName',loadMatrix, ...
        'Eyetracker', Eyetracker, ...
        'StimType', StimType, ...
        'SimulatedScotoma', SimulatedScotoma, ...
        'FixationandBackgroundSizeMult', FixationandBackgroundSizeMult, ...
        'StaticBlackFixation', StaticBlackFixation, ...
        'MovingFixation', MovingFixation, ...
        'CalibrationTargetSize', CalibrationTargetSize, ...
        'UsePlusCalibrationTarget', UsePlusCalibrationTarget, ...
        'CalibValidRatio', CalibValidRatio, ...
        'ScotomaBorderVisualAngle', ScotomaBorderVisualAngle, ...
        'MeasurementlaptopFolderLocation', rootPath);
    

                      
                      
%% RW
% Launch the stimulus function in prfModel to create the images
bgfile   = "~/soft/morphing/DATA/retWordsMagno/ES_RW_768x768x100.mat";
filename = fullfile('~/soft/morphing/DATA/retWordsMagno/',...
                    'ES_RW_deg-2_dur-300_tr-1.5_framedur-4.mat');
stim = pmStimulusGenerate('bgfile', bgfile, ...
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


                      
               
                      
                      
                      
                      
                      
                      
                      
                      %% Create png images that will be later morphed
for ns =1:size(stim,3)
      imwrite(stim(:,:,ns),sprintf('ES_RW_%02d.png',ns));
end













    
    