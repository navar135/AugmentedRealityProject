##plot adaptation results 
##by: Karen T Navarro 
##11/09/19

#set environment
library(rmatio)
library(dplyr)
library(plyr)
library(ggplot2)
library(gridExtra)

#load data
setwd("/Users/navar135/Documents/UMN_Research/Projects/Diplopia/Pilot_Data")
adaptation <- read.mat("AdaptationDiplopiaDat_KTN_day3_14-Nov-2019_16-49-55.mat")
#adaptation<- read.mat("AdaptationDiplopiaDat_KTN_test_11-Nov-2019_16-41-04.mat")
#subset data for each eye
time = -(adaptation$stTime-adaptation$allcontDecTime[0:320])
DepthEyes<-1-adaptation$allDepths[0:320]
allRandEyes <- adaptation$allRandEyes[0:320]
allResp <- adaptation$allResp[0:320]
allNoiseorsignal<- adaptation$allNoiseorsignal[0:320]
depthXeye<-data.frame(allRandEyes,DepthEyes,time, allResp, allNoiseorsignal)
leftEyeDepth<-subset(depthXeye, allRandEyes == 1)
rightEyeDepth<-subset(depthXeye, allRandEyes == 2)

respTrial<-data.frame(adaptation$allResp[0:320],adaptation$allNoiseorsignal[0:320])
respTrial<-rename(respTrial, c("adaptation.allResp.0.320."="allResp", 
                    "adaptation.allNoiseorsignal.0.320."="allNoiseorsignal"))
#yesResp<- subset(respTrial,respTrial$allResp== 1)
#noResp <- subset(adaptation,adaptation$allResp== 2)
trial <- subset(respTrial,allNoiseorsignal== 1)
noTrial <- subset(respTrial,allNoiseorsignal[1:320]== 0)
hit<-subset(respTrial,allNoiseorsignal== 1 & allResp ==1)
corrRej <- subset(respTrial,allNoiseorsignal== 0 & allResp ==2)
falsePos <- subset(respTrial,allNoiseorsignal== 0 & allResp ==1)
falseNeg <- subset(respTrial,allNoiseorsignal== 1 & allResp ==2)

stairTable <- matrix(c(length(hit$allResp),length(corrRej$allResp),
                       length(falseNeg$allResp),length(falsePos$allResp),
                       length(hit$allResp)/length(trial$allResp),
                       length(corrRej$allResp)/length(noTrial$allResp),
                       length(falseNeg$allResp)/length(trial$allResp),
                       length(falsePos$allResp)/length(noTrial$allResp),
                       length(trial$allResp),length(noTrial$allResp),
                       length(trial$allResp),length(noTrial$allResp)),
                     ncol= 4,nrow = 3, byrow =TRUE)
stairTable <- as.table(stairTable)
rownames(stairTable) <- c("sum","proportion","Total")
colnames(stairTable) <- c("Hit","Correct Reject","False Negative", "False Positive")
grid.table(stairTable)
stairTable
#ggsave("HitMiss.pdf",stairTable)
#data for each eye 
Ltrial <- subset(leftEyeDepth,allNoiseorsignal== 1)
LnoTrial <- subset(leftEyeDepth,allNoiseorsignal[1:320]== 0)
Lhit<-subset(leftEyeDepth,allNoiseorsignal== 1 & allResp ==1)
LcorrRej <- subset(leftEyeDepth,allNoiseorsignal== 0 & allResp ==2)
LfalsePos <- subset(leftEyeDepth,allNoiseorsignal== 0 & allResp ==1)
LfalseNeg <- subset(leftEyeDepth,allNoiseorsignal== 1 & allResp ==2)
LstairTable <- matrix(c(length(Lhit$allResp),length(LcorrRej$allResp),
                       length(LfalseNeg$allResp),length(LfalsePos$allResp),
                       length(Lhit$allResp)/length(Ltrial$allResp),
                       length(LcorrRej$allResp)/length(LnoTrial$allResp),
                       length(LfalseNeg$allResp)/length(Ltrial$allResp),
                       length(LfalsePos$allResp)/length(LnoTrial$allResp),
                       length(Ltrial$allResp),length(LnoTrial$allResp),
                       length(Ltrial$allResp),length(LnoTrial$allResp)),
                       ncol= 4,nrow = 3, byrow =TRUE)
