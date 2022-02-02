% Clear memory.
clear all;

KbName('UnifyKeyNames');
ptbox = 0;

% User input requested: attuation or enhancement filter?
ARmode = [];
while 1
    ARmode = input('(1) Attenuation (2) Enhancement or (3) None? ');
    if ~isempty(ARmode) && isnumeric(ARmode)
        if ARmode == 1 || ARmode == 2 
            Switch = 1;
            break
        elseif ARmode == 3
            Switch = -1;
            break;
        end
    end
end

% Default to attenuation filter.
if isempty(ARmode)
    ARmode = 1;
end

% Attenuate or enhance with 85%.
if ARmode == 1
    contrast = 1;
    AmpFactor = 0.85;
elseif ARmode == 2
    contrast = 1;
    AmpFactor = 1.85;
elseif ARmode == 3
    contrast = 1;
    AmpFactor = 1;
end

% Attenuate or enhance verticals.
AdaptOri = 90;

% Some subfunctions need these variables need to be global.
global wptr monitor GL;

% Monitor settings.
monitor.size = [tand(37.2/2)*100*2 tand(37.2/2)*100*2/1280*1024];
monitor.viewDist = 100;

% Select a PTB screen.
screens = Screen('Screens');
screenNumber = max(Screen('Screens'));

% Determine the frame rate.
monitor.fRate = Screen('FrameRate',screenNumber);
if monitor.fRate == 0, monitor.fRate = 60; end

