function Eightbars(varargin)
%EIGHTBARS Usage: Eightbars(varargin)
%Performs Eightbars stimulus (TR=1000ms/1250/1500/2000ms) with or without different simulated scotoma, 
%various fixation aids, without and with eyetracker using different calibration targets and 
%calibration areas. It is also possible to have a moving fixation point to test Eyetracker correction.
%
%TR = TR of the MRI sequence. 
%Possible values: 1,1.25,1.5,2
%Default = 1.5
%
%PatientName = If you want a specific edf Filename you can enter it here.
%Default = 'none'
%
%StimName = If you know you the name of the Stim File, you can enter it
%directly. In this case SimulatedScotoma and Fixation variables are being ignored. 
%Default = 0
%
%Repetitions = Number of stimulus repetitions 
%Default = 1
%
%SimulatedScotoma = Option to show a centric scotoma overlay of different size.
%Possible values = 0, 1.25, 2.5, 5
%Default = 0
%
%Fixation = Choose if you want to show an overlay which helps with center fixation.
%Possible values: 'none', 'circle', 'arrow' and 'cross'
%Default ='none'
%
%MovingFixation = Fixation point can move in a circular or random motion.
%Default = 0
%Select center using MovingFixation.Center 
%Default = [0.5, 0.5]
%Specify Type with MovingFixation.Type 
%Possible values = 'Static, 'Circle', 'Random' and 'SmoothRandom' (using interpolation)
%Default = 'Static'
%Specify radius and speed in MovingFixation.Speed and MovingFixation.Radius. 
%Possible values = MovingFixation.Speed=0.05 and MovingFixation.Radius=64
%
%Eyetracker = Choose if you want to use the Eyetracker. 
%Possible values: 0, 1
%Default = 0
%
%CalibrationTargetSize = If a patient struggles to fixate the calibration targets you can enlarge them. 
%Possible values: 'small', 'medium', 'large', 'giant'
%Default = 'small'
%
%UsePlusCalibrationTarget = Use pluses instead of circle shaped targets for calibration.
%Possible values: 0, 1 
%Default = 0
%
%CalibValidRatio = Changes the size of the area where Calibration and Validation is performed. 
%Possible Values: [0.1 1]
%Default = 1
%
%
% Input Parser:
%
% p.addParamValue('PatientName','none',@isstr);
% p.addParamValue('StimName',0,@isstr);
% p.addParamValue('Repetitions',1,@isnumeric);
% p.addParamValue('SimulatedScotoma',0,@isnumeric);
% p.addParamValue('Fixation', 'none',@isstr);
% p.addParamValue('MovingFixation', 0,@iscell);
% p.addParamValue('Eyetracker', 0,@isnumeric);
% p.addParamValue('CalibrationTargetSize', 'small',@isstr);
% p.addParamValue('UsePlusCalibrationTarget', 0,@isnumeric);
% p.addParamValue('CalibValidRatio', 1,@isnumeric);
% p.addParamValue('TR', 1,@isnumeric);

%Create input parser

p = inputParser;

p.addParamValue('PatientName','none',@isstr);
p.addParamValue('StimName',0,@isstr);
p.addParamValue('Repetitions',1,@isnumeric);
p.addParamValue('SimulatedScotoma',0,@isnumeric);
%p.addParamValue('BackgroundFullscreenColor',[],@isnumeric);
p.addParamValue('Fixation', 'none',@isstr);
p.addParamValue('MovingFixation', 0,@isstruct);
p.addParamValue('Eyetracker', 0,@isnumeric);
p.addParamValue('CalibrationTargetSize', 'small',@isstr);
p.addParamValue('UsePlusCalibrationTarget', 0,@isnumeric);
p.addParamValue('CalibValidRatio', 1,@isnumeric);
p.addParamValue('TR', 1.5,@isnumeric);
p.addParamValue('TriggerKey', 'prisma',@isstr);

p.parse(varargin{:})

%Show inputs

input = p.Results


% Fixation + Simulated Scotoma not possible atm

if isfield(input,'SimulatedScotoma') && isfield(input,'Fixation') && ~input.TR==2
    
    if ~input.SimulatedScotoma==0 && ~strcmp(input.Fixation,'none')
        
        error(['[',mfilename,'] Error: Sorry! At the moment only some simulated scotoma are supported with fixation aids.']);
        
    end
    
