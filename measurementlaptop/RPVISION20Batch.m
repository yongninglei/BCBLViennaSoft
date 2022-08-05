function RPVISION20Batch(PatientName,ScotomaBorderVisualAngle)

%PatientName='test';
%ScotomaBorderVisualAngle=3.5;
TriggerKey='prisma';
Eyetracker=1;%1;

if ~exist('ScotomaBorderVisualAngle','var') || ~exist('PatientName','var')
    error('Please provide "PatientName" and "ScotomaBorderVisualAngle" parameters.')
end
InputStr='Type "skip" to skip the stimulus and "quit" to quit stimulation. Press Enter to continue...';

% Eyetracker Calibration
if Eyetracker==1
    UsePlusCalibrationTarget=1;
    CalibrationTargetSize='medium';
    DefaultCalibValidRatio=[0.88,0.83];
    CalibValidRatio=0.7;

    RetStimCellPrisma={'TriggerKey',TriggerKey,'Eyetracker',Eyetracker,'UsePlusCalibrationTarget',UsePlusCalibrationTarget,'CalibrationTargetSize',CalibrationTargetSize,'CalibValidRatio',CalibValidRatio};
    
    Input=input(['Next up is eyetracker calibration and drift correction. \n',InputStr],'s');
    if contains(Input,'quit'); return; end
    if ~contains(Input,'skip')
        EyelinkParameters=ConfigEyetracker(1,CalibrationTargetSize,UsePlusCalibrationTarget,DefaultCalibValidRatio*CalibValidRatio);
        DriftCorrection(EyelinkParameters);
    end
    
else
    RetStimCellPrisma={'TriggerKey',TriggerKey,'Eyetracker',Eyetracker};
end

%Determine Scotoma size with subject interaction
Input=input(['Next Stimulus is "Vision Test: Contracting". Cancel with CTRL+C when patient perceives stimulus. \n',InputStr],'s');
if contains(Input,'quit'); return; end
if ~contains(Input,'skip'); CheckRealFoV('contracting'); end
Input=input(['Next Stimulus is "Vision Test: Expanding". Cancel with CTRL+C when patient perceives stimulus. \n',InputStr],'s');
if contains(Input,'quit'); return; end
if ~contains(Input,'skip'); CheckRealFoV('expanding'); end

%With Scanner
Input=input(['Next Stimulus is "Fullfield". \n',InputStr],'s');
if contains(Input,'quit'); return; end
if ~contains(Input,'skip'); RetStim('PatientName',[PatientName,'fullfield'],'StimType','fullfield',RetStimCellPrisma{:}); end

for i=1:2
    Input=input(['Next Stimulus is "Center-Surround". \n',InputStr],'s');
    if contains(Input,'quit'); return; end
    if ~contains(Input,'skip'); RetStim('PatientName',[PatientName,'prismacentersurround_r',num2str(i)],'StimType','prismacentersurround','ScotomaBorderVisualAngle',ScotomaBorderVisualAngle,RetStimCellPrisma{:}); end
    
    Input=input(['Next Stimulus is "Eightbars". \n',InputStr],'s');
    if contains(Input,'quit'); return; end
    if ~contains(Input,'skip'); RetStim('PatientName',[PatientName,'eightbars_blanks_r',num2str(i)],'StimType','eightbars_blanks',RetStimCellPrisma{:}); end
    
    Input=input(['Next Stimulus is "WedgeRings". \n',InputStr],'s');
    if contains(Input,'quit'); return; end
    if ~contains(Input,'skip'); RetStim('PatientName',[PatientName,'wedgeringsaltnojump_r',num2str(i)],'StimType','wedgeringsaltnojump',RetStimCellPrisma{:}); end
end

end