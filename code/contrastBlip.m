ob = double(imread('NormalGray.jpg')); 
figure(1);
subplot(1,3,1);
image(ob);colormap(gray(256)); axis image; axis off
imsize = size(ob); %should be size of img
mn = mean(mean(ob));
contOb = (ob-mn)./mn;%this is already done in our code

[x,y] = meshgrid(1:size(ob,2),1:size(ob,1));
%adapted to center
loc = flip(round(imsize./2));%location of contrast decrease (might want to randomize location)
sd = mn;%size of contrast decrease standardixze for mean of img

sigma = [sd.^2 0; 0 sd.^2];
dat = [x(:),y(:)];
%similiar to pdf in our code
cont_mult = mvnpdf(dat,loc,sigma); % creates gaussian
cont_mult = reshape(cont_mult,imsize(1),imsize(2));
cont_mult = cont_mult./max(max(cont_mult));
cont_mult = 1-cont_mult;

subplot(1,3,2);
imagesc(cont_mult); axis image;

contObBlip = contOb.*cont_mult;
contObBlip = contObBlip*mn+mn;
subplot(1,3,3);
image(contObBlip);colormap(gray(256)); axis image; axis off

