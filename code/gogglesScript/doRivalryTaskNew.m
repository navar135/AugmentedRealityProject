function  thisTrial = doRivalryTaskNew(sinpat, exp, controls)

global wptr

cueTimer = GetSecs;
trialStart = cueTimer;
sRect = Screen('Rect', wptr);
lsinpat = sinpat;
lsinpat.orient = exp.orients(1); %pi/4;
rsinpat = sinpat;
rsinpat.orient = exp.orients(2); %3*pi/4;

lpatch = uint8(round(makeSinPatch(lsinpat)*128+127));
rpatch = uint8(round(makeSinPatch(rsinpat)*128+127));

siz = sinpat.nonouter-sinpat.nonwidth;
nonGrayRect = SetRect(1,1,siz,siz);
nonGrayRect = CenterRect(nonGrayRect,sRect);

docenter = sinpat.center > 0;
if docenter
siz = sinpat.center;
grayRect = SetRect(1,1,siz,siz);
grayRect = CenterRect(grayRect,sRect);
end

dofix = sinpat.fix > 0;
if dofix
siz = sinpat.fix;
fixRect = SetRect(1,1,siz,siz);
fixRect = CenterRect(fixRect,sRect);
end

siz = sinpat.nonouter;
nonim = zeros(siz,siz);
csiz = sinpat.checksize;
for i = 1:csiz:(siz-csiz+1)
    for j = 1:csiz:(siz-csiz+1)
        idxi = i:(i+csiz);
        idxj = j:(j+csiz);
        if rand(1,1) > 0.5
            nonim(idxi,idxj) = 0;
        else
            nonim(idxi,idxj) = 255;
        end
    end
end

rtex(1)= Screen('MakeTexture', wptr, lpatch);
rtex(2)= Screen('MakeTexture', wptr, rpatch);
ntex= Screen('MakeTexture', wptr, nonim);

for whbuf = 0:1
Screen('SelectStereoDrawBuffer', wptr, whbuf);
Screen('BlendFunction', wptr, GL_ONE, GL_ZERO);
Screen('FillRect', wptr, 127);
Screen('DrawTexture', wptr, ntex);  
Screen('FillRect', wptr, 127, nonGrayRect);
Screen('DrawTexture', wptr, rtex(whbuf+1));  
if docenter
Screen('FillOval', wptr, 127, grayRect);
end
if dofix
Screen('FillOval', wptr, 0, fixRect);
end
end

Screen('Flip',wptr);

thisTrial.allResps = [];
thisTrial.allTimes = [];

while ((GetSecs-trialStart) < exp.testDur)
[ thisTrial, cueTimer, quitCode] = rivGetResps(controls, thisTrial, cueTimer);
if quitCode
    break
end
end
thisTrial.trialStart = trialStart;
thisTrial.trialEnd = GetSecs;
end

