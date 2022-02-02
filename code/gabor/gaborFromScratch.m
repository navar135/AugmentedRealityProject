%%by: Karen Navarro
%%Date: 03/29/2019
%%This code creates a gabor with a desired frequency, orientation, and
%%contrast. 

%% %% Set up environment
% Clear the workspace and the screen
sca;
close all;
clearvars;
%  
% % Setup PTB with some default values
PsychDefaultSetup(2);
% % Set the screen number to the external secondary monitor if there is one
% % connected
screens = Screen('Screens');
screenNumber = max(screens);
% % Define black, white an d grey
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
% % Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 2);
% %Screen('Preference', 'VisualDebugLevel', 3);
%[window, windowRect] = PsychImaging('OpenWindow', screenNumber, [100 100 100], [0 0 400 400])
% % Open the screen
[window, windowRect] = Screen('OpenWindow', screenNumber, [], []);
%% Draw stuff - button press to exit
% Read in Truck image and set size 
TruckImage = double(imread('Truck16.jpg'));
%figure(1); clf; image(TruckImage); colormap(gray(256));
disp('Here')
%TruckTexture = Screen('MakeTexture', window, TruckImage);
meanIntensity = mean(TruckImage(:));
convertedTruck = (TruckImage - meanIntensity)./meanIntensity;
sdpix = 60;
contrast =1;
cycperim=10;
ang=45; 
phs = 0;
imsize=300;
gabor45Degree = mkgabor(.5,sdpix,cycperim,ang,phs,imsize);
%imagesc(gabor45Degree)
tRect = SetRect(1,1,size(convertedTruck,2),size(convertedTruck,1));
gRect = SetRect(1,1,size(gabor45Degree,2),size(gabor45Degree,1));

nr = CenterRectOnPoint(gRect,700,450);

impatch = convertedTruck(nr(RectTop):nr(RectBottom), nr(RectLeft):nr(RectRight));
impatch = impatch+gabor45Degree;
convertedTruck(nr(RectTop):nr(RectBottom), nr(RectLeft):nr(RectRight)) = impatch;

convertedTruck = (convertedTruck.*meanIntensity)+meanIntensity;
 convertedTruck(convertedTruck>255) = 255;
 convertedTruck(convertedTruck<0) = 0;
disp('Here1')
destionRectTruck = SetRect(1,1,1280,1024);
inverted = imcomplement(convertedTruck);
disp('Here2')

figure; image(convertedTruck); colormap(gray(256));
% Texture = Screen('MakeTexture', window, convertedTruck);
% Screen('DrawTexture', window, Texture,[],destionRectTruck);
disp('Here3')



KbStrokeWait;

% Clear the screen.
sca;