LstairTable <- as.table(LstairTable)
rownames(LstairTable) <- c("sum","proportion","Total")
colnames(LstairTable) <- c("Hit","Correct Reject","False Negative", "False Positive")
grid.table(LstairTable)
LstairTable
#right eye 
Rtrial <- subset(rightEyeDepth,allNoiseorsignal== 1)
RnoTrial <- subset(rightEyeDepth,allNoiseorsignal[1:320]== 0)
Rhit<-subset(rightEyeDepth,allNoiseorsignal== 1 & allResp ==1)
RcorrRej <- subset(rightEyeDepth,allNoiseorsignal== 0 & allResp ==2)
RfalsePos <- subset(rightEyeDepth,allNoiseorsignal== 0 & allResp ==1)
RfalseNeg <- subset(rightEyeDepth,allNoiseorsignal== 1 & allResp ==2)
RstairTable <- matrix(c(length(Rhit$allResp),length(RcorrRej$allResp),
                        length(RfalseNeg$allResp),length(RfalsePos$allResp),
                        length(Rhit$allResp)/length(Rtrial$allResp),
                        length(RcorrRej$allResp)/length(RnoTrial$allResp),
                        length(RfalseNeg$allResp)/length(Rtrial$allResp),
                        length(RfalsePos$allResp)/length(RnoTrial$allResp),
                        length(Rtrial$allResp),length(RnoTrial$allResp),
                        length(Rtrial$allResp),length(RnoTrial$allResp)),
                      ncol= 4,nrow = 3, byrow =TRUE)
RstairTable <- as.table(RstairTable)
rownames(RstairTable) <- c("sum","proportion","Total")
colnames(RstairTable) <- c("Hit","Correct Reject","False Negative", "False Positive")
grid.table(RstairTable)
RstairTable
#plot data
gg<- ggplot(data=leftEyeDepth, aes(x=time,y=DepthEyes)) + 
  geom_point() + geom_line() + ylim(0,1)
gg<- gg+ labs(x = "time (s)",y = "contrast change", title = 
                "Left Eye Performance")

gg1<- ggplot(data=rightEyeDepth, aes(x=time,y=DepthEyes)) + 
  geom_point() + geom_line() + ylim(0,1)
gg1<- gg1+ labs(x = "time (s)",y = "contrast change", title = 
                "Right Eye Performance (blurry eye)")
ggsave("adaptation_YL_day1.pdf", arrangeGrob(gg, gg1))

##Test the variables are working
testing <- read.mat("AdaptationDiplopiaDat_testVar_11-Nov-2019_15-41-45.mat")
allContKeys <- testing$allContKeys[0:40] #1=yes 2=no
allDepths <- 1-testing$allDepths[0:40]#if 2 consecutive correct then
allNoiseorsignal <- testing$allNoiseorsignal[0:40]
allRandEyes <- testing$allRandEyes[0:40]
time <- -(testing$stTime-testing$allcontDecTime[0:40])
checkVar <-data.frame(allContKeys,allDepths,allNoiseorsignal,allRandEyes)
leftEye <- subset(checkVar, allRandEyes ==1)
rightEye <- subset(checkVar, allRandEyes ==2)

###Check data of test dataset after staircase modification

adaptation<- read.mat("AdaptationDiplopiaDat_KTN_test_11-Nov-2019_16-41-04.mat")
#subset data for each eye
time = -(adaptation$stTime-adaptation$allcontDecTime[0:130])
allDepths<-1-adaptation$allDepths[0:130]
allRandEyes <- adaptation$allRandEyes[0:130]
allContKeys <- adaptation$allContKeys[0:130] #1=yes 2=no
allNoiseorsignal<- adaptation$allNoiseorsignal[0:130]
checkVar <-data.frame(allContKeys,allDepths,allNoiseorsignal,allRandEyes)
leftEye <- subset(checkVar, allRandEyes ==1)
rightEye <- subset(checkVar, allRandEyes ==2)

#yesResp<- subset(respTrial,respTrial$allResp== 1)
#noResp <- subset(adaptation,adaptation$allResp== 2)
trial <- subset(checkVar,allNoiseorsignal== 1)
noTrial <- subset(checkVar,allNoiseorsignal[1:130]== 0)
hit<-subset(checkVar,allNoiseorsignal== 1 & allContKeys ==1)
corrRej <- subset(checkVar,allNoiseorsignal== 0 & allContKeys ==2)
falsePos <- subset(checkVar,allNoiseorsignal== 0 & allContKeys ==1)
falseNeg <- subset(checkVar,allNoiseorsignal== 1 & allContKeys ==2)

