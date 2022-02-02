%To Do:

%Fusable stims close to riv. stims cause mixed?
%Put in better weber function formula for perceived contrast?
%Only record key presses, not key held down
%Put in rivalry test on top of image capture?
%How long rivalry tests?
%Put in calibration
%Remember to try to set up goggles as balanced as possible for eyes

% Clear memory.
clear all; sca;

% 'stereoMode' specifies the type of stereo display algorithm to use:
%
% 0 == Mono display - 3No stereo at all.
%
% 1 == Flip frame stereo (temporally interleaved) - You'll need shutter
% glasses that are supported by the operating system, e.g., the
% CrystalEyes-Shutterglasses. Psychtoolbox will automatically generate blue
% sync lines at the bottom of the display.
%
% 2 == Top/bottom image stereo with lefteye=top also for use with special
% CrystalEyes-hardware. Also used by the ViewPixx Inc. DataPixx device for
% frame-sequential stereo with shutter glasses, and with various other products.
%
% 3 == Same, but with lefteye=bottom.
%
% 4 == Free fusion (lefteye=left, righteye=right): Left-eye view displayed
% in left half of window, right-eye view displayed in right-half of window.
% Use this for dual-display setups (binocular video goggles, haploscopes,
% polarized stereo setups etc.)
%
% 5 == Cross fusion (lefteye=right ...): Like mode 4, but with views
% switched.
%
% 6-9 == Different modes of anaglyph stereo for color filter glasses:
%
% 6 == Red-Green
% 7 == Green-Red
% 8 == Red-Blue
% 9 == Blue-Red
%
% If you have a different set of filter glasses, e.g., red-magenta, you can
% simply select one of above modes, then use the
% SetStereoAnglyphParameters() command to change color gain settings,
% thereby implementing other anaglyph color combinations.
%
% 10 == Like mode 4, but for use on Mac OS/X with dualhead display setups.
%
% 11 == Like mode 1 (frame-sequential) but using Screen's built-in method,
% instead of the native method supported by your graphics card.
%
% 100 == Interleaved line stereo: Left eye image is displayed in even
% scanlines, right eye image is displayed in odd scanlines.
%
% 101 == Interleaved column stereo: Left eye image is displayed in even
% columns, right eye image is displayed in odd columns. Typically used for
% auto-stereoscopic displays, e.g., lenticular sheet or parallax barrier
% displays.
%
% 102 == PsychImaging('AddTask', 'General', 'SideBySideCompressedStereo');
% Side-by-side compressed stereo, popular with HDMI stereo display devices.

subCode = input('Subject numeric code?>','s');

% Some subfunctions need these variables need to be global.
global wptr monitor;

KbName('UnifyKeyNames');

gogglesEyePatchingParams;

% Prevent key presses to show up in matlab.
ListenChar(2);

try
    % Make sure openGL is available.
    AssertOpenGL;
    
    % Screen is able to do a lot of configuration and performance checks on
    % open, and will print out a fair amount of detailed information when
    % it does. These commands supress that checking behavior and just let
    % the demo go straight into action.
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    
    % Camera parameters.
    %     cameras = imaqhwinfo('winvideo');
    %     vid1 = videoinput('winvideo', cameras.DeviceIDs{end},'RGB8_752x480');
    if goggles
        vid1 = videoinput('winvideo', 2, 'RGB24_752x480');
    else
        vid1 = videoinput('macvideo', 1, 'YCbCr422_1280x720');
    end
    set(vid1, 'FramesPerTrigger', 200);
    set(vid1, 'TriggerRepeat', inf);
    %    set(vid1.source,'BacklightCompensation', 'on');
    %   set(vid1.source,'BacklightCompensationMode','auto');
    %    set(vid1.source,'ExposureMode','auto');
    %    set(vid1.source,'VerticalFlip','on');
    
    % Filter parameters.
    visAng = 2*atand(monitor.size(1)/2/monitor.viewDist);
    CamResolutionX = 640;
    CamResolutionY = 480;
    zoomfac = 1.15;
    widthy = round((CamResolutionY/2)./zoomfac);
    widthx = round((CamResolutionX/2)./zoomfac);
  
    % Some parameters we need.
    rows = 480/2-widthy+1:480/2+widthy;
    cols = 752/2-widthx+1:752/2+widthx;
    
    % Open the PTB screen.
    InitializeMatlabOpenGL([],[],1);
    Screen('Preference','SkipSyncTests',1);
    PsychImaging('PrepareConfiguration');
    Screen('Preference','SkipSyncTests',1);
