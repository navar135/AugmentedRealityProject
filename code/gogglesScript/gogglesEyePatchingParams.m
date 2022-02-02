KbName('UnifyKeyNames');
goggles = 1;  %if on goggles

if goggles
    stereoMode = 10;
else
    stereoMode = 4;
end

% Monitor settings.
monitor.size = [tand(37.2/2)*100*2 tand(37.2/2)*100*2/1280*1024];
monitor.viewDist = 100;

%Rivalry stim settings
stim.spFreq = 6;  %Cycles per stim
stim.orient = 0;
stim.phase = 0;
stim.siz = 40;   %Pixels
stim.sup = 10;
stim.center = 0; % 20  Diameter of gray region;
stim.fix = 0;% Roun fixation point diameter 8;
stim.contrast = 1;
stim.nonouter = 100;  %140 %In pixels, size of outer rectangle
stim.nonwidth = 40;   %Thickness of nonius rectangle
stim.checksize = 10;  %Size of checks

%Keyboard controls for rivalry task
left = KbName('LeftArrow');
right = KbName('RightArrow');
mix = KbName('DownArrow');
done = KbName('Escape');
controls.resps = [left right mix];
controls.qt = done;

%Exp params
exp.depeye = 'l'; %for right eye use r, any other character is left eye
exp.orients = [3*pi/4 pi/4];
exp.testDur = 600;%600; %How long a rivalry trial is in seconds
exp.crlev = input('Final contrast level [0:1]?');
exp.crtim = input('How long to take to reduce contrast (sec)?');

exp.fixcontrast = 1;
tfromend = 0:0.1:exp.crtim;    %Update contrast every 0.25 sec
contrastaboveend = tfromend.^0.6;  %Follows power function with right exponent
contrastaboveend = (contrastaboveend./(exp.crtim.^0.6))*(exp.fixcontrast-exp.crlev);  %Scale so max time out starts at full contrast
exp.varcontrast = exp.crlev+contrastaboveend;
%Change to elapsed time
exp.conttimes = exp.crtim-tfromend;
%Put in order from smallest to biggest
exp.conttimes = flip(exp.conttimes);
exp.varcontrast = flip(exp.varcontrast);

% Select a PTB screen.
screens = Screen('Screens');
screenNumber = max(Screen('Screens'));

% Dual display dual-window stereo requested?
if stereoMode == 10
    % Yes. Do we have at least two separate displays for both views?
    if length(Screen('Screens')) < 2
        error('Sorry, for stereoMode 10 you''ll need at least 2 separate display screens in non-mirrored mode.');
    end
    
    if ~IsWin
        % Assign left-eye view (the master window) to main display:
        screenNumber = 0;
    else
        % Assign left-eye view (the master window) to main display:
        screenNumber = 1;
    end
end

% Determine the frame rate.
monitor.fRate = Screen('FrameRate',screenNumber);
if monitor.fRate == 0, monitor.fRate = 60; end

% Determine the gray background color index.
bkgcol = GrayIndex(screenNumber);