% Determine the gray background color index.
bkgcol = GrayIndex(screenNumber);

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
    vid1 = videoinput('macvideo', 1, 'YCbCr422_1280x720');
    
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
    if ARmode < 3
        R = visAng*(widthy*2)/(widthx*2);
        R_mu = R*1.5; R_window = 0; R_cutoff1 = R_mu-.2891*R; R_cutoff2 = 7.7846*R-R_mu; R_order = 3;
        A_mu = 90; A_window = 0; A_cutoff1 = 53.4530; A_cutoff2 = 53.4530; A_order = 6;
        mask1 = makeMask(R_mu, R_window, R_cutoff1,R_cutoff2,R_order,A_mu, A_window, A_cutoff1, A_cutoff2, A_order, widthy*2, widthy*2);
        mask1 = imresize(mask1,[2*widthy,2*widthx]);
        mask1 = mask1 - min(mask1(:));
        mask1 = mask1/max(mask1(:));
        
        % Tailor the filter to attenuation or enhancement.
        if ARmode == 2
            mask1 = mask1/max(mask1(:));
            mask1 = (mask1-1).*(AmpFactor-1);
            mask1 = 1-mask1;
        elseif ARmode == 1
            mask1 = (1-mask1).*(AmpFactor);
            mask1 = 1-mask1;
        end
        
        % Use the GPU to do the filtering.
        if ptbox
            Gmask = gpuArray(single(mask1));
            Gimg = gpuArray(zeros(2*widthy,2*widthx));
        else
            Gmask = (single(mask1));
            Gimg = (zeros(2*widthy,2*widthx));
            
        end
    end
    % Some parameters we need.
    rows = 480/2-widthy+1:480/2+widthy;
    cols = 752/2-widthx+1:752/2+widthx;
    
    % Open the PTB screen.
    InitializeMatlabOpenGL([],[],1);
    Screen('Preference','SkipSyncTests',1);
    PsychImaging('PrepareConfiguration');
    Screen('Preference','SkipSyncTests',1);
    [wptr, screenRect] = PsychImaging('OpenWindow', screenNumber, 0);
    
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
    %     set(vid1.source,'ExposureMode','auto');
    %     set(vid1.source,'VerticalFlip','on');
    start(vid1);
    glFinish;
    
    % Filter the first camera image frame.
    img = getsnapshot(vid1);
    Gimg = img(rows,cols);
    Gimg = single(Gimg);
    m = 0;
    if contrast ~= 1
        m = mean(Gimg(:));
        Gimg = Gimg - m;
        Gimg = Gimg.*contrast;
    end
    if ARmode < 3
        ft = fft2(Gimg);
        ft = ft.*Gmask;
        if ptbox
            img_altered = gather(uint8(real(ifft2(ft) + m)));
        else
            img_altered = (uint8(real(ifft2(ft) + m)));
        end
        resultImg(:,:,1) = uint8(img_altered);
    else
        img_altered = uint8(Gimg);
        resultImg(:,:,1) = uint8(Gimg);
    end
    resultImg(:,:,2) = maskblob_h;
    tex2 = Screen('MakeTexture',wptr,resultImg);
    
    % Initialize.
    [k, QuitFlag] = deal(0);
    
    Tpress = GetSecs;
    
    t1 = zeros(1,10);
    t2 = zeros(1,10);
    % Main loop.
    while ~QuitFlag
        
        % Flush the camera feed every 10 frames.
        k = k + 1;
        if k>10 && mod(k,10)==0;
            flushdata(vid1);
        end
        
        % Get the next frame and hold on to the last one.
        tex1 = tex2;
        resultImg(:,:,1) = img_altered;
        tex2 = Screen('MakeTexture', wptr, resultImg);
        t1(k) = GetSecs;
        img = getsnapshot(vid1);
        t2(k) = GetSecs;

        % Apply an fft to the image if the filter is on.
        if Switch == 1
            if ptbox
                Gimg = gpuArray(single(img(rows,cols)));
                Gimg = single(Gimg);
            else
                Gimg = single(img(rows,cols));
            end
            if contrast ~= 1
                m = mean(Gimg(:));
                Gimg = Gimg - m;
                Gimg = Gimg.*contrast;
            end
            if ARmode < 3
                ft = fft2(Gimg);
            end
        end
        
        % This combines the new frame with the last one to achieve a
        % smoother frame to frame transition.
        glBlendEquation(GL.FUNC_ADD);
        Screen('Blendfunction', wptr, GL_SRC_ALPHA, GL_ZERO);
        Screen('DrawTexture', wptr, tex1, Screen('Rect', tex2), CenterRect(Screen('Rect', tex2)*shrink_factor, Screen('Rect', wptr)),0,0);
        Screen('Blendfunction', wptr, GL_SRC_ALPHA, GL_ONE);
        Screen('DrawTexture', wptr, tex2, Screen('Rect', tex2), CenterRect(Screen('Rect', tex2)*shrink_factor, Screen('Rect', wptr)),0,0);
        Screen('Flip',wptr);
        
        % Apply the filter if it is on.
        if (Switch == 1) && (ARmode < 3)
            ft = ft.*Gmask;
            if ptbox
                img_altered = gather(uint8(real(ifft2(ft) + m)));
            else
                img_altered = (uint8(real(ifft2(ft) + m)));
            end
        else
            img_altered = uint8(img(rows,cols));
        end
        
        % Present the next frame.
        glBlendEquation(GL.FUNC_ADD);
        Screen('Blendfunction', wptr, GL_SRC_ALPHA, GL_ZERO);
        Screen('DrawTexture', wptr, tex2, Screen('Rect', tex2), CenterRect(Screen('Rect', tex2)*shrink_factor,Screen('Rect', wptr)),0,0);
        Screen('Blendfunction', wptr, GL_SRC_ALPHA, GL_ONE);
        Screen('DrawTexture', wptr, tex2, Screen('Rect', tex2), CenterRect(Screen('Rect', tex2)*shrink_factor,Screen('Rect', wptr)),0,0);
        Screen('Flip',wptr);
        Screen('Close',tex1);
        
        % Keyboard handling.
        [keyIsDown,timeSecs,keyCode] = KbCheck;
        if keyIsDown&&(GetSecs-Tpress)>0.2
            if keyCode(KbName('Control')) && keyCode(KbName('Alt')) &&  keyCode(KbName('q'))
                QuitFlag=1;
                break,
            elseif keyCode(KbName('Control')) && keyCode(KbName('Alt')) &&  keyCode(KbName('Space'))
                Switch = -1*Switch;
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
    
    % Restore preferences
    Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
    
catch ME
    
    % Clean exit.
    stop(vid1);
    flushdata(vid1);
    ListenChar(0);
    Screen('CloseAll');
    ShowCursor;
    rethrow(ME);
    
    % Restore preferences
    Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
    
end