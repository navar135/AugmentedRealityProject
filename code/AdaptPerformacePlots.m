%%%This code plots and explores adaptation suppression performance
%%By: Karen T. Navarro 
%%10/11/2019

% assumes individual data is in same folder as code
load('ContDetermDiplopiaDat_YL_08-Nov-2019_12-51-51.mat')

%make matrix with all the contrast and corresponding rand eyes
DepthEyes=1-allDepths(:) % (1-allDepths since decreasing contrast

%make indecis for each eye 
ind1=DepthEyes(:,1)==1
ind2=DepthEyes(:,2)==2

%get corresponding values 
RightEye=DepthEyes(ind1,:)
LeftEye=DepthEyes(ind2,:)

%plot data for each eye
figure(1)
plot(RightEye)
hold on 
ylim([0 1])
title("Right Eye")
ylabel('contrast change')
xlabel('time')

figure(2)
plot(LeftEye)
hold on 
ylim([0 1])
title("Left Eye")
ylabel('contrast change')
xlabel('time')

%plot for one eye
figure(3)
plot(DepthEyes)



