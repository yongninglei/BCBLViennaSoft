function [x, y]=ExtractFromEDFfile(EDFStructname)

%{
% Examle in /Users/experimentaluser/toolboxes/BCBLViennaSoft/measurementlaptop/edfFiles

% BAD no results stored
EDFStructname = 's08s02_20240512_183746';
bad = load([EDFStructname,'.mat']);
for ii=1:length(bad.EDFStruct.FEVENT)
    fprintf('%s\n', bad.EDFStruct.FEVENT(ii).message)
end

% GOOD no results stored
EDFStructname = 'sensotive-p004_001_20222510_162221';
good = load([EDFStructname,'.mat']);
for ii=1:length(good.EDFStruct.FEVENT)
    fprintf('%s\n', good.EDFStruct.FEVENT(ii).message)
end
gaze='sensotive-p004_001_20222510_162221_20222510_162221_gaze.mat';
good_gaze = load(gaze);
ExperimentStartTime=3168549;
ExperimentStopTime=3476127;
isequal(ExperimentStopTime - ExperimentStartTime+1, length(good_gaze.x))

%}
load([EDFStructname,'.mat'])


% Get Stimulus Start and Ending Time
ExperimentStartEventIndex=find(strncmp({EDFStruct.FEVENT.message}, ...
    'Experiments Starts',length('Experiments Starts')));
ExperimentStopEventIndex=find(strncmp({EDFStruct.FEVENT.message},...
    'Experiments Stops',length('Experiments Stops')));

ExperimentStartTime=EDFStruct.FEVENT(ExperimentStartEventIndex).sttime;
ExperimentStopTime=EDFStruct.FEVENT(ExperimentStopEventIndex).sttime;

ExperimentStartSampleIndex=find(EDFStruct.FSAMPLE.time==ExperimentStartTime);
ExperimentStopSampleIndex=find(EDFStruct.FSAMPLE.time==ExperimentStopTime);


% Get Blink Data

StartBlinkTime=[EDFStruct.FEVENT(strcmp({EDFStruct.FEVENT.codestring},...
    'ENDBLINK')).sttime];
EndBlinkTime=[EDFStruct.FEVENT(strcmp({EDFStruct.FEVENT.codestring},...
    'ENDBLINK')).entime];

NumberOfBlinks=size(StartBlinkTime,2);

for i=1:NumberOfBlinks
    
    StartBlinkSampleIndex(i)=find(EDFStruct.FSAMPLE.time==StartBlinkTime(i));
    EndBlinkSampleIndex(i)=find(EDFStruct.FSAMPLE.time==EndBlinkTime(i));
    
end


% Get Total Gaze Data

xTotal = EDFStruct.FSAMPLE.gx(1,:);
yTotal = EDFStruct.FSAMPLE.gy(1,:);

% Interpolate Eye Position During Blinks (commented -> set to Mean)

% Time in ms by which the blink duration is extended
SafetyDistance=250;

for k=1:NumberOfBlinks
    
    SafeStartBlinkingSampleIndex(k)=StartBlinkSampleIndex(k)-SafetyDistance;
    SafeBeforeStartBlinkingSampleIndex(k)=StartBlinkSampleIndex(k)-1-SafetyDistance;
    
    SafeEndBlinkingSampleIndex(k)=EndBlinkSampleIndex(k)+SafetyDistance;
    SafeBeforeEndBlinkingSampleIndex(k)=EndBlinkSampleIndex(k)+1+SafetyDistance;
    
    % Fix out of range issues
    
    if SafeStartBlinkingSampleIndex(k) <= 0
        
        SafeStartBlinkingSampleIndex(k)=1;
        
    end
    
    if SafeBeforeStartBlinkingSampleIndex(k) <= 0
        
        SafeBeforeStartBlinkingSampleIndex(k)=1;
        
    end
    
    if SafeEndBlinkingSampleIndex(k) >= size(xTotal,2)
        
        SafeEndBlinkingSampleIndex(k)=size(xTotal,2);
        
    end
    
    if SafeBeforeEndBlinkingSampleIndex(k) >= size(xTotal,2)
        
        SafeBeforeEndBlinkingSampleIndex(k)=size(xTotal,2);
        
    end
    
    % Interpolate Eyetracker Data during Blinks
    
    if EndBlinkSampleIndex(k)==size(xTotal,2)
        
        %Fix Problem if blink happens at the end of the stimulus
        
        InterpolatedBlinkTSeriesx{k}=xTotal(SafeBeforeStartBlinkingSampleIndex(k));
        InterpolatedBlinkTSeriesy{k}=yTotal(SafeBeforeStartBlinkingSampleIndex(k));
        
    else
        
        %MeanValueBeforeAndAfterBlinkx(k)=mean([xTotal(SafeBeforeStartBlinkingSampleIndex) xTotal(SafeBeforeEndBlinkingSampleIndex)]);
        %MeanValueBeforeAndAfterBlinky(k)=mean([yTotal(SafeBeforeStartBlinkingSampleIndex) yTotal(SafeBeforeEndBlinkingSampleIndex)]);
        InterpolatedBlinkTSeriesx{k}=imresize([xTotal(SafeBeforeStartBlinkingSampleIndex(k)), xTotal(SafeBeforeEndBlinkingSampleIndex(k))],[1,size(SafeStartBlinkingSampleIndex(k):SafeEndBlinkingSampleIndex(k),2)]);
        InterpolatedBlinkTSeriesy{k}=imresize([yTotal(SafeBeforeStartBlinkingSampleIndex(k)), yTotal(SafeBeforeEndBlinkingSampleIndex(k))],[1,size(SafeStartBlinkingSampleIndex(k):SafeEndBlinkingSampleIndex(k),2)]);
    end
    
    % Replace original, erroneous values with interpolated ones
    
    %xTotal(SafeStartBlinkingSampleIndex:SafeEndBlinkingSampleIndex)=MeanValueBeforeAndAfterBlinkx(k);
    %yTotal(SafeStartBlinkingSampleIndex:SafeEndBlinkingSampleIndex)=MeanValueBeforeAndAfterBlinky(k);
    
    xTotal(SafeStartBlinkingSampleIndex(k):SafeEndBlinkingSampleIndex(k))=InterpolatedBlinkTSeriesx{k};
    yTotal(SafeStartBlinkingSampleIndex(k):SafeEndBlinkingSampleIndex(k))=InterpolatedBlinkTSeriesy{k};
    
    
