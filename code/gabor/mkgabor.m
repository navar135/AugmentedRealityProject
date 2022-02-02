function [img]=mkgabor(contrast,sdpix,cycperim,ang,phs,imsize)

[x,y]=meshgrid(-imsize/2:imsize/2,-imsize/2:imsize/2);

a=sin(ang);
b=cos(ang);

r = sqrt(x.^2+y.^2);
GaussianWin = normpdf(r,0,sdpix);

m=GaussianWin.*sin(a*x*2*pi*cycperim./imsize+b*y*2*pi*cycperim./imsize+phs);
img = m/max(m(:))*contrast;
