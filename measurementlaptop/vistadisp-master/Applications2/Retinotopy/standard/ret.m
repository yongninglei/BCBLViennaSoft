function params = ret(params)
% [params] = ret([params])
%
% ret - program to start retinotopic mapping experiments (under OSX)
%     params: optional input argument to specify experiment parameters. if
%             omitted, GUI is opened to set parameters
%
% 06/2005 SOD Ported to OSX. If the mouse is invisible,
%             moving it to the Dock usually make s it reappear.
% 10/2005 SOD Several changes, including adding gui.
% 1/2009 JW   Added optional input arg 'params'. This allows you to
%             specify your parameters in advance so that the GUI loads up
%             with the values you want. 
% 
% Examples:
%
% 1. open the GUI, specify your expt, and click OK:
%
%   ret
%
% 2. Specify your experimental params in advance, open the GUI, and then
% click OK:
%   
%   params = retCreateDefaultGUIParams
%   % modify fields as you like, e.g.
%   params.fixation = 'dot';
%   ret(params)

% clean up - it's good to clean up but mex files are extremely slow to be
% loaded for the first time in MacOSX, so I chose not to do this to speed
% things up.
%close all;close hidden;
%clear mex; clear all;
%pack;

%Disable Psychtoolbox welcome screen & Sync Failure Visual Warning
%Screen('Preference', 'VisualDebuglevel', 1);

% get some parameters from graphical interface
if ~exist('params', 'var'), params = []; end


%params=retMenu(params);


% if user aborted GUI, exit gracefully
if notDefined('params'), return; end

if strcmp(params.experiment,'wedgesrings') || strcmp(params.experiment,'wedgesringsalt') || strcmp(params.experiment,'wedgesringsaltnojump')

    % now set rest of the params
    params.wedges = setRetinotopyParams('rotating wedge with blanks (45deg duty)', params);
    params.rings = setRetinotopyParams('expanding ring with blanks (45% duty)', params);

    % set response device
    params.wedges = setRetinotopyDevices(params.wedges);
    params.rings = setRetinotopyDevices(params.rings);
    % go

else
    % now set rest of the params
    params = setRetinotopyParams(params.experiment, params);

    % set response device
    params = setRetinotopyDevices(params);
    % go
end

doRetinotopyScan(params);