stairTable <- matrix(c(length(hit$allContKeys),length(corrRej$allContKeys),
                       length(falseNeg$allContKeys),length(falsePos$allContKeys),
                       length(hit$allContKeys)/length(trial$allContKeys),
                       length(corrRej$allContKeys)/length(noTrial$allContKeys),
                       length(falseNeg$allContKeys)/length(trial$allContKeys),
                       length(falsePos$allContKeys)/length(noTrial$allContKeys),
                       length(trial$allContKeys),length(noTrial$allContKeys),
                       length(trial$allContKeys),length(noTrial$allContKeys)),
                     ncol= 4,nrow = 3, byrow =TRUE)
stairTable <- as.table(stairTable)
rownames(stairTable) <- c("sum","proportion","Total")
colnames(stairTable) <- c("Hit","Correct Reject","False Negative", "False Positive")
grid.table(stairTable)
stairTable
#ggsave("HitMiss.pdf",stairTable)
#data for each eye 
Ltrial <- subset(leftEye,allNoiseorsignal== 1)
LnoTrial <- subset(leftEye,allNoiseorsignal[1:320]== 0)
Lhit<-subset(leftEye,allNoiseorsignal== 1 & allContKeys ==1)
LcorrRej <- subset(leftEye,allNoiseorsignal== 0 & allContKeys ==2)
LfalsePos <- subset(leftEye,allNoiseorsignal== 0 & allContKeys ==1)
LfalseNeg <- subset(leftEye,allNoiseorsignal== 1 & allContKeys ==2)
LstairTable <- matrix(c(length(Lhit$allContKeys),length(LcorrRej$allContKeys),
                        length(LfalseNeg$allContKeys),length(LfalsePos$allContKeys),
                        length(Lhit$allContKeys)/length(Ltrial$allContKeys),
                        length(LcorrRej$allContKeys)/length(LnoTrial$allContKeys),
                        length(LfalseNeg$allContKeys)/length(Ltrial$allContKeys),
                        length(LfalsePos$allContKeys)/length(LnoTrial$allContKeys),
                        length(Ltrial$allContKeys),length(LnoTrial$allContKeys),
                        length(Ltrial$allContKeys),length(LnoTrial$allContKeys)),
                      ncol= 4,nrow = 3, byrow =TRUE)
LstairTable <- as.table(LstairTable)
rownames(LstairTable) <- c("sum","proportion","Total")
colnames(LstairTable) <- c("Hit","Correct Reject","False Negative", "False Positive")
grid.table(LstairTable)
LstairTable
#right eye 
Rtrial <- subset(rightEye,allNoiseorsignal== 1)
RnoTrial <- subset(rightEye,allNoiseorsignal[1:320]== 0)
Rhit<-subset(rightEye,allNoiseorsignal== 1 & allContKeys ==1)
RcorrRej <- subset(rightEye,allNoiseorsignal== 0 & allContKeys ==2)
RfalsePos <- subset(rightEye,allNoiseorsignal== 0 & allContKeys ==1)
RfalseNeg <- subset(rightEye,allNoiseorsignal== 1 & allContKeys ==2)
RstairTable <- matrix(c(length(Rhit$allContKeys),length(RcorrRej$allContKeys),
                        length(RfalseNeg$allContKeys),length(RfalsePos$allContKeys),
                        length(Rhit$allContKeys)/length(Rtrial$allContKeys),
                        length(RcorrRej$allContKeys)/length(RnoTrial$allContKeys),
                        length(RfalseNeg$allContKeys)/length(Rtrial$allContKeys),
                        length(RfalsePos$allContKeys)/length(RnoTrial$allContKeys),
                        length(Rtrial$allContKeys),length(RnoTrial$allContKeys),
                        length(Rtrial$allContKeys),length(RnoTrial$allContKeys)),
                      ncol= 4,nrow = 3, byrow =TRUE)
RstairTable <- as.table(RstairTable)
rownames(RstairTable) <- c("sum","proportion","Total")
colnames(RstairTable) <- c("Hit","Correct Reject","False Negative", "False Positive")
grid.table(RstairTable)
RstairTable


#KTN day 1
adaptation<- read.mat("AdaptationDiplopiaDat_KTN_day2_13-Nov-2019_15-10-58.mat")
#subset data for each eye
time = -(adaptation$stTime-adaptation$allcontDecTime)
allDepths<-1-adaptation$allDepths
allRandEyes <- adaptation$allRandEyes
allContKeys <- adaptation$allContKeys #1=yes 2=no
allNoiseorsignal<- adaptation$allNoiseorsignal
checkVar <-data.frame(allContKeys,allDepths,allNoiseorsignal,allRandEyes,time)
leftEye <- subset(checkVar, allRandEyes ==1)
rightEye <- subset(checkVar, allRandEyes ==2)

