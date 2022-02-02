## this script is looking at eye performance with different blur levels 
## with new study version (temporal delay)
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

files <- c("matFiles/AdaptationDiplopiaDat_blurLevel_KT_10-Feb-2020_16-26-52.mat")
files <- as.character(files)
subjects <- c("KT" #started w/ no blur (200 trials)
              ) 
for (k in 1:length(files)) {
  #read in data and variables
  dat <- read.mat(files[k])
  depths<-dat$trials$depth
  depths<-(1-as.numeric(depths[cumsum(depths == 0)<2 & depths!=0]))
  decEye <- dat$trials$eye #1 = left, 2=right
  decEye <- as.numeric(decEye[1:length(depths)])
  sndDelay <- dat$trials$sndDelay
  sndDelay <- as.numeric(sndDelay[1:length(depths)])
  rt<-dat$trials$rt
  rt<- rt[1:length(depths)]
  rt<-as.numeric(rt) #convert from list to numeric
  time <- -(dat$stTime - rt)
  correct<- dat$trials$correct
  correct<- correct[1:length(depths)]
  

  subject <-
    as.vector(matrix(subjects[k], nrow = length(depths)))
  deprivedEye <-
    as.numeric(matrix(dat$exp$depeye, nrow = length(depths)))
  index <-
    as.numeric(matrix(1:length(depths), nrow = length(depths)))
  blurDat <-
    data.frame(
      index,
      subject,
      deprivedEye,
      time,
      depths,
      decEye,
      sndDelay,
      correct
    )
  
  blurryEye<-subset(blurDat, decEye == deprivedEye) 
  nonBlurryEye<-subset(blurDat, decEye != deprivedEye)
}

gg3<- ggplot(data=nonBlurryEye, aes(x=index,y=depths)) +
  geom_point(aes(color=subject)) + geom_line(aes(color=subject))+ ylim(0,1)
gg3<- gg3+ labs(x = "trials",y = "contrast change", title =
                "Non-Blurry Eye Performance")
gg3<- gg3 + geom_vline(xintercept = 50, color = "blue") + 
  geom_vline(xintercept = 100, color = "blue") + 
  geom_vline(xintercept = 150, color = "blue") 
gg4<- ggplot(data=blurryEye, aes(x=index,y=depths)) +
  geom_point(aes(color=subject)) + geom_line(aes(color=subject)) + ylim(0,1)
gg4<- gg4+ labs(x = "trials",y = "contrast change", title =
                  "Blurry Eye Performance")
gg4<- gg4+ geom_vline(xintercept = 50, color = "blue") + 
  geom_vline(xintercept = 100, color = "blue") + 
  geom_vline(xintercept = 150, color = "blue") 
grid.arrange(gg3, gg4, nrow=2)
##
files<- as.character(c("matFiles/AdaptationDiplopiaDat_CC_blur1_11-Feb-2020_15-26-21.mat",
                       "matFiles/AdaptationDiplopiaDat_CC_blur4_11-Feb-2020_16-00-08.mat",
                       "matFiles/AdaptationDiplopiaDat_CC_blur2_11-Feb-2020_15-38-01.mat",
                       "matFiles/AdaptationDiplopiaDat_CC_blur3_11-Feb-2020_15-49-16.mat",
                       "matFiles/AdaptationDiplopiaDat_YL_blur1_4rnd_11-Feb-2020_17-10-54.mat",
                       "matFiles/AdaptationDiplopiaDat_YL_blur2_3rnd_11-Feb-2020_17-00-43.mat",
                       "matFiles/AdaptationDiplopiaDat_YL_blur3_2rnd_11-Feb-2020_16-50-57.mat",
                       "matFiles/AdaptationDiplopiaDat_YL_blur4_1strnd_11-Feb-2020_16-40-04.mat"
                        ))
subjects<- c("CC1","CC2","CC3","CC4",#started w/noblur
             "YL1","YL2","YL3","YL4" #started w/ full blur
              )
blurLev<- rep(1:4,times=2)

for (k in 1:length(files)) {
  #read in data and variables
  dat <- read.mat(files[k])
  depths<-(dat$trials$depth)
  depths<-(1-as.numeric(depths[cumsum(depths == 0)<2 & depths!=0]))
  decEye <- dat$trials$eye #1 = left, 2=right
  decEye <- as.numeric(decEye[1:length(depths)])
    
  sndDelay <- dat$trials$sndDelay
  sndDelay <- as.numeric(sndDelay[1:length(depths)])
  rt<-dat$trials$rt
  rt<- rt[1:length(depths)]
  rt<-as.numeric(rt) #convert from list to numeric
  time <- (dat$endTime - dat$stTime)
  correct<- dat$trials$correct
  correct<- as.numeric(correct[1:length(depths)])
  butPress<- dat$trials$button
  butPress <- as.numeric(butPress[1:length(depths)])
  
  subject <-
    as.vector(matrix(subjects[k], nrow = length(depths)))
  deprivedEye <-
    as.numeric(matrix(dat$exp$depeye, nrow = length(depths)))
  index <-
    as.numeric(matrix(1:length(depths), nrow = length(depths))) 
  blurLevel<- 
    as.numeric(matrix(blurLev[k], nrow = length(depths))) 
    
  blurDat <-
    data.frame(
      index,
      subject,
      blurLevel,
      deprivedEye,
      depths,
      decEye,
      sndDelay,
      butPress,
      correct
    )
  
  write.csv(blurDat, paste0('blurDat_', subjects[k], '.csv'))

}

temp <- list.files(pattern="*blurDat_")
temp <-ldply(temp, read_csv)
temp$X1 <- NULL
sub <-rep( c("CC", "YL"), c(232,227))
temp$totsub<-sub
blurryEye<-subset(temp, decEye == deprivedEye) 
nonBlurryEye<-subset(temp, decEye != deprivedEye)

gg<- ggplot(data=nonBlurryEye, aes(x=index,y=depths)) +
  geom_point(aes(color=totsub)) + geom_line(aes(color=totsub))+ ylim(0,1)
gg<- gg+ labs(x = "trials",y = "contrast change", title =
                "Non-Blurry Eye Performance")
gg<- gg+facet_grid(. ~ blurLevel)

gg1<- ggplot(data=blurryEye, aes(x=index,y=depths)) +
  geom_point(aes(color=totsub)) + geom_line(aes(color=totsub)) + ylim(0,1)
gg1<- gg1+ labs(x = "trials",y = "contrast change", title =
                  "Blurry Eye Performance")
gg1<- gg1+facet_grid(. ~ blurLevel)

grid.arrange(gg, gg1,gg3,gg4, nrow=4)


