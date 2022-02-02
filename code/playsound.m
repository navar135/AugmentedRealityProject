%% Play Sample Data at Default Sample Rate  
% Load the example file |gong.mat|, which contains sample data |y| and rate
% |Fs|, and listen to the audio.   

%%  
% load gong.mat;
% gong = y(1200:19000);
% Fs = Fs*6
% nBits = 32;
% sound(gong,Fs,8);

[bp,Fs] = audioread('Beep.wav');
Fs=Fs*2
sound(bp,Fs)

%% 
% Copyright 2012 The MathWorks, Inc.