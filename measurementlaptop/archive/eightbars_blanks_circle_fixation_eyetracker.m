function Eightbars_Blanks_Fixation_Eyetracker(repetitions,CalibTargetSize)
%Eightbars_Blanks_Fixation_Eyetracker(repetitions,CalibTargetSize)
% repetitions = number of eightbars runs
% CalibTargetSize = Choose between "small" (default), "medium", "big" and "giant".

if ~exist('repetitions','var')||isempty(repetitions)
   
    repetitions=1;
    
end


if ~exist('CalibTargetSize','var')
    
    CalibTargetSize='small';
    
end



ConfigEyetracker

for i=1:repetitions
    
    DriftCorrection;
    StartEyetracker;

    eightbars_blanks_circle_fixation
    
    StopEyetracker;   

end

GetEDFDataFile;
Eyelink('ShutDown');

clear all;

end