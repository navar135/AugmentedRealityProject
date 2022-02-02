clc;
clear all;
close all;
rng('shuffle');
Screen('Preference', 'SkipSyncTests', 1); 
[window, window_size] = Screen('OpenWindow', 0, [0 0 0], [],32,2);


our_image = imread('Truck4.jpg');
our_texture = Screen('MakeTexture', window, our_image);
Screen('DrawTexture', window, our_texture, [], []);

Screen('Flip',window);
WaitSecs(3);
Screen('CloseAll');
Screen('DrawTexture', window, our_texture, [], [200 200 600 600]);

x_middle = window_size(3) / 2;
y_middle = window_size(4) / 2;

Screen('DrawTexture?')
Screen('DrawTexture', window, our_texture, [], [x_middle-200 y_middle-200 x_middle+200 y_middle+200]);