%     [wptr, screenRect] = PsychImaging('OpenWindow', screenNumber,[],[1,1,400,400],[],[],stereoMode);
    [wptr, screenRect] = PsychImaging('OpenWindow', screenNumber,[],[],[],[],stereoMode);

    if stereoMode == 10
        % In dual-window, dual-display mode, we open the slave window on
        % the secondary screen. Please note that, after opening this window
        % with the same parameters as the "master-window", we won't touch
        % it anymore until the end of the experiment. PTB will take care of
        % managing this window automatically as appropriate for a stereo
        % display setup. That is why we are not even interested in the window
        % handles of this window:
        if IsWin
            slaveScreen = 2;
        else
            slaveScreen = 1;
        end
        Screen('OpenWindow', slaveScreen, BlackIndex(slaveScreen), [], [], [], stereoMode);
    end
    
    % Set color gains. This depends on the anaglyph mode selected. The
    % values set here as default need to be fine-tuned for any specific
    % combination of display device, color filter glasses and (probably)
    % lighting conditions and subject. The current settings do ok on a
    % MacBookPro flat panel.
    switch stereoMode
        case 6,
            SetAnaglyphStereoParameters('LeftGains', wptr,  [1.0 0.0 0.0]);
            SetAnaglyphStereoParameters('RightGains', wptr, [0.0 0.6 0.0]);
        case 7,
            SetAnaglyphStereoParameters('LeftGains', wptr,  [0.0 0.6 0.0]);
            SetAnaglyphStereoParameters('RightGains', wptr, [1.0 0.0 0.0]);
        case 8,
            SetAnaglyphStereoParameters('LeftGains', wptr, [.65 0.0 0.0]);
            SetAnaglyphStereoParameters('RightGains', wptr, [0.0 0.3 1.0]);
        case 9,
            SetAnaglyphStereoParameters('LeftGains', wptr, [0.0 0.2 0.7]);
            SetAnaglyphStereoParameters('RightGains', wptr, [0.4 0.0 0.0]);
        otherwise
            %error('Unknown stereoMode specified.');
    end
    
    % Boost priority.
    Priority(2);
    
    % Hide the cursor.
    HideCursor;
    
    % Prepare for blurring the edges of the screen.
    shrink_factor = RectWidth(screenRect)/(2*widthx);
    maskblob_f = alphaMask(2*widthy,2*widthx,100);
    maskblob_h = maskblob_f/2;
    
    % Start the camera feed.
    set(vid1, 'FramesPerTrigger', 200);
    set(vid1, 'TriggerRepeat', inf);
    %     set(vid1.source,'BacklightCompensation', 'on');
    %     set(vid1.source,'BacklightCompensationMode','auto');
    if goggles
         set(vid1.source,'ExposureMode','auto');
         set(vid1.source,'VerticalFlip','on');
    end
    start(vid1);
    glFinish;
    
    % Initialize.
    [k, QuitFlag] = deal(0);
    tcount = 1;
    Tpress = GetSecs;

    t1 = zeros(1,10);
    t2 = zeros(1,10);
    stTime = GetSecs;

    % Main loop.
    while ~QuitFlag
        
        etime = (GetSecs-stTime);
        tim = find(etime >= exp.conttimes, 1, 'last' );
        if tim < length(exp.varcontrast)
            contrast = [exp.varcontrast(tim) exp.fixcontrast];
        elseif tim >= length(exp.varcontrast)
            contrast = [exp.crlev exp.fixcontrast];
        else 
            contrast = [exp.fixcontrast exp.fixcontrast];
        end
        if exp.depeye == 'r'
            contrast = flip(contrast);
        end
        % Flush the camera feed every 10 frames.
        k = k + 1;
        if k>10 && mod(k,10)==0
            flushdata(vid1);
        end
        
        % Get the next frame and hold on to the last one.
        %tex1 = tex2;
       % resultImg(:,:,1) = img_altered;
        %tex2 = Screen('MakeTexture', wptr, resultImg);
        
        img = getsnapshot(vid1);
        img = single(img(rows,cols));  %Pulls out 1st of 3 identical image planes
        for lor = 1:2
        if contrast(lor) ~= 1
            m = mean(img(:));
            tmpimg = img - m;
            tmpimg = tmpimg.*contrast(lor);
            tmpimg = tmpimg+m;
        else
            tmpimg = img;
        end
        tmpimg = uint8(tmpimg);
        tex(lor) = Screen('MakeTexture', wptr, tmpimg);
        end        

        % This combines the new frame with the last one to achieve a
        % smoother frame to frame transition.
        %         glBlendEquation(GL.FUNC_ADD);
        %         Screen('Blendfunction', wptr, GL_SRC_ALPHA, GL_ZERO);
        %         Screen('DrawTexture', wptr, tex1, Screen('Rect', tex2), CenterRect(Screen('Rect', tex2)*shrink_factor, Screen('Rect', wptr)),0,0);
        %         Screen('Blendfunction', wptr, GL_SRC_ALPHA, GL_ONE);
        %         Screen('DrawTexture', wptr, tex2, Screen('Rect', tex2), CenterRect(Screen('Rect', tex2)*shrink_factor, Screen('Rect', wptr)),0,0);
        %         Screen('Flip',wptr);
        
        
       %     img_altered = uint8(img(rows,cols));
       
        
        % Present the next frame.
        Screen('SelectStereoDrawBuffer', wptr, 0);
