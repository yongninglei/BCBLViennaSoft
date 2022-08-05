function DriftCorrection(el)

%Screen('Preference', 'VisualDebugLevel', 1);
screenNumber=max(Screen('Screens'));
[window, wRect]=Screen('OpenWindow', screenNumber, 0,[],32,2);
Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%Do a drift correction at the beginning of each trial
EyelinkDoDriftCorrection(el)

Screen('CloseAll');

end