end

% Account for non detected Blinks by interpolating extreme signals

MaxCoordinate=900;

BigYTotalIndices=find(yTotal > MaxCoordinate);
%BigXTotalIndices=find(xTotal > MaxCoordinate);
%BigXTotalAndYTotalIndices=BigXTotalIndices(yTotal(BigXTotalIndices) > MaxCoordinate);

%Convert BigYTotalIndices to Blinks

if ~isempty(BigYTotalIndices)
    
    ShortBlinkStart(1)=BigYTotalIndices(1);
    g=2;
    
    for h=2:length(BigYTotalIndices)
        
        if BigYTotalIndices(h)-BigYTotalIndices(h-1)>1
            
            ShortBlinkEnd(g-1)=BigYTotalIndices(h-1);
            ShortBlinkStart(g)=BigYTotalIndices(h);
            
            g=g+1;
            
        end
        
    end
    
    
    if length(ShortBlinkStart)==1
        
        % Fix case if there is only one BigYBlink
        
        ShortBlinkEnd(1) = BigYTotalIndices(end);
        
    else
        
        ShortBlinkEnd(end+1) = BigYTotalIndices(end);
        
    end
    
    SafeStartShortBlink=ShortBlinkStart-SafetyDistance;
    SafeEndShortBlink=ShortBlinkEnd+SafetyDistance;
    
    NumberOfShortBlinks=length(SafeStartShortBlink);
    
    % Fix out of range issues
    
    SafeStartShortBlink(SafeStartShortBlink <= 0) = 1;
    
    SafeEndShortBlink(SafeEndShortBlink >= size(xTotal,2)) = size(xTotal,2);
    
    % Interpolating the signals
    
    for m=1:NumberOfShortBlinks
        %    xTotal(SafeStartShortBlink(m):SafeEndShortBlink(m))=640;
        %    yTotal(SafeStartShortBlink(m):SafeEndShortBlink(m))=512;
        
        
        if ShortBlinkEnd(m)==size(xTotal,2)
            
            %Fix Problem if blink happens at the end of the stimulus
            
            InterpolatedShortBlinkTSeriesx{m}=xTotal(SafeStartShortBlink(m));
            InterpolatedShortBlinkTSeriesy{m}=yTotal(SafeStartShortBlink(m));
            
        else
            
            
            InterpolatedShortBlinkTSeriesx{m}=imresize([xTotal(SafeStartShortBlink(m)), xTotal(SafeEndShortBlink(m))],[1,size(SafeStartShortBlink(m):SafeEndShortBlink(m),2)]);
            InterpolatedShortBlinkTSeriesy{m}=imresize([yTotal(SafeStartShortBlink(m)), yTotal(SafeEndShortBlink(m))],[1,size(SafeStartShortBlink(m):SafeEndShortBlink(m),2)]);
            
        end
        
        
        xTotal(SafeStartShortBlink(m):SafeEndShortBlink(m))=InterpolatedShortBlinkTSeriesx{m};
        yTotal(SafeStartShortBlink(m):SafeEndShortBlink(m))=InterpolatedShortBlinkTSeriesy{m};
    end
    
end

% Get Only Experiment Gaze Data

x = xTotal(ExperimentStartSampleIndex:ExperimentStopSampleIndex);
y = yTotal(ExperimentStartSampleIndex:ExperimentStopSampleIndex);

% Set impossible values to min and max values

x(x<0)=0;
x(x>1280)=1280;

y(y<0)=0;
y(y>1024)=1024;

% Mirror y?
display(['[',mfilename,'] Attention: y-axis is flipped in edf file.'])
y=1024-y;

end
