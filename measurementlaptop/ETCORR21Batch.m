function ETCORR21Batch(SubjectType,varargin)
%%ETCORR21Batch(SubjectType,varargin)
%Call with ETCORR21Batch(SubjectType,'Fixation',Fixation,'SubjectName',SubjectName)
%SubjectType is either 'control', or 'patient', or 'test' (shows a fullfield stimulation)
%Optional parameter 'Fixation' is either 'cross' (default), or 'disk'
%Optional parameter 'SubjectName' is savename for fixation performance
%Optional parameter 'ShiftStimX' specifies stimulus shift in x direction.
%Min= -1 (left), Max=1 (right)
%Optional parameter 'ShiftStimY' specifies stimulus shift in y direction.
%Min= -1 (down), Max=1 (up)
%Optional parameter 'BackupProjector' shrinks stimulus size to 4.75 or 5 so it fits with the backup projector.
%Default=0; Possible values = 4.75 and 5

%Create input parser
p = inputParser;
p.addParameter('Fixation','disk',@isstr);
p.addParameter('ShiftStimX',0,@isnumeric);
p.addParameter('ShiftStimY',0,@isnumeric);
p.addParameter('SubjectName','none',@isstr);
p.addParameter('BackupProjector',0,@isnumeric);
p.addParameter('MeasurementlaptopFolderLocation','C:\Users\fMRI Stimulus\Dropbox',@isstr)
p.addParameter('Eyetracker',1,@isnumeric)
p.addParameter('CalibValidRatio', 1,@isnumeric);
p.parse(varargin{:})

if strcmp(p.Results.Fixation,'cross')
    Fixation='my thin cross';
else
    Fixation=p.Results.Fixation;
end

if p.Results.BackupProjector==5
    CustomStimSize=5;
elseif p.Results.BackupProjector==4.75
    CustomStimSize=4.75;
else
    CustomStimSize=5.5;
end

% define the movingFixation parameters
movingFixation.Center = [0.5, 0.5];
movingFixation.Type = 'SmoothRandom';
movingFixation.Speed=.02;% .05 is quite fast
movingFixation.Radius=33*5;% 33=~1°radius
Fixation = 'disk';

% define the standard input
RetStimCell={'MeasurementlaptopFolderLocation',p.Results.MeasurementlaptopFolderLocation,'TR',2,'CustomStimSize',CustomStimSize, ...
        'PatientName',p.Results.SubjectName,'Fixation',Fixation,'ShiftStimX',p.Results.ShiftStimX,'ShiftStimY',p.Results.ShiftStimY, ...
        'Eyetracker',p.Results.Eyetracker,'CalibValidRatio',p.Results.CalibValidRatio};    

InputStr='Type "skip" to skip the stimulus and "quit" to quit stimulation. Press Enter to continue...';

switch SubjectType
    case 'test'
        Input=input(['Next Stimulus is "Fullfield". ',InputStr],'s');
        if contains(Input,'quit'); return; end
        if ~contains(Input,'skip'); RetStim('StimType','fullfield',RetStimCell{:}); end
        
    case 'control'
        %Healthy Controls 
        Input=input(['Next Stimulus is "Eightbars - stable fixation". ',InputStr],'s');
        if contains(Input,'quit'); return; end
        if ~contains(Input,'skip'); RetStim('StimType','eightbars_blanks',RetStimCell{:}); end
                       
        Input=input(['Next Stimulus is "WedgeRings - stable fixation". ',InputStr],'s');
        if contains(Input,'quit'); return; end
        if ~contains(Input,'skip'); RetStim('StimType','wedgeringsaltnojump',RetStimCell{:}); end
        
        %Topup
        
        Input=input(['Next Stimulus is "Eightbars - moving fixation". ',InputStr],'s');
        if contains(Input,'quit'); return; end
        if ~contains(Input,'skip'); RetStim('StimType','eightbars_blanks',RetStimCell{:},'MovingFixation',movingFixation); end
        
        Input=input(['Next Stimulus is "WedgeRings - moving fixation". ',InputStr],'s');
        if contains(Input,'quit'); return; end
        if ~contains(Input,'skip'); RetStim('StimType','wedgeringsaltnojump',RetStimCell{:},'MovingFixation',movingFixation); end
        
%     case 'patient'
%         %Patients
%         Input=input(['Next Stimulus is "Fullfield". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimType','fullfield',RetStimCell{:}); end
%         
%         Input=input(['Next Stimulus is "WedgeRings". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimType','wedgeringsaltnojump',RetStimCell{:}); end
%         
%         Input=input(['Next Stimulus is "Eightbars". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimType','eightbars_blanks',RetStimCell{:}); end
%         
%         %Topup
%         
%         Input=input(['Next Stimulus is "WedgeRings". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimType','wedgeringsaltnojump',RetStimCell{:}); end
%         
%         Input=input(['Next Stimulus is "Eightbars". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimType','eightbars_blanks',RetStimCell{:}); end
%         
%         %We perform an additional measurement if its a macular hole patient
%         if contains(lower(p.Results.SubjectName),'ftmh')
%             Input=input(['Next Stimulus is "Eightbars" for macular hole. ',InputStr],'s');
%             if contains(Input,'quit'); return; end
%             if ~contains(Input,'skip')
%                 MacularHoleStimFactor=1/2; %Make MH Stimulus half as big as regular stimulus
%                 RetStimCell(find(strcmp(RetStimCell,'CustomStimSize'))+1)={CustomStimSize*MacularHoleStimFactor};
%                 %RetStim('StimType','wedgeringsaltnojump','FixationandBackgroundSizeMult',1/MacularHoleStimFactor,RetStimCell{:});
%                 RetStim('StimType','eightbars_blanks','FixationandBackgroundSizeMult',1/MacularHoleStimFactor,RetStimCell{:});
%             end
%             
%             Input=input(['Next Stimulus is "Eightbars" for macular hole. ',InputStr],'s');
%             if contains(Input,'quit'); return; end
%             if ~contains(Input,'skip')
%                 MacularHoleStimFactor=1/2; %Make MH Stimulus half as big as regular stimulus
%                 RetStimCell(find(strcmp(RetStimCell,'CustomStimSize'))+1)={CustomStimSize*MacularHoleStimFactor};
%                 %RetStim('StimType','wedgeringsaltnojump','FixationandBackgroundSizeMult',1/MacularHoleStimFactor,RetStimCell{:});
%                 RetStim('StimType','eightbars_blanks','FixationandBackgroundSizeMult',1/MacularHoleStimFactor,RetStimCell{:});
%             end
%         end
%     case 'tessa'
%         Input=input(['Next Stimulus is "Eightbars". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimType','eightbars_blanks',RetStimCell{:}); end
%         
%         Input=input(['Next Stimulus is "Eightbars". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimType','eightbars_blanks',RetStimCell{:}); end
%         
%         %Topup
%         
%       % doubleBar
%         Input=input(['Next Stimulus is "DoubleBar". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimName','eightbarsDouble_testPython',RetStimCell{:}); end
%         
%         Input=input(['Next Stimulus is "DoubleBar". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimName','eightbarsDouble_testPython',RetStimCell{:}); end
%          
%         % low res
%         Input=input(['Next Stimulus is "Eightbars". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimType','eightbars_blanks',RetStimCell{:}); end
%         
%         Input=input(['Next Stimulus is "Eightbars". ',InputStr],'s');
%         if contains(Input,'quit'); return; end
%         if ~contains(Input,'skip'); RetStim('StimType','eightbars_blanks',RetStimCell{:}); end
        
end