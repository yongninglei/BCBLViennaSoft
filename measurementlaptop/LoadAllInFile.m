function LoadAllInFile(params, input)
%LOADAllInFile Summary of this function goes here
% create some default parameters

StimForStimSizePixel      =  load(params.loadMatrix,'stimulus');
params.StimSizePixel.x    =  size(StimForStimSizePixel.stimulus.images,1);
params.StimSizePixel.y    =  size(StimForStimSizePixel.stimulus.images,2);
clear StimForStimSizePixel

if isfield(input,'FixationandBackgroundSizeMult') && ~isempty(input.FixationandBackgroundSizeMult)
    params.FixationandBackgroundImageSize = params.StimSizePixel.x*input.FixationandBackgroundSizeMult;
end

params.ShiftStim=[0;0];
if input.ShiftStimX;params.ShiftStim(1)=input.ShiftStimX;end
if input.ShiftStimY;params.ShiftStim(2)=input.ShiftStimY;end


if isstruct(input.MovingFixation)
    
    if isfield(input.MovingFixation,'Center')
        
        params.MovingFixation.Center=input.MovingFixation.Center;
        
    else
        
        params.MovingFixation.Center=[0.5, 0.5];
        
    end
    
    if isfield(input.MovingFixation,'Type')
        
        params.MovingFixation.Type=input.MovingFixation.Type;
        
    else
        
        params.MovingFixation.Type='Static';
        
    end
    
    if ~strcmp(params.MovingFixation.Type,'Static')
        
        if isfield(input.MovingFixation,'Radius') && isfield(input.MovingFixation,'Speed')
            
            params.MovingFixation.Radius=input.MovingFixation.Radius;
            params.MovingFixation.Speed=input.MovingFixation.Speed;
            
        else
            
            error(['[',mfilename,'] If fixation type is not static you have to specify Radius and Speed of the moving fixation point.'])
            
        end
        
    end
    
else
    
    display(['[',mfilename,'] Fixation will be central and stationary'])
    
end
% Add Leandro´s dummymode check, this to first recognize and then detect
% the eyetracker. it is mandotory to BCBL eyelink otherwise it failed
if input.Eyetracker
    dummymode=0;
    EyelinkInit(dummymode);
    
    status = Eyelink('IsConnected');
    if status < 1 % If EyeLink not connected
        dummymode = 1;
    end
    
    if Eyelink('IsConnected') && input.Eyetracker==1
        
        params.EyetrackerExperiment=1;
        
    end
end
% run it
params.triggerKey       = input.TriggerKey;

ret(params);

end