%        glBlendEquation(GL.FUNC_ADD);
%        Screen('Blendfunction', wptr, GL_SRC_ALPHA, GL_ZERO);
        Screen('DrawTexture', wptr, tex(1), Screen('Rect', tex(1)), CenterRect(Screen('Rect', tex(1))*shrink_factor,Screen('Rect', wptr)),0,0);
%         Screen('Blendfunction', wptr, GL_SRC_ALPHA, GL_ONE);
%         Screen('DrawTexture', wptr, tex2, Screen('Rect', tex2), CenterRect(Screen('Rect', tex2)*shrink_factor,Screen('Rect', wptr)),0,0);
        
        Screen('SelectStereoDrawBuffer', wptr, 1);
%        glBlendEquation(GL.FUNC_ADD);
%        Screen('Blendfunction', wptr, GL_SRC_ALPHA, GL_ZERO);
        Screen('DrawTexture', wptr, tex(2), Screen('Rect', tex(2)), CenterRect(Screen('Rect', tex(2))*shrink_factor,Screen('Rect', wptr)),0,0);
%         Screen('Blendfunction', wptr, GL_SRC_ALPHA, GL_ONE);
%         Screen('DrawTexture', wptr, tex2, Screen('Rect', tex2), CenterRect(Screen('Rect', tex2)*shrink_factor,Screen('Rect', wptr)),0,0);
        Screen('Flip',wptr);
        
        Screen('Close',tex);
        
        % Keyboard handling.
        [keyIsDown,timeSecs,keyCode] = KbCheck(-1);
        if keyIsDown&&(GetSecs-Tpress)>0.2
            if keyCode(KbName('LeftControl')) &&  keyCode(KbName('q'))
                QuitFlag=1;
                break,
            elseif keyCode(KbName('LeftControl'))  &&  keyCode(KbName('Space'))
                Switch = -1*Switch;
            elseif keyCode(KbName('LeftControl')) && keyCode(KbName('r'))
                thisTrial = doRivalryTaskNew(stim,exp,controls);
                 if tcount == 1
                     alltrials = thisTrial;
                 else
                     alltrials(tcount) = thisTrial;
                 end
                tcount = tcount+1;
            end
            Tpress = GetSecs;
        end
    end
    
    % Clean exit.
    stop(vid1);
    flushdata(vid1);
    ListenChar(0);
    Screen('CloseAll');
    ShowCursor;
    
    if ~isdir('data')
        mkdir('data');
    end
    cd data
    currT = datestr(now);
    currT = strrep(strrep(currT,' ','_'),':','-');
    fName = ['EyeDepdat_', subCode, '_',currT '.mat'];
    estr = ['save ',fName, ...
        ' subCode alltrials stim exp controls goggles stereoMode'];
    eval(estr)
    cd ..

    % Restore preferences
    Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
    
catch ME
    % Clean exit.
    rethrow(lasterror);
    stop(vid1);
    flushdata(vid1);
    ListenChar(0);
    Screen('CloseAll');
    ShowCursor;    
    if ~isdir('data')
        mkdir('data');
    end
    cd data
    currT = datestr(now);
    currT = strrep(strrep(currT,' ','_'),':','-');
    fName = ['EyeDepdat_', subCode, '_',currT '.mat'];
    estr = ['save ',fName, ...
        ' subCode alltrials stim orients controls goggles stereoMode crtim crlev testDur'];
    eval(estr)
    cd ..
    % Restore preferences
    Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
    
end