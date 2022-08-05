%% Clear the workspace
close all;
clear;
sca;
%FlushEvents()
Screen('Preference', 'SkipSyncTests', 1);

%% User Defined
subj = 'P02_GK';
runNum = 2;

%% Button and screen set-up
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


%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

% Interstimulus interval time in seconds and frames
isiTimeSecs = 0.1;
isiTimeFrames = round(isiTimeSecs / ifi);

% Interstimulus interval time in seconds and frames
befTimeSecs = 1;
befTimeFrames = round(befTimeSecs / ifi);

% Numer of frames to wait before re-drawing
waitframes = 1;

% Duration of single sequence
seqTime = 5;

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

keyListButtonResponses = zeros(1,256);
keyListButtonResponses(1,30) = 1;
keyListButtonResponses(1,31) = 2;
keyListButtonResponses(1,32) = 3;
keyListButtonResponses(1,33) = 4;

% key1 = KbName('9(');
% key2 = KbName('0)');
% key3 = KbName('-_');
% key4 = KbName('=+');

% keyListButtonResponses(1,38) = 1;
% keyListButtonResponses(1,39) = 2;
% keyListButtonResponses(1,45) = 3;
% keyListButtonResponses(1,46) = 4;


%----------------------------------------------------------------------
%                     Colors in words and RGB
%----------------------------------------------------------------------

% We are going to use three colors for this demo. Red, Blue and White.
wordListBlock2 = {'+', '+'};
rgbColors = [1 0 0; 0 0 1];

% Make the matrix which will determine our condition combinations
condMatrixBase = [1 2];

% Sequences per condition
%conditionSequences = [1 2 3 4 1 2 3 4; 4 3 2 1 4 3 2 1]; % For testing
%sequenceKeys = [key1 key2 key3 key4 key1 key2 key3 key4; key4 key3 key2 key1 key4 key3 key2 key1];

conditionSequences = [2 3 1 4 3 1 2 4; 1 3 2 4 3 1 4 2]; % For Expt
sequenceKeys = [key2 key3 key1 key4 key3 key1 key2 key4; key1 key3 key2 key4 key3 key1 key4 key2];

wordListBlock1 = {num2str(conditionSequences(1,:)), num2str(conditionSequences(2,:))};


% Number of blocks per condition. We set this to one for this demo, to give
% us a total of 9 trials.
blocksPerCondition = 1;

numTrials = 10; % number of trials per block

% Duplicate the condition matrix to get the full number of trials
condMatrix = repmat(condMatrixBase, 1, blocksPerCondition);

% Get the size of the matrix
[~, numBlocks] = size(condMatrix);

% Randomise the conditions
% shuffler = Shuffle(1:numBlocks);
% condMatrixShuffled = condMatrix(:, shuffler);


%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is a four row matrix the first row will record the word we present,
% the second row the color the word it written in, the third row the key
% they respond with and the final row the time they took to make there response.
respMatMT = nan(length(condMatrix), numBlocks,numTrials);
respMatMistake = nan(length(condMatrix), numBlocks);


