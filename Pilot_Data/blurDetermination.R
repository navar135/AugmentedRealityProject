## this script is looking at eye performance with different blur levels
library(rmatio)
library(dplyr)
library(tidyr)
library(plyr)
library(ggplot2)
library(gridExtra)
library(readr)
library(directlabels)
library(psycho)
library(reshape2)

setwd("/Users/navar135/Documents/UMN_Research/Projects/Diplopia/Pilot_Data")

dat<-read.mat("matFiles/AdaptationDiplopiaDat_blurTest_19-Dec-2019_11-25-23.mat")

allTrialResp<- dat$allTrialResp
time <- -(dat$stTime - dat$allcontDecTime)
time <-time[1:length(allTrialResp)]
#process contrast change ( 0=full contrast decrease)
allDepths <- 1-dat$allDepths
allDepths<- allDepths[1:length(allTrialResp)]
allRandEyes <- dat$allRandEyes #1 = left, 2=right
allRandEyes<- allRandEyes[1:length(allTrialResp)]
allContKeys <- dat$allContKeys #1=yes 2=no
allContKeys<- allContKeys[1:length(allTrialResp)]
allNoiseorsignal <- dat$allNoiseorsignal #0 =noise #1=signal
allNoiseorsignal<- allNoiseorsignal[1:length(allTrialResp)]
subject <-
  as.vector(matrix("blurTest", nrow = length(allRandEyes)))
deprivedEye <-
  as.numeric(matrix(dat$exp$depeye, nrow = length(allRandEyes)))
index <-
  as.numeric(matrix(1:length(allRandEyes), nrow = length(allRandEyes)))
adapt <-
  data.frame(
    index,
    subject,
    deprivedEye,
    time,
    allContKeys,
    allTrialResp,
    allDepths,
    allNoiseorsignal,
    allRandEyes
  )

blurryEye<-subset(adapt, allRandEyes == deprivedEye) 
nonBlurryEye<-subset(adapt, allRandEyes != deprivedEye)

#plot contrast change in each eye
gg<- ggplot(data=nonBlurryEye, aes(x=time,y=allDepths)) +
  geom_point(aes(color=subject)) + geom_line(aes(color=subject)) + ylim(0,1)
gg<- gg+ labs(x = "time (s)",y = "contrast change", title =
                "Non-Blurry Eye Performance")
gg<- gg + geom_vline(xintercept = 600, color = "blue") + 
  geom_vline(xintercept = 1200, color = "blue") + 
  geom_vline(xintercept = 1800, color = "blue") 

gg1<- ggplot(data=blurryEye, aes(x=time,y=allDepths)) +
  geom_point(aes(color=subject)) + geom_line(aes(color=subject)) + ylim(0,1)
gg1<- gg1+ labs(x = "time (s)",y = "contrast change", title =
                  "Blurry Eye Performance")
gg1<- gg1 + geom_vline(xintercept = 600, color = "blue") + 
  geom_vline(xintercept = 1200, color = "blue") + 
  geom_vline(xintercept = 1800, color = "blue") 
grid.arrange(gg, gg1, nrow=2)