#yesResp<- subset(respTrial,respTrial$allResp== 1)
#noResp <- subset(adaptation,adaptation$allResp== 2)
trial <- subset(checkVar,allNoiseorsignal== 1)
noTrial <- subset(checkVar,allNoiseorsignal== 0)
hit<-subset(checkVar,allNoiseorsignal== 1 & allContKeys ==1)
corrRej <- subset(checkVar,allNoiseorsignal== 0 & allContKeys ==2)
falsePos <- subset(checkVar,allNoiseorsignal== 0 & allContKeys ==1)
falseNeg <- subset(checkVar,allNoiseorsignal== 1 & allContKeys ==2)

stairTable <- matrix(c(length(hit$allContKeys),length(corrRej$allContKeys),
                       length(falseNeg$allContKeys),length(falsePos$allContKeys),
                       length(hit$allContKeys)/length(trial$allContKeys),
                       length(corrRej$allContKeys)/length(noTrial$allContKeys),
                       length(falseNeg$allContKeys)/length(trial$allContKeys),
                       length(falsePos$allContKeys)/length(noTrial$allContKeys),
                       length(trial$allContKeys),length(noTrial$allContKeys),
                       length(trial$allContKeys),length(noTrial$allContKeys)),
                     ncol= 4,nrow = 3, byrow =TRUE)
stairTable <- as.table(stairTable)
rownames(stairTable) <- c("sum","proportion","Total")
colnames(stairTable) <- c("Hit","Correct Reject","False Negative", "False Positive")
grid.table(stairTable)
stairTable
#ggsave("HitMiss.pdf",stairTable)
#data for each eye 
Ltrial <- subset(leftEye,allNoiseorsignal== 1)
LnoTrial <- subset(leftEye,allNoiseorsignal[1:320]== 0)
Lhit<-subset(leftEye,allNoiseorsignal== 1 & allContKeys ==1)
LcorrRej <- subset(leftEye,allNoiseorsignal== 0 & allContKeys ==2)
LfalsePos <- subset(leftEye,allNoiseorsignal== 0 & allContKeys ==1)
LfalseNeg <- subset(leftEye,allNoiseorsignal== 1 & allContKeys ==2)
LstairTable <- matrix(c(length(Lhit$allContKeys),length(LcorrRej$allContKeys),
                        length(LfalseNeg$allContKeys),length(LfalsePos$allContKeys),
                        length(Lhit$allContKeys)/length(Ltrial$allContKeys),
                        length(LcorrRej$allContKeys)/length(LnoTrial$allContKeys),
                        length(LfalseNeg$allContKeys)/length(Ltrial$allContKeys),
                        length(LfalsePos$allContKeys)/length(LnoTrial$allContKeys),
                        length(Ltrial$allContKeys),length(LnoTrial$allContKeys),
                        length(Ltrial$allContKeys),length(LnoTrial$allContKeys)),
                      ncol= 4,nrow = 3, byrow =TRUE)
LstairTable <- as.table(LstairTable)
rownames(LstairTable) <- c("sum","proportion","Total")
colnames(LstairTable) <- c("Hit","Correct Reject","False Negative", "False Positive")
grid.table(LstairTable)
LstairTable
#right eye 
Rtrial <- subset(rightEye,allNoiseorsignal== 1)
RnoTrial <- subset(rightEye,allNoiseorsignal[1:320]== 0)
Rhit<-subset(rightEye,allNoiseorsignal== 1 & allContKeys ==1)
RcorrRej <- subset(rightEye,allNoiseorsignal== 0 & allContKeys ==2)
RfalsePos <- subset(rightEye,allNoiseorsignal== 0 & allContKeys ==1)
RfalseNeg <- subset(rightEye,allNoiseorsignal== 1 & allContKeys ==2)
RstairTable <- matrix(c(length(Rhit$allContKeys),length(RcorrRej$allContKeys),
                        length(RfalseNeg$allContKeys),length(RfalsePos$allContKeys),
                        length(Rhit$allContKeys)/length(Rtrial$allContKeys),
                        length(RcorrRej$allContKeys)/length(RnoTrial$allContKeys),
                        length(RfalseNeg$allContKeys)/length(Rtrial$allContKeys),
                        length(RfalsePos$allContKeys)/length(RnoTrial$allContKeys),
                        length(Rtrial$allContKeys),length(RnoTrial$allContKeys),
                        length(Rtrial$allContKeys),length(RnoTrial$allContKeys)),
                      ncol= 4,nrow = 3, byrow =TRUE)
