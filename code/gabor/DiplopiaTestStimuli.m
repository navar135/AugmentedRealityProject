%%by: Karen Navarro
%%Date: 02/28/2019
%%This code creates a gabor with a desired frequency, orientation, and
%%contrast. It then displays a jpg image and the gabor with a blended
%%function to smooth the edges. It allows you to change the location of the
%%gabor and is set to the dimensions of a computer with size 1440 x900. The
%%code is taken from the psychtoolbox demos and adapted for our monocular
%%suppression study.

%% Set up environment
% Clear the workspace and the screen
sca;
close all;
clearvars;
 
% Setup PTB with some default values
PsychDefaultSetup(2);
% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));
% Define black, white an d grey
white = WhiteIndex(screenNumber);
gray = white / 2;
% Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 2);
%Screen('Preference', 'VisualDebugLevel', 3);
%[window, windowRect] = PsychImaging('OpenWindow', screenNum, [100 100 100], [0 0 400 400])
% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, [], [], 32, 2,...
    [], [],  kPsychNeed32BPCFloat); 
% Set up alpha-blending for smooth (anti-aliased) lines
%This is set to blend the images together and get rid of edges
%Screen('BlendFunction', window, 'GL_SRC_ALPHA_SATURATE', 'GL_ SRC_ALPHA');
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
%% Create Gabor
% Dimension of the region where will draw the Gabor in pixels
gaborDimPix = windowRect(4)  ;
% Sigma of Gaussian
sigma = gaborDimPix / 5;
% Obvious Parameters
orientation = 45;
contrast = 1.0;
aspectRatio = 1.0;
phase = 1;
% Spatial Frequency (Cycles Per Pixel)
% One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
numCycles = 5;
freq = numCycles / gaborDimPix;

% Build a procedural gabor texture (Note: to get a "standard" Gabor patch
% we set a grey background offset, disable normalisation, and set a
% pre-contrast multiplier of 0.5.
% For full details see:
% https://groups.yahoo.com/neo/groups/psychtoolbox/conversations/topics/9174
backgroundOffset = [.5 .5 .5 0];
disableNorm = 1;
preContrastMultiplier = .5;
gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, [],...
    backgroundOffset, disableNorm, preContrastMultiplier);

% Randomise the phase of the Gabors and make a properties matrix.
propertiesMat = [phase, freq, sigma, contrast, aspectRatio, 0, 0, 0];
%set size of the gabor & where in the image it will display 
destionRect = SetRect(1,1,140,140);
destionRect= CenterRectOnPoint(destionRect,640,570);
destionRectTruck = SetRect(1,1,1280,1024);

destionRectColor = SetRect(1,1,100,100);
destionRectColor= CenterRectOnPoint(destionRectColor,660,575);
destionColor = [.5 .5 .5]
skkkksca
sca

%% Make apeture to blend both images 

% Make a gaussian aperture with the "alpha" channel
gaussDim = 2560;
gaussSigma = gaussDim ;
[xm, ym] = meshgrid(-gaussDim:gaussDim, -gaussDim:gaussDim);
gauss = exp(-(((xm .^2) + (ym .^2)) ./ (2*gaussSigma^2 )));
[s1, s2] = size(gauss);
mask = ones(s1, s2, 2) * gray;
mask(:, :, 2 ) = white * (1 - gauss);
maskTexture = Screen('MakeTexture', window, mask);

%% Draw stuff - button press to exit
% Read in Truck image and set size 
TruckImage = imread('Truck16.jpg');
TruckTexture = Screen('MakeTexture', window, TruckImage);
%Draw the aperture mask in the location of the gabor
%Screen('DrawTexture', window, maskTexture,[],destionRect);
%Draw the Truck picture
Screen('DrawTexture', window, TruckTexture,[],destionRectTruck);

Screen('FillRect', window, destionColor, destionRectColor)

squareImage = imread('graysquare.jpg');
squareTexture = Screen('MakeTexture', window, squareImage);
% Draw the Gabor. By default PTB will draw this in the center of the screen
% for us.

Screen('DrawTexture', window, squareTexture,[],destionRectTruck);
Screen('DrawTexture', window, gabortex, [], destionRect, orientation, [], [], [], [],...
    kPsychDontDoRotation, propertiesMat');

% Flip to the screen
Screen('Flip', window);

 bitmap = Screen('GetImage', window);
filename ='Truck2_45.jpg'; 
imwrite(bitmap,filename,'jpeg'); 
% Wait for a button press o exit
KbWait;

% Clear screen
sca;