end


if ischar(input.StimName)
    
    Stimulus={input.StimName};
    display(['[',mfilename,'] StimName specified! SimulatedScotoma and Fixation variables are being ignored!'])
    
else
    
    if isfield(input,'SimulatedScotoma') && input.SimulatedScotoma~=0 && strcmp(input.Fixation,'cross')
        
        % Creating array for different eightbars stimuli concerning simulated
        % scotoma

        SimScotomaStimLinker={'2', 'eightbars_blanks_StimSize5dot5_r2degree_center_cross_fixation'};
            
        % Finding function corresponding to input

        Stimulus=SimScotomaStimLinker(ismember(SimScotomaStimLinker,num2str(input.SimulatedScotoma)),2);
        
        
        
    elseif ~input.SimulatedScotoma==0

        % Creating array for different eightbars stimuli concerning simulated
        % scotoma

        SimScotomaStimLinker={'1.25', 'eightbars_blanks_r1dot25degree_center'; '2.5', 'eightbars_blanks_r2dot5degree_center'; '5', 'eightbars_blanks_r5degree_center'};

        % Finding function corresponding to input

        Stimulus=SimScotomaStimLinker(ismember(SimScotomaStimLinker,num2str(input.SimulatedScotoma)),2);


    else


        % Creating array for different eightbars stimuli concerning fixation aids)

        FixationStimLinker={'none','eightbars_blanks';'circle','eightbars_blanks_circle_fixation';'arrow','eightbars_blanks_arrow_fixation';'cross','eightbars_blanks_cross_fixation'};

        % Finding function corresponding to input
        
        Stimulus=FixationStimLinker(ismember(FixationStimLinker,input.Fixation),2);

    end

end

%Modifying CalibValidRatio


CalibValidRatio=[0.88,0.83];

if input.CalibValidRatio~=1
   
    CalibValidRatio=CalibValidRatio*input.CalibValidRatio;
    
end

display(['[',mfilename,'] Performing Stimulus: ',Stimulus{1}])

%Disable Psychtoolbox welcome screen & Sync Failure Visual Warning
Screen('Preference', 'VisualDebuglevel', 1);

% Using Eyetracker?

if input.Eyetracker==1
    
    for PresentRun=1:input.Repetitions
        
        display(['[',mfilename,'] PERFORMING RUN ',num2str(PresentRun)])
        

        [EyelinkParameters, edfFile, width,height]=ConfigEyetracker(PresentRun,input.CalibrationTargetSize,input.UsePlusCalibrationTarget,CalibValidRatio);
        DriftCorrection(EyelinkParameters);
        
        StartEyetracker(width,height);
        
        if strcmp(Stimulus{1},'FullField') || ~isempty(strfind(Stimulus{1},'stationary'))
            
            EIGHTBARSLoadFullFieldStim(Stimulus{1},input);
            
        else
            
            EIGHTBARSLoadEightbarsStim(Stimulus{1},input);
            
        end
        
        StopEyetracker(width,height);
        
        %Define Patient Name for EDF File automatically if not specified 
        if strcmp(input.PatientName,'none')
            
            EDFLocalFilename=['/Users/fmri/Dropbox/measurementlaptop/edfFiles/','EyeTrackerDataReceivedOn',num2str(now)];
            
        elseif input.Repetitions>1
            
            EDFLocalFilename=['/Users/fmri/Dropbox/measurementlaptop/edfFiles/',input.PatientName,'_r',num2str(PresentRun)];
            
        else
            
            EDFLocalFilename=['/Users/fmri/Dropbox/measurementlaptop/edfFiles/',input.PatientName];
            
        end
        
        GetEDFDataFile(edfFile,EDFLocalFilename);
        
        Eyelink('ShutDown');
        
        % Read out gaze position
        
        [x,y]=ExtractFromEDFfile(EDFLocalFilename);
        
        save([EDFLocalFilename,'_gaze.mat'],'x','y')
        
    end
    
else
    
    for PresentRun=1:input.Repetitions
        
        if strcmp(Stimulus{1},'FullField') || ~isempty(strfind(Stimulus{1},'stationary'))
            
            EIGHTBARSLoadFullFieldStim(Stimulus{1},input);
            
        else
            
            EIGHTBARSLoadEightbarsStim(Stimulus{1},input);
        
        end
        
    end
    
end

end