RstairTable <- as.table(RstairTable)
rownames(RstairTable) <- c("sum","proportion","Total")
colnames(RstairTable) <- c("Hit","Correct Reject","False Negative", "False Positive")
grid.table(RstairTable)
RstairTable

#plot data
gg<- ggplot(data=leftEye, aes(x=time,y=allDepths)) + 
  geom_point(size=0.25) + geom_line() + ylim(0,1)
gg<- gg+ labs(x = "time (s)",y = "contrast change", title = 
                "Left Eye Performance")
gg

gg1<- ggplot(data=rightEye, aes(x=time,y=allDepths)) + 
  geom_point(size=0.25) + geom_line() + ylim(0,1)
gg1<- gg1+ labs(x = "time (s)",y = "contrast change", title = 
                  "Right Eye Performance (blurry eye)")
ggsave("adaptation_KTN_day1_real.pdf", arrangeGrob(gg, gg1))

#explore binocular rivalry
allRivtimes <- -(adaptation$allRivtimes[1]-adaptation$allRivtimes)
allrivkeys <- adaptation$allrivkeys
alltrueDirection <-adaptation$alltrueDirection 
deprivedEye<-as.vector(matrix(adaptation$exp$depeye,nrow=length(alltrueDirection)))
postbinocular<- data.frame(allRivtimes,allrivkeys,alltrueDirection,deprivedEye)
leftDir<-subset(postbinocular, allrivkeys==1)
rightDir <-subset(postbinocular, allrivkeys==2)
mix <- subset(postbinocular, allrivkeys==3)
#find out percent of seeing normal eye
leftDirxTrueL<- subset(leftDir,alltrueDirection==1)
rightDirxTrueR<- subset(rightDir,alltrueDirection==2)
nonBlurryEye<- rbind(leftDirxTrueL,rightDirxTrueR)
perNonBlurry<-length(nonBlurryEye$allrivkeys)/length(postbinocular$allrivkeys)
perNonBlurry
#find out percent of seeing blurry eye
leftDirxTrueR<- subset(leftDir,alltrueDirection==2)
rightDirxTrueL<- subset(rightDir,alltrueDirection==1)
blurryEye<- rbind(leftDirxTrueR,rightDirxTrueL)
perBlurry<-length(blurryEye$allrivkeys)/length(postbinocular$allrivkeys)
perBlurry

#find out percent of seeing a mix
perMix<-length(mix$allrivkeys)/length(postbinocular$allrivkeys)
perMix

#plot stuff
blurryEye$whichEye<- as.vector(matrix('blurryEye',
                                      nrow=length(blurryEye$allrivkeys)))
blurryEye$whichEyeNum<- as.vector(matrix(1,
                                      nrow=length(blurryEye$allrivkeys)))
nonBlurryEye$whichEye<- as.vector(matrix('nonBlurryEye',
                                      nrow=length(nonBlurryEye$allrivkeys)))
nonBlurryEye$whichEyeNum<- as.vector(matrix(2,
                                         nrow=length(nonBlurryEye$allrivkeys)))
mix$whichEye<- as.vector(matrix('mix',
                                nrow=length(mix$allrivkeys)))

postbinocular2 <- rbind(blurryEye,nonBlurryEye)
postbinocular3 <- rbind(blurryEye,nonBlurryEye,mix)
gg2<- ggplot(postbinocular,aes(x=allRivtimes,y=allrivkeys))+geom_line() + 
  geom_point(size=0.25)
gg2

gg3<- ggplot(postbinocular3,aes(x=allRivtimes,y=allrivkeys,color = whichEye)) +
  geom_line(aes(y=allrivkeys)) + 
  geom_point(size=0.25)
gg3

gg4<-ggplot(postbinocular2,aes(x=allRivtimes,y=whichEyeNum)) +
  #geom_line() + 
  geom_point(aes(size=0.25,color=whichEyeNum)) +
  #facet_wrap(~whichEye, ncol=1) + 
  labs(x = "time (s)",y = "direction of truck (1=blurry,2=nonblurry)", title = 
         "Post Adaptation Performance")
gg4



 
  