%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------
% Animation loop: we loop for the total number of trials
firstTrial = 1;
for block = 1:2
    for condition = 1:2
    trial = 0;
    mistakes = 0;
    reminder = 0;
        while trial <= numTrials-1

            % Word and color number
            condNum = condition;
            colorNum = condNum;

            if block == 1 || reminder == 3
            % The color word and the color it is drawn in
            theWord = wordListBlock1(condNum);
            theColor = rgbColors(colorNum, :);
            else
            % The color word and the color it is drawn in
            theWord = wordListBlock2(condNum);
            theColor = rgbColors(colorNum, :);
            end


            % Cue to determine whether a response has been made
            respToBeMade = true;

            % If this is the first trial we present a start screen and wait for a
            % key-press
            if firstTrial == 1     
                DrawFormattedText(window, 'Press Any Key To Begin',...
                    'center', 'center', black);
                Screen('Flip', window);
                KbStrokeWait;
                firstTrial = 0;
            end

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

            % Draw the word
            DrawFormattedText(window, char(theWord), 'center', 'center', theColor);
            % Flip to the screen
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

            tStart = GetSecs;

                % Check the keyboard. The person should press the
                [secs, keyCode, deltaSecs] = KbWait;

                % Following is CLUNKY AS...should recode.
                if keyCode(escapeKey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(sequenceKeys(condition,1))
                    clear secs keyCode deltaSecs
                    [secs, keyCode, deltaSecs] = KbWait([], 2);
                    if keyCode(sequenceKeys(condition,2))
                        clear secs keyCode deltaSecs
                        [secs, keyCode, deltaSecs] = KbWait([], 2);
                        if keyCode(sequenceKeys(condition,3))
                            clear secs keyCode deltaSecs
                            [secs, keyCode, deltaSecs] = KbWait([], 2);
                            if keyCode(sequenceKeys(condition,4))
                                clear secs keyCode deltaSecs
                                [secs, keyCode, deltaSecs] = KbWait([], 2);
                                if keyCode(sequenceKeys(condition,5))
                                clear secs keyCode deltaSecs
                                [secs, keyCode, deltaSecs] = KbWait([], 2);
                                    if keyCode(sequenceKeys(condition,6))
                                    clear secs keyCode deltaSecs
                                    [secs, keyCode, deltaSecs] = KbWait([], 2);
                                            if keyCode(sequenceKeys(condition,7))
                                            clear secs keyCode deltaSecs
                                            [secs, keyCode, deltaSecs] = KbWait([], 2);
                                                 if keyCode(sequenceKeys(condition,8))
                                                 clear secs keyCode deltaSecs
                                                 response = 1;
                                                 trial = trial +1;
                                                 reminder = 0;
                                                 else
                                                     response = 0;
                                                     mistakes = mistakes +1;
                                                     reminder = reminder+1;
                                                 end
                                            else
                                                response = 0;
                                                mistakes = mistakes +1;
                                                reminder = reminder+1;
                                            end
                                    else
                                        response = 0;
                                        mistakes = mistakes +1;
                                        reminder = reminder+1;
                                    end
                                else
                                    response = 0;
                                    mistakes = mistakes +1;
                                    reminder = reminder+1;
                                end
                            else
                                response = 0;
                                mistakes = mistakes +1;
                                reminder = reminder+1;
                            end
                        else
                            response = 0;
                            mistakes = mistakes +1;
                            reminder = reminder+1;
                        end
                    else
                        response = 0;
                        mistakes = mistakes +1;
                        reminder = reminder+1;
                    end
                else
                    response = 0;
                    mistakes = mistakes +1;
                    reminder = reminder+1;
                end

                clear secs keyCode deltaSecs
                tEnd = GetSecs;
                movementTime = tEnd - tStart;

                if response == 1
                    % Record the trial data into out data matrix
                    respMatMT(condition, block, trial) = movementTime; %response;

                    % Flip again to sync us to the vertical retrace at the same time as
                    % drawing our fixation point
                    Screen('DrawDots', window, [xCenter; yCenter], 10, [0 1 0], [], 2);
                    vbl = Screen('Flip', window);
                else
                    % Flip again to sync us to the vertical retrace at the same time as
                    % drawing our fixation point
                    Screen('DrawDots', window, [xCenter; yCenter], 10, [1 0 0], [], 2);
                    vbl = Screen('Flip', window);
                end

                % Now we present the isi interval with fixation point minus one frame
                % because we presented the fixation point once already when getting a
                % time stamp
                for frame = 1:isiTimeFrames - 1
                    if response ==1 
                    % Draw the fixation point
                        Screen('DrawDots', window, [xCenter; yCenter], 10, [0 1 0], [], 2);
                        else
                        Screen('DrawDots', window, [xCenter; yCenter], 10, [1 0 0], [], 2);
                    end
                    % Flip to the screen
                    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
                end  
                clear response
        end
    respMatMistake(condition, block) = mistakes;
    end
end
% End of experiment screen. We clear the screen once they have made their
% response
DrawFormattedText(window, 'Experiment Finished \n\n Press Any Key To Exit',...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
sca;  

%% Calculate Behavioral Performance
meanMT = mean(respMatMT,3)
respMatMistake

%% Save .mat 
save(['sequeneProduction_familiar_v1_' subj '_run' num2str(runNum)])