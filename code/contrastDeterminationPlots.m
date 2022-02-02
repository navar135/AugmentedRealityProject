%%%This code plots and explores adaptation suppression performance to
%%%determine start contrast 
%%By: Karen T. Navarro 
%%11/04/2019

% assumes individual data is in same folder as code
load('ContDetermDiplopiaDat_YL_08-Nov-2019_12-51-51.mat')
%make matrix with all the contrast
Depths=1-allDepths(1:110) % 1-allDepths since decreasing contrast
time = -(stTime-allcontDecTime(1:110))
mu = -(stTime-allcontDecTime(52))
% load('ContDetermDiplopiaDat_KTN_uncovered_04-Nov-2019_09-26-27.mat')
% 
% %make matrix with all the contrast and corresponding rand eyes
% DepthEyes1=1-allDepths(:)

% %plot data for one eye covered & deprived contrast
% figure(1)
% plot(DepthEyes)
% hold on 
% ylim([0 1])
% title("un-deprived eye covered")
% ylabel('contrast change')
% xlabel('time')


%plot data for one eye UNcovered & deprived contrast
figure(1)
plot(time,Depths)
hold on 
xline(mu,'r')
ylim([0 1])
%xlim([0 190])
title("Contrast decrement performance (Sub:YL-Circle-Larger Radius)")
ylabel('contrast change')
xlabel('time')
hold off


