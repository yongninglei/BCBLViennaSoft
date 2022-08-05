% Clear the workspace
close all;
clear;
sca;
%FlushEvents() 

%% User Defined
 subj = 'P01';
 runNum = 1;

%% Set up buttons and set up screen
responseButton = struct;
KbName('UnifyKeyNames');

% Setup PTB with some default values
PsychDefaultSetup(2);

% Seed the random number gener ator. Here we use the an older way to be
% compatible with older systems. Newer syntax would be rng('shuffle'). Look
% at the help function of rand  "help rand" for more information
rand('seed', sum(100 * clock));

% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);

% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2);

% Flip to clear
Screen('Flip', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Set the text size
Screen('TextSize', window, 60);

% Query the maximum priority level
topPriorityLevel = MaxPriority(window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%% Expt Design

% We are going to use three colors for this demo. Red, Blue and White.
wordList = {'+', '+', '+'};
rgbColors = [1 0 0; 0 0 1; 1 1 1];

% Make the matrix which will determine our condition combinations
condMatrixBase = [1 3 2 3]; % Task1 Rest Task2 Rest
numCond = 3; % number of conditions

% Sequences per condition
%conditionSequences = [1 2 3 4 1 2 3 4; 4 3 2 1 4 3 2 1; 0 0 0 0 0 0 0 0]; % For testing
conditionSequences = [2 3 1 4 3 1 2 4; 1 3 2 4 3 1 4 2; 0 0 0 0 0 0 0 0]; % For Expt

% Number of blocks per condition. 
blocksPerCondition = 5;

numTaskTrials = 6; % number of trials per block
numRestTrials = 3; % number of trials for rest block. this allows duration to be diff

% Duplicate the condition matrix to get the full number of trials
condMatrix = repmat(condMatrixBase, 1, blocksPerCondition);

% Get the size of the matrix
[~, numBlocks] = size(condMatrix);

% Randomise the conditions
% shuffler = Shuffle(1:numBlocks);
% condMatrixShuffled = condMatrix(:, shuffler);

% *** HACK to NOT randomize
%condMatrixShuffled = [ 1 3 2 3 1 3 2 3 1 3 2 3 1 3 2 3];
condMatrixShuffled = [ 1 3 2 3 1 3 2 3 1 3 2 3 1 3 2 3 1 3 2 3];

%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

% Interstimulus interval time in seconds and frames
isiTimeSecs = 1;
isiTimeFrames = round(isiTimeSecs / ifi);

% Numer of frames to wait before re-drawing
waitframes = 1;

% Duration of single sequence
seqTime = 4;

% Interstimulus interval time in seconds and frames
befTimeSecs = (seqTime+isiTimeSecs)*numRestTrials;  
befTimeFrames = round(befTimeSecs / ifi);

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
escapeKey = KbName('ESCAPE');
scannerPulse = KbName('6^'); %5%
key1 = KbName('1!');
key2 = KbName('2@');
key3 = KbName('3#');
key4 = KbName('4$');

codeKey1 = 30;
codeKey2 = 31;
codeKey3 = 32;
codeKey4 = 33;

% key1 = KbName('9(');
% key2 = KbName('0)');
% key3 = KbName('-_');
% key4 = KbName('=+');

% codeKey1 = 38;
% codeKey2 = 39;
% codeKey3 = 45;
% codeKey4 = 46;

keyListButtonResponses = zeros(1,256);
keyListButtonResponses(1,codeKey1) = 1;
keyListButtonResponses(1,codeKey2) = 2;
keyListButtonResponses(1,codeKey3) = 3;
keyListButtonResponses(1,codeKey4) = 4;


%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is a four row matrix the first row will record the word we present,
% the second row the color the word it written in, the third row the key
% they respond with and the final row the time they took to make there response.
respMat = nan(4, numBlocks,numTaskTrials);

%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------
% Animation loop: we loop for the total number of trials
for block = 1:numBlocks

    % Word and color number
    condNum = condMatrixShuffled(1, block);
    colorNum = condNum;

    % The color word and the color it is drawn in
    theWord = wordList(condNum);
    theColor = rgbColors(colorNum, :);
    
    % Cue to determine whether a response has been made
    respToBeMade = true;
    
    % If this is the first trial we present a start screen and wait for a
    % key-press
    if block == 1
        DrawFormattedText(window, 'Waiting for scanner...',...
            'center', 'center', black);
        Screen('Flip', window);
        
        while respToBeMade == true
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                ShowCursor;
                sca;
                return
            elseif keyCode(scannerPulse)
                response = 1;
                respToBeMade = false;
                %KbQueueCreate([],keyListButtonResponses)
                KbQueueCreate
                
            end
        end
        
        % Flip again to sync us to the vertical retrace at the same time as
        % drawing our fixation point
        Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
        vbl = Screen('Flip', window);
        % Now we present the isi interval with fixation point minus one frame
        % because we presented the fixation point once already when getting a
        % time stamp
        
        %for frame = 1:befTimeFrames - 1
        for befTrial = 1:numRestTrials  
            
            % Draw the word
            DrawFormattedText(window, char(theWord), 'center', 'center', [1 1 1]);
            
            % Flip to the screen
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
            WaitSecs(seqTime)

            % Flip again to sync us to the vertical retrace at the same time as
            % drawing our fixation point
            Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
            vbl = Screen('Flip', window);

            % Now we present the isi interval with fixation point minus one frame
            % because we presented the fixation point once already when getting a
            % time stamp
            for frame = 1:isiTimeFrames - 1

                % Draw the fixation point
                Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);

                % Flip to the screen
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

            end
        end
    end
    
    KbQueueStart
    
    % This allows for Rest block to be diff duration than tasks
    if condNum == 3
        numTrials = numRestTrials;
    else
        numTrials = numTaskTrials;
    end
    
    for trial = 1:numTrials

        tStart = GetSecs;
        %while respToBeMade == true

        % Draw the word
        DrawFormattedText(window, char(theWord), 'center', 'center', theColor);
        
        % Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        WaitSecs(seqTime)

        % Flip again to sync us to the vertical retrace at the same time as
        % drawing our fixation point
        Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
        vbl = Screen('Flip', window);

        % Now we present the isi interval with fixation point minus one frame
        % because we presented the fixation point once already when getting a
        % time stamp
        for frame = 1:isiTimeFrames - 1

            % Draw the fixation point
            Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);

            % Flip to the screen
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        end

       % end
        tEnd = GetSecs;
        seqTimeEmpirical = tEnd - tStart;
        %[ch, when] = GetChar() %Not working. Try KbQueueCheck
        %FlushEvents()
        [pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck;
        responseButton.pressed(trial,1,block) = pressed;
        responseButton.firstPress(trial,:,block) = firstPress;
        responseButton.firstRelease(trial,:,block) = firstRelease;
        responseButton.lastPress(trial,:,block) = lastPress;
        responseButton.lastRelease(trial,:,block) = lastRelease;
        KbQueueFlush
        KbEventFlush % maybe...
        clear pressed firstPress firstRelease lastPress lastRelease
        % Record the trial data into out data matrix
        respMat(1, block, trial) = condNum;
        respMat(2, block, trial) = colorNum;
        respMat(3, block, trial) = 0; %response;
        respMat(4, block, trial) = seqTimeEmpirical;
    end

end

% Flip again to sync us to the vertical retrace at the same time as % drawing our fixation point
Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
vbl = Screen('Flip', window);

% % Use if want afterperiod. Not using currently as end with rest block.
% for frame = 1:befTimeFrames - 1
% 
%     % Draw the fixation point
%     Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
% 
%     % Flip to the screen
%     vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
% end

%% Calculate Behavioral Performance
%concatenate firstPress and lastPress timing for buttons 1,2,3,4 then sort
%and apply to buttonNumbers
firstAndLastPress = cat(2,responseButton.firstPress(:,[codeKey1 codeKey2 codeKey3 codeKey4],:),responseButton.lastPress(:,[codeKey1 codeKey2 codeKey3 codeKey4],:));
eraseButtonNumbersNotPressed = firstAndLastPress>0;

%Add time to firstAndLastPress where no button response was made so it
%doesn't come up as being pressed at t=0. Can just be used for sorting
firstAndLastPressAdjust = firstAndLastPress + ~eraseButtonNumbersNotPressed*1e10;
%test = firstAndLastPressTest- ~eraseButtonNumbersNotPressed*1e10;

buttonNumbers = repmat([1 2 3 4 1 2 3 4],[numTaskTrials,1,numBlocks]); % Need to make for all blocks and trials...I think

[responseTiming,ind]=sort(firstAndLastPressAdjust,2,'ascend');

responseSequence = zeros(size(buttonNumbers));
eraseButtonNumbersNotPressedSorted = zeros(size(buttonNumbers));
for block = 1:numBlocks
    for trial = 1:numTaskTrials
        responseSequence(trial,:,block) = buttonNumbers(trial,ind(trial,:,block),block);
        eraseButtonNumbersNotPressedSorted(trial,:,block) = eraseButtonNumbersNotPressed(trial,ind(trial,:,block),block);
    end
end

% Then sort eraseButtonNumbersNotPressed and apply to responseSequence so
% can see when buttons missed
responseSequenceFinal = responseSequence.*eraseButtonNumbersNotPressedSorted;
responseTimingFinal = responseTiming.*eraseButtonNumbersNotPressedSorted;
movementTime = max(responseTimingFinal,[],2) - min(responseTimingFinal,[],2); 

% Use condMatrixShuffled to identify blocks and then check for (1) accuracy
% and (2) MT for those sequences performed correctly
numCorrect = zeros(size(condMatrixShuffled));
movementTimeCorrect = zeros(size(movementTime));
for block = 1:numBlocks
    for trial = 1:numTaskTrials
        if responseSequenceFinal(trial,:,block) == conditionSequences(condMatrixShuffled(1,block),:) 
            numCorrect(1,block) = numCorrect(1,block)+1;
            movementTimeCorrect(trial,1,block) = movementTime(trial,1,block);
        else
            movementTimeCorrect(trial,1,block) = NaN;
        end
    end
end

% Summary stats - Collapse across like conditions
numCorrectCollapsed = nan(1,length(condMatrixBase));
numCorrectCollapsed(1,1) = sum(numCorrect(condMatrixShuffled==1));
numCorrectCollapsed(1,2) = sum(numCorrect(condMatrixShuffled==2));
numCorrectCollapsed(1,3) = sum(numCorrect(condMatrixShuffled==3));

percentCorrectCollapsed = nan(1,length(condMatrixBase));
percentCorrectCollapsed = numCorrectCollapsed/(blocksPerCondition*numTaskTrials)*100;

meanMovementTimeCollapsed = nan(1,length(condMatrixBase));
meanMovementTimeCollapsed(1,1) = nanmean(nanmean(movementTimeCorrect(:,:,condMatrixShuffled==1)));
meanMovementTimeCollapsed(1,2) = nanmean(nanmean(movementTimeCorrect(:,:,condMatrixShuffled==2)));
meanMovementTimeCollapsed(1,3) = nanmean(nanmean(movementTimeCorrect(:,:,condMatrixShuffled==3)));
    
%% End of experiment screen. We clear the screen once they have made their
% response
DrawFormattedText(window, ['Percent Correct \n\n Red = ' num2str(percentCorrectCollapsed(1,1)) ' \n\n Blue = ' num2str(percentCorrectCollapsed(1,2)) ' \n\n  Press Any Key To Exit'],...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
sca;

%% SAVE
save(['sequeneProduction_fMRI_v4_' subj '_run' num2str(runNum)])