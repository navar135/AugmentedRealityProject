##This code processes monocular suppression results to output dat
##results in terms of the staircase contrast change and the binocular rivalry
##results in terms of eye shift percentage
##by: Karen T. Navarro
##11/14/19

#set environment
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

#load data
setwd("/Users/navar135/Documents/UMN_Research/Projects/Diplopia/Pilot_Data")

##convert each file to a .txt file so we can combine all datasets into one dataFrame
#read in each file

## files with missing info
#dat<-read.mat("matFiles/AdaptationDiplopiaDat_KTN_day1_12-Nov-2019_17-52-48.mat")
#dat2<-read.mat("matFiles/AdaptationDiplopiaDat_44_day1_18-Nov-2019_17-09-52.mat")

files <-
  c(
    "matFiles/AdaptationDiplopiaDat_KTN_day2_13-Nov-2019_15-10-58.mat",
    "matFiles/AdaptationDiplopiaDat_KTN_day3_14-Nov-2019_16-49-55.mat",
    "matFiles/AdaptationDiplopiaDat_KTN_day4_15-Nov-2019_14-02-16.mat",
    "matFiles/AdaptationDiplopiaDat_KTN_day5_16-Nov-2019_15-05-00.mat",
    #"matFiles/AdaptationDiplopiaDat_44_day1_notpre_18-Nov-2019_19-25-46.mat",
    "matFiles/AdaptationDiplopiaDat_44_day2_19-Nov-2019_17-08-34.mat",
    "matFiles/AdaptationDiplopiaDat_44_day3_20-Nov-2019_13-30-07.mat",
    "matFiles/AdaptationDiplopiaDat_sub44_day4_21-Nov-2019_17-26-19.mat",
    "matFiles/AdaptationDiplopiaDat_sub92_day1_20-Nov-2019_16-30-32.mat",
    "matFiles/AdaptationDiplopiaDat_sub92_day2_21-Nov-2019_14-54-40.mat",
    "matFiles/AdaptationDiplopiaDat_sub92_day3_22-Nov-2019_13-30-22.mat",
    "matFiles/AdaptationDiplopiaDat_sub92_day4_23-Nov-2019_10-23-35.mat",
    "matFiles/AdaptationDiplopiaDat_sub19_day1_depEye1_23-Nov-2019_17-16-44.mat",
    "matFiles/AdaptationDiplopiaDat_sub44_day6_depEye1_23-Nov-2019_19-42-10.mat",
    "matFiles/AdaptationDiplopiaDat_sub92_day5_24-Nov-2019_10-36-08.mat",
    "matFiles/AdaptationDiplopiaDat_sub19_day2_depEye1_24-Nov-2019_12-59-59.mat",
    "matFiles/AdaptationDiplopiaDat_sub19_day3_depEye1_25-Nov-2019_16-24-34.mat",
    #"matFiles/AdaptationDiplopiaDat_sub19_day4_depEye1_26-Nov-2019_16-16-00.mat",
    "matFiles/AdaptationDiplopiaDat_sub19_day5_depEye1_27-Nov-2019_14-55-53.mat"
  )
files <- as.character(files)
subjects <- c(
  "KTN_day2",
  "KTN_day3",
  "KTN_day4",
  "KTN_day5",
  #"sub44_day1",
  "sub44_day2",
  "sub44_day3",
  "sub44_day4",
  "sub92_day1",
  "sub92_day2",
  "sub92_day3",
  "sub92_day4",
  "sub19_day1",
  "sub44_day6",
  "sub92_day5",
  "sub19_day2",
  "sub19_day3",
  #"sub19_day4",
  "sub19_day5"
)
for (k in 1:length(files)) {
  #  for (k in 1:length(subjects)) {
  dat <- read.mat(files[k])
  ##pull out each variable of .mat and convert to dataframe
  #process time
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
  #binocular rivalry process all possible varibales
  # allRivtimes <- -(dat$allRivtimes[1]-dat$allRivtimes) #first dataset w/ no pre/post
  # allrivkeys <- dat$allrivkeys
  # alltrueDirection <-dat$alltrueDirection
  # deprivedEye<-as.numeric(matrix(dat$exp$depeye,nrow=length(alltrueDirection)))
  
  allRivtimesPre <- -(dat$allRivtimesPre[1] - dat$allRivtimesPre)
  allrivkeysPre <- dat$allrivkeysPre
  alltrueDirectionPre <- dat$alltrueDirectionPre
  deprivedEyePre <-
    as.numeric(matrix(dat$exp$depeye, nrow = length(alltrueDirectionPre)))
  
  allRivtimesPost <-
    -(dat$allRivtimesPost[1] - dat$allRivtimesPost)
  allrivkeysPost <- dat$allrivkeysPost
  alltrueDirectionPost <- dat$alltrueDirectionPost
  deprivedEyePost <-
    as.numeric(matrix(dat$exp$depeye, nrow = length(alltrueDirectionPost)))
  ##combine all variables into 3 dataframes pre, adapt, post
  subject <-
    as.vector(matrix(subjects[k], nrow = length(allRandEyes)))
  subjectPre <-
    as.vector(matrix(subjects[k], nrow = length(alltrueDirectionPre)))
  subjectPost <-
    as.vector(matrix(subjects[k], nrow = length(alltrueDirectionPost)))
  
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
  adapt <- subset(adapt, allRandEyes == 2 | allRandEyes == 1)
  #calculate hit and false alarm rate at every response for each eye
  counterHit <- 0
  occurrenceHit <- replicate(length(adapt$allDepths), 0)
  for (i in 1:length(adapt$time)) {
    if (adapt$allNoiseorsignal[i] == 1 & allTrialResp[i] == 1) {
      occurrenceHit[i] = counterHit + 1
    } else {
      occurrenceHit[i] = counterHit
    }
  }
  adapt$Hit <- occurrenceHit
  # also called false alarm
  counterFalsePos <- 0
  occurrenceFalsePos <- replicate(length(adapt$allDepths), 0)
  for (i in 1:length(adapt$time)) {
    if (adapt$allNoiseorsignal[i] == 0 & allTrialResp[i] == 1) {
      occurrenceFalsePos[i] = counterFalsePos + 1
    } else {
      occurrenceFalsePos[i] = counterFalsePos
    }
  }
  adapt$FalsePos <- occurrenceFalsePos
  #also called missed
  counterFalseNeg <- 0
  occurrenceFalseNeg <- replicate(length(adapt$allDepths), 0)
  for (i in 1:length(adapt$time)) {
    if (adapt$allNoiseorsignal[i] == 1 & (allTrialResp[i] == 0)) {
      occurrenceFalseNeg[i] = counterFalseNeg + 1
    } else {
      occurrenceFalseNeg[i] = counterFalseNeg
    }
  }
  adapt$FalseNeg <- occurrenceFalseNeg
  
  counterCorrRej <- 0
  occurrenceCorrRej <- replicate(length(adapt$allDepths), 0)
  for (i in 1:length(adapt$time)) {
    if (adapt$allNoiseorsignal[i] == 0 & allTrialResp[i] == 0) {
      occurrenceCorrRej[i] = counterCorrRej + 1
    } else {
      occurrenceCorrRej[i] = counterCorrRej
    }
  }
  adapt$CorrRej <- occurrenceCorrRej
  
  #get porportion of hit and false neg for every minute for each eye
  nonBlurryEye <- subset(adapt, allRandEyes != deprivedEye)
  blurryEye <- subset(adapt, allRandEyes == deprivedEye)
  #nonBlurry eye
  allAdapt <- c(seq(0, 720, by = 180))
  hitTrack = replicate(length(allAdapt) - 1, 0)
  pct_Hit = replicate(length(allAdapt) - 1, 0)
  falseNegTrack = replicate(length(allAdapt) - 1, 0)
  pct_falseNeg = replicate(length(allAdapt) - 1, 0)
  falsePosTrack = replicate(length(allAdapt) - 1, 0)
  pct_falsePos = replicate(length(allAdapt) - 1, 0)
  corrRejTrack = replicate(length(allAdapt) - 1, 0)
  pct_corrRej = replicate(length(allAdapt) - 1, 0)
  
  for (j in 1:(length(nonBlurryEye$index))) {
    for (i in 1:length(allAdapt))
    {
      if (nonBlurryEye$index[j] >= allAdapt[i] &
          nonBlurryEye$index[j] < allAdapt[i + 1])
      {
        hitTrack[i] <- hitTrack[i] + nonBlurryEye$Hit[j]
        falseNegTrack[i] <-
          falseNegTrack[i] + nonBlurryEye$FalseNeg[j]
        falsePosTrack[i] <-
          falsePosTrack[i] + nonBlurryEye$FalsePos[j]
        corrRejTrack[i] <-
          corrRejTrack[i] + nonBlurryEye$CorrRej[j]
      }
    }
  }
  total <- hitTrack + falseNegTrack + falsePosTrack + corrRejTrack
  pct_Hit <- hitTrack / total
  pct_falseNeg <- falseNegTrack / total
  pct_falsePos <- falsePosTrack / total
  pct_corrRej <- corrRejTrack / total
  
  
  trials <- c(seq(180, 720, by = 180))
  subject <-
    as.vector(matrix(subjects[k], nrow = length(trials)))
  trialEye <-
    as.vector(matrix('nonBlurryEye', nrow = length(trials)))
  nbRate <-
    data.frame(
      subject,
      trials,
      trialEye,
      hitTrack,
      pct_Hit,
      falseNegTrack,
      pct_falseNeg,
      falsePosTrack,
      pct_falsePos,
      corrRejTrack,
      pct_corrRej
    )
  nbRate <- na.omit(nbRate)
  #Blurry eye
  allAdapt <- c(seq(0, 720, by = 180))
  hitTrack = replicate(length(allAdapt) - 1, 0)
  pct_Hit = replicate(length(allAdapt) - 1, 0)
  falseNegTrack = replicate(length(allAdapt) - 1, 0)
  pct_falseNeg = replicate(length(allAdapt) - 1, 0)
  falsePosTrack = replicate(length(allAdapt) - 1, 0)
  pct_falsePos = replicate(length(allAdapt) - 1, 0)
  corrRejTrack = replicate(length(allAdapt) - 1, 0)
  pct_corrRej = replicate(length(allAdapt) - 1, 0)
  
  for (j in 1:(length(blurryEye$time))) {
    for (i in 1:length(allAdapt))
    {
      if (blurryEye$index[j] >= allAdapt[i] &
          blurryEye$index[j] < allAdapt[i + 1])
      {
        hitTrack[i] <- hitTrack[i] + blurryEye$Hit[j]
        falseNegTrack[i] <-
          falseNegTrack[i] + blurryEye$FalseNeg[j]
        falsePosTrack[i] <-
          falsePosTrack[i] + blurryEye$FalsePos[j]
        corrRejTrack[i] <- corrRejTrack[i] + blurryEye$CorrRej[j]
      }
    }
  }
  totalTrial <- hitTrack + falseNegTrack 
  totalNoise<- falsePosTrack + corrRejTrack
  pct_Hit <- hitTrack / (totalTrial)
  pct_falseNeg <- falseNegTrack / totalTrial
  pct_falsePos <- falsePosTrack / totalNoise
  pct_corrRej <- corrRejTrack / totalNoise
  
  pct_HitTotal <- sum(hitTrack) / sum(totalTrial)
  pct_falseNegTotal <- sum(falseNegTrack) / sum(totalTrial)
  pct_falsePosTotal <- sum(falsePosTrack) / sum(totalNoise)
  pct_corrRejTotal <- sum(corrRejTrack) / sum(totalNoise)
  
  trials <- c(seq(180, 720, by = 180))
  subject <- as.vector(matrix(subjects[k], nrow = length(trials)))
  trialEye <-
    as.vector(matrix('blurryEye', nrow = length(trials)))
  bRate <-
    data.frame(
      subject,
      trials,
      trialEye,
      hitTrack,
      pct_Hit,
      falseNegTrack,
      pct_falseNeg,
      falsePosTrack,
      pct_falsePos,
      corrRejTrack,
      pct_corrRej
    )
  bRate <- na.omit(bRate)
  rates <- rbind(nbRate, bRate)
  ##pre/post data
  preAdapt <-
    data.frame(subjectPre,
               allRivtimesPre,
               allrivkeysPre,
               alltrueDirectionPre,
               deprivedEyePre)
  preAdapt <- subset(preAdapt, allRivtimesPre <= 600)
  preAdapt$phase <-
    as.vector(matrix('preAdapt', nrow = length(preAdapt$allRivtimesPre)))
  colnames(preAdapt) <-
    c(
      "subject",
      "allRivtimes",
      "allrivkeys",
      "alltrueDirection",
      "deprivedEye",
      "phase"
    )
  
  postAdapt <-
    data.frame(
      subjectPost,
      allRivtimesPost,
      allrivkeysPost,
      alltrueDirectionPost,
      deprivedEyePost
    )
  postAdapt$phase <-
    as.vector(matrix('postAdapt', nrow = length(postAdapt$allRivtimesPost)))
  colnames(postAdapt) <-
    c(
      "subject",
      "allRivtimes",
      "allrivkeys",
      "alltrueDirection",
      "deprivedEye",
      "phase"
    )
  preXpostAdapt <- rbind(preAdapt, postAdapt)
  #preXpostAdapt<-postAdapt
  
  ## decode nonBlurry and blurry eye
  #explore binocular rivalry
  leftDir <- subset(preXpostAdapt, allrivkeys == 1)
  rightDir <- subset(preXpostAdapt, allrivkeys == 2)
  #decode when seeing mixture
  mixDir <- subset(preXpostAdapt, allrivkeys == 3)
  mixDir$rivDir <-
    as.factor(as.vector(matrix("mix", nrow = length(mixDir$subject))))
  
  #decode when seeing normal eye
  leftDirxTrueL <- subset(leftDir, alltrueDirection == 1)
  rightDirxTrueR <- subset(rightDir, alltrueDirection == 2)
  nonBlurryEyeRiv <- rbind(leftDirxTrueL, rightDirxTrueR)
  #nonBlurry
  nonBlurryEyeRiv$rivDir <- as.factor(as.vector(matrix(
    "nonBlurryEye", nrow = length(nonBlurryEyeRiv$subject)
  )))
  
  #decode when seeing blurry eye
  leftDirxTrueR <- subset(leftDir, alltrueDirection == 2)
  rightDirxTrueL <- subset(rightDir, alltrueDirection == 1)
  blurryEyeRiv <- rbind(leftDirxTrueR, rightDirxTrueL)
  
  #blurryEye
  blurryEyeRiv$rivDir <-
    as.vector(matrix("blurryEye", nrow = length(blurryEyeRiv$subject)))
  blurryEyeRiv$rivDir <- as.factor(blurryEyeRiv$rivDir)
  
  preXpostAdapt <- rbind(nonBlurryEyeRiv, blurryEyeRiv, mixDir)
  preXpostAdapt$subject <- as.factor(preXpostAdapt$subject)
  preXpostAdapt$phase <- as.factor(preXpostAdapt$phase)
  
  preAdapt <- subset(preXpostAdapt, phase == "preAdapt")
  preAdapt <- preAdapt[order(preAdapt$allRivtimes), ]
  postAdapt <- subset(preXpostAdapt, phase == "postAdapt")
  postAdapt <- postAdapt[order(postAdapt$allRivtimes), ]
  
  
  #calculate time spent seeing each eye after each button press
  occurrencePre <- replicate(length(preAdapt$rivDir), 0)
  for (i in 1:length(preAdapt$allRivtimes)) {
    occurrencePre[i] = preAdapt$allRivtimes[i + 1] - preAdapt$allRivtimes[i]
    if (i == length(preAdapt$allRivtimes)) {
      occurrencePre[i] = round(preAdapt$allRivtimes[i], digits = -2) - preAdapt$allRivtimes[i]
    }
  }
  preAdapt$durationOnEye <- occurrencePre
  
  #get porportion of time spent on each eye every minute
  all <-
    c(seq(0, round(
      tail(preAdapt$allRivtimes, n = 1), digits = -2
    ), by = 60))
  beTrack = replicate(length(all) - 1, 0)
  pct_be = replicate(length(all) - 1, 0)
  nbeTrack = replicate(length(all) - 1, 0)
  pct_nbe = replicate(length(all) - 1, 0)
  mixTrack = replicate(length(all) - 1, 0)
  pct_mix = replicate(length(all) - 1, 0)
  for (j in 1:(length(preAdapt$allRivtimes))) {
    for (i in 1:length(all))
    {
      if (preAdapt$allRivtimes[j] >= all[i] &
          preAdapt$allRivtimes[j] < all[i + 1])
      {
        if (preAdapt$rivDir[j] == "blurryEye")
        {
          beTrack[i] <- beTrack[i] + preAdapt$durationOnEye[j]
          pct_be[i] <- beTrack[i] / 60
        }
        else if (preAdapt$rivDir[j] == "nonBlurryEye")
        {
          nbeTrack[i] <- nbeTrack[i] + preAdapt$durationOnEye[j]
          pct_nbe[i] <- nbeTrack[i] / 60
        }
        else if (preAdapt$rivDir[j] == "mix")
        {
          mixTrack[i] <- mixTrack[i] + preAdapt$durationOnEye[j]
          pct_mix[i] <- mixTrack[i] / 60
        }
      }
    }
  }
  timePoints <-
    c(seq(60, round(
      tail(preAdapt$allRivtimes, n = 1), digits = -2
    ), by = 60))
  subject <-
    as.vector(matrix(subjects[k], nrow = length(timePoints)))
  phase <-
    as.vector(matrix('preAdapt', nrow = length(timePoints)))
  pctEyePre <-
    data.frame(subject, phase, timePoints, pct_be, pct_nbe, pct_mix)
  
  
  #repeat for postAdaptation data
  occurrencePost <- replicate(length(postAdapt$rivDir), 0)
  for (i in 1:length(postAdapt$allRivtimes)) {
    occurrencePost[i] = postAdapt$allRivtimes[i + 1] - postAdapt$allRivtimes[i]
    if (i == length(postAdapt$allRivtimes)) {
      occurrencePost[i] = round(postAdapt$allRivtimes[i], digits = -2) - postAdapt$allRivtimes[i]
    }
  }
  postAdapt$durationOnEye <- occurrencePost
  
  #get porportion of time spent on each eye every minute
  all <-
    c(seq(0, round(
      tail(postAdapt$allRivtimes, n = 1), digits = -2
    ), by = 60))
  beTrackPost = replicate(length(all) - 1, 0)
  pct_bePost = replicate(length(all) - 1, 0)
  nbeTrackPost = replicate(length(all) - 1, 0)
  pct_nbePost = replicate(length(all) - 1, 0)
  mixTrackPost = replicate(length(all) - 1, 0)
  pct_mixPost = replicate(length(all) - 1, 0)
  postAdapt <- subset(postAdapt, allRivtimes < 600)
  for (j in 1:(length(postAdapt$allRivtimes))) {
    for (i in 1:length(all))
    {
      if (postAdapt$allRivtimes[j] >= all[i] &
          postAdapt$allRivtimes[j] < all[i + 1])
      {
        if (postAdapt$rivDir[j] == "blurryEye")
        {
          beTrackPost[i] <- beTrackPost[i] + postAdapt$durationOnEye[j]
          pct_bePost[i] <- beTrackPost[i] / 60
        }
        else if (postAdapt$rivDir[j] == "nonBlurryEye")
        {
          nbeTrackPost[i] <- nbeTrackPost[i] + postAdapt$durationOnEye[j]
          pct_nbePost[i] <- nbeTrackPost[i] / 60
        }
        else if (postAdapt$rivDir[j] == "mix")
        {
          mixTrackPost[i] <- mixTrackPost[i] + postAdapt$durationOnEye[j]
          pct_mixPost[i] <- mixTrackPost[i] / 60
        }
      }
    }
  }
  timePoints <-
    c(seq(60, round(
      tail(postAdapt$allRivtimes, n = 1), digits = -2
    ), by = 60))
  subject <-
    as.vector(matrix(subjects[k], nrow = length(timePoints)))
  phase <-
    as.vector(matrix('postAdapt', nrow = length(timePoints)))
  pctEyePost <-
    data.frame(subject,
               phase,
               timePoints,
               pct_bePost,
               pct_nbePost,
               pct_mixPost)
  colnames(pctEyePost) <-
    c("subject",
      "phase",
      "timePoints",
      "pct_be",
      "pct_nbe",
      "pct_mix")
  preXpostTimePoints <- rbind(pctEyePre, pctEyePost)
  #preXpostTimePoints <- pctEyePost
  
  preXpostAdapt <- rbind(preAdapt, postAdapt)
  #preXpostAdapt<-postAdapt
  
  ######check eye dominance quick
  x <- count(preAdapt$rivDir)
  pct <- (x$freq) / sum(x$freq) * 100
  
  x1 <- count(postAdapt$rivDir)
  pct1 <- (x1$freq) / sum(x1$freq) * 100
  
  #only for the file with no preadapt data (comment otherwise)
  #postAdaptNoPre<-data.frame(allRivtimes,allrivkeys,alltrueDirection,deprivedEye)
  
  ## save out files as .csv file
  write.csv(preXpostAdapt, paste0('prepostCSV/preXpostAdapt_', subjects[k], '.csv'))
  write.csv(preXpostTimePoints,
            paste0('prepostCSV/preXpostTimePoints_', subjects[k], '.csv'))
  write.csv(rates, paste0('adaptationCSV/performanceRates_', subjects[k], '.csv'))
  write.csv(adapt, paste0('adaptationCSV/adapt_', subjects[k], '.csv'))
}
#####Start data analysis ####
#read in all .csv files and combine into one 
setwd("/Users/navar135/Documents/UMN_Research/Projects/Diplopia/Pilot_Data/adaptationCSV/")
temp <- list.files(pattern="*adapt_")
#temp<-temp[temp != "adapt_KTN_day1.csv"]
#temp<-temp[temp != "adapt_sub44_day1.csv"]
adaptResults <-ldply(temp, read_csv)
adaptResults$X1 <- NULL
adaptResults$`%PDF-1.4`<-NULL

blurryEye<-subset(adaptResults, allRandEyes == deprivedEye) 
                 #& allNoiseorsignal ==1)
nonBlurryEye<-subset(adaptResults, allRandEyes != deprivedEye)
                    #& allNoiseorsignal ==1)
#plot contrast change in each eye
gg<- ggplot(data=nonBlurryEye, aes(x=time,y=allDepths)) +
  geom_point(aes(color=subject)) + geom_line(aes(color=subject)) + ylim(0,1)
gg<- gg+ labs(x = "time (s)",y = "contrast change", title =
                  "Non-Blurry Eye Performance")
gg<- gg+ facet_wrap(~subject)

gg1<- ggplot(data=blurryEye, aes(x=time,y=allDepths)) +
  geom_point(aes(color=subject)) + geom_line(aes(color=subject)) + ylim(0,1)
gg1<- gg1+ labs(x = "time (s)",y = "contrast change", title =
                  "Blurry Eye Performance")
gg1<- gg1+ facet_wrap(~subject)
grid.arrange(gg, gg1, nrow=2)



#####      #####
## plot linear regression 
# find average of contrast in each eye per day 
# plot each point on a line 
bEMean<- blurryEye %>%
  dplyr::group_by(subject) %>%
  dplyr::summarise(avg=mean(allDepths))

labels<-c(rep("KTN",5),rep("sub19",5),rep("sub44",5),rep("sub92",5))
days<- c(rep((1:5),4))

bEMean<- cbind.data.frame(bEMean,labels,days)

nbEMean<- nonBlurryEye %>%
  dplyr::group_by(subject) %>%
  dplyr::summarise(avg=mean(allDepths))
nbEMean<- cbind.data.frame(nbEMean,labels,days)

nbEMean$difference<- abs(nbEMean$avg-bEMean$avg)
bEMean$difference<- abs(nbEMean$avg-bEMean$avg)

gg11<- ggplot(data=bEMean, aes(x= days,y=avg)) + 
  geom_point(aes(color = labels)) + geom_line(aes(color=labels)) + ylim(0,0.5) 
gg11<- gg11+ labs(x = "days",y = "average contrast change", title =
                    "Blurry Eye Performance Per Day")
gg11<-gg11+facet_wrap(~labels)

gg12<- ggplot(data=nbEMean, aes(x= days,y=avg)) + 
  geom_point(aes(color = labels)) + geom_line(aes(color = labels)) + ylim(0.2,0.7)
gg12<- gg12+ labs(x = "days",y = "average contrast change", title =
                    "Non-Blurry Eye Performance Per Day")
gg12<-gg12+facet_wrap(~labels)
grid.arrange(gg12, gg11, nrow=2)

gg13<- ggplot() + 
  geom_point(data=bEMean, aes(x= days,y=avg,color = "bEMean")) + 
  geom_line(data=bEMean, aes(x= days,y=avg,color="bEMean")) 
gg13<- gg13 + geom_point(data=nbEMean, aes(x= days,y=difference,color = "difference")) + 
  geom_line(data=nbEMean, aes(x= days,y=difference,color="difference")) + 
  geom_point(data=nbEMean, aes(x= days,y=avg,color = "nbEMean")) + 
  geom_line(data=nbEMean, aes(x= days,y=avg,color="nbEMean")) 
gg13<- gg13+ labs(x = "days",y = "average contrast change", title =
                    "Adaptation Performance Per Day")
gg13<-gg13+facet_wrap(~labels)

#### compute linear regression  #####
nBE1<- subset(nbEMean,labels == "sub19")
bE1<- subset(bEMean,labels == "sub19")
lmNBE1 <- lm(avg ~ days, data=nBE1)
(lmNBE1_Summary <- summary(lmNBE1)) # capture model summary as an object
lmbE1<- lm(avg ~ days, data=bE1)
(lmbE1_Summary <- summary(lmbE1))
lmDiff1<- lm(difference ~ days, data=nBE1)
(lmDiff1_Summary <- summary(lmDiff1))

nBE2<- subset(nbEMean,labels == "sub44")
bE2<- subset(bEMean,labels == "sub44")
lmNBE2 <- lm(avg ~ days, data=nBE2)
(lmNBE2_Summary <- summary(lmNBE2)) # capture model summary as an object
lmbE2<- lm(avg ~ days, data=bE2)
(lmbE2_Summary <- summary(lmbE2))
lmDiff2<- lm(difference ~ days, data=nBE2)
(lmDiff2_Summary <- summary(lmDiff2))

nBE3<- subset(nbEMean,labels == "sub92")
bE3<- subset(bEMean,labels == "sub92")
lmNBE3 <- lm(avg ~ days, data=nBE3)
(lmNBE3_Summary <- summary(lmNBE3)) # capture model summary as an object
lmbE3<- lm(avg ~ days, data=bE3)
(lmbE3_Summary <- summary(lmbE3))
lmDiff3<- lm(difference ~ days, data=nBE3)
(lmDiff3_Summary <- summary(lmDiff3))

nBE4<- subset(nbEMean,labels == "KTN")
bE4<- subset(bEMean,labels == "KTN")
lmNBE4 <- lm(avg ~ days, data=nBE4)
(lmNBE4_Summary <- summary(lmNBE4)) # capture model summary as an object
lmbE4<- lm(avg ~ days, data=bE4)
(lmbE4_Summary <- summary(lmbE4))
lmDiff4<- lm(difference ~ days, data=nBE4)
(lmDiff4_Summary <- summary(lmDiff4))

#create a bootstrap test to see trend 
n<-100 #number of trials
Bootsize <- 200 # number of times each dataset is resampled
BootstrapMean <-numeric(length = Bootsize) #empty vector
set.seed(201407) #set a randomization
#count how many trials in each eye for each dataset
cntBE<- blurryEye %>%
  group_by(subject) %>%
  dplyr::summarise(n=n())
cntNBE<- nonBlurryEye %>%
  group_by(subject) %>%
  dplyr::summarise(n=n())

#create a number of empty vectors for the bootstrap
subSubset <-numeric(length = length(cntNBE$subject))
perDayBE<-numeric(length = length(cntNBE$subject))
perDayNBE<-numeric(length = length(cntNBE$subject))
#empty dataframes with the same length as the # of resampling
beBoot <- data.frame(V1=rep(0, Bootsize))
nbeBoot <- data.frame(V1=rep(0, Bootsize))
#labels current data for each subject for the 5 days
labelsTotBe<-c(rep("KTN",sum(cntBE$n[1:5])),rep("sub19",sum(cntBE$n[6:10])),
             rep("sub44",sum(cntBE$n[11:15])),rep("sub92",sum(cntBE$n[16:20])))
labelsTotNBe<-c(rep("KTN",sum(cntNBE$n[1:5])),rep("sub19",sum(cntNBE$n[6:10])),
               rep("sub44",sum(cntNBE$n[11:15])),rep("sub92",sum(cntNBE$n[16:20])))
blurryEye<- cbind.data.frame(blurryEye,labelsTotBe)
nonBlurryEye<- cbind.data.frame(nonBlurryEye,labelsTotNBe)


#this loop resamples the mean data of each day and outputs it into a dataframe where each column is the mean 
#of each resample. This is repeated for each eye
for (ii in 1:length(cntBE$subject)) {
  for(i in 1:Bootsize){ 
    subSubset = subset(blurryEye,subject == cntBE$subject[ii]) #subsets data for one dataset
    BootstrapMean[i] <-mean(sample(subSubset$allDepths, size = n, replace = TRUE))
  }
  perDayBE[ii]<-mean(BootstrapMean) #records mean of total resample
  beBoot[,ii] <- BootstrapMean #records each resampling mean in a column
  names(beBoot)[names(beBoot) == paste0('V',ii)] <- cntBE$subject[ii] #assigns name to appropriate column
}
#non-blurry eye
subSubset <-numeric(length = length(cntNBE$subject))
for (ii in 1:length(cntNBE$subject)) {
  for(i in 1:Bootsize){ 
    subSubset = subset(nonBlurryEye,subject == cntNBE$subject[ii])
    BootstrapMean[i] <-mean(sample(subSubset$allDepths, size = n, replace = TRUE))
  }
  perDayNBE[ii]<-mean(BootstrapMean)#records mean of total resample
  nbeBoot[,ii] <- BootstrapMean #records each resampling mean in a column
  names(nbeBoot)[names(nbeBoot) == paste0('V',ii)] <- cntNBE$subject[ii] #assigns name to appropriate column
}
#transpose dataframes for further analyzes and label them properly
beBootTrans<-t(beBoot)
nbeBootTrans<-t(nbeBoot)
difference<- abs(nbeBootTrans-beBootTrans)
beBoot<- data.frame(labels,days,subject= row.names(beBootTrans), beBootTrans,row.names=NULL)
nbeBoot<-data.frame(labels, days,subject= row.names(nbeBootTrans), nbeBootTrans,row.names=NULL)
difference<-data.frame(labels,days,subject= row.names(difference), difference, row.names=NULL)

df <- vector(length=Bootsize)
df1 <- vector(length=Bootsize)
df2 <- vector(length=Bootsize)
df3 <- vector(length=Bootsize)
subSubset <-numeric(length = 5)

for (slp in 1:Bootsize) { 
  KTN <- subset(difference, labels=="KTN")
  names(KTN)[names(KTN) == paste0('X',slp)] <- "y"
  df[slp]=lm(y ~ days,data=KTN)$coeff[[2]]
}  
for (slp in 1:Bootsize) { 
  sub19 <- subset(difference, labels=="sub19")
  names(sub19)[names(sub19) == paste0('X',slp)] <- "y"
  df1[slp]=lm(y ~ days,data=sub19)$coeff[[2]]
}  
for (slp in 1:Bootsize) { 
  sub44 <- subset(difference, labels=="sub44")
  names(sub44)[names(sub44) == paste0('X',slp)] <- "y"
  df2[slp]=lm(y ~ days,data=sub44)$coeff[[2]]
}  
for (slp in 1:Bootsize) { 
  sub92 <- subset(difference, labels=="sub92")
  names(sub92)[names(sub92) == paste0('X',slp)] <- "y"
  df3[slp]=lm(y ~ days,data=sub92)$coeff[[2]]
}  
name<-c("KTN","sub19","sub44","sub92")
diff<- rbind(df,df1,df2,df3)
diff<-data.frame(name,diff,row.names = NULL)

#plot disribution of slopes for each subject 
par(mfrow=c(2,2))
hist(df, breaks=10,
     main = "Slope distribution \n n=100 for KTN", xlab="slope")
abline(v=mean(df), col="blue")
hist(df2, breaks=10,
     main = "Slope distribution \n n=100 for sub44", xlab="slope")
abline(v=mean(df2), col="blue")
hist(df1, breaks=15,
     main = "Slope distribution \n n=100 for sub19", xlab="slope")
abline(v=mean(df1), col="blue")
hist(df3, breaks=15,
     main = "Slope distribution \n n=100 for sub92", xlab="slope")
abline(v=mean(df3), col="blue")
#plot resample performance
gg14<- ggplot() +
  geom_point(data=bootDat, aes(x= days,y=bEMean,color = "bEMean")) + 
  geom_line(data=bootDat, aes(x= days,y=bEMean,color="bEMean")) + 
  geom_point(data=bootDat, aes(x= days,y=nbEMean,color = "nbEMean")) + 
  geom_line(data=bootDat, aes(x= days,y=nbEMean,color="nbEMean")) +
  geom_point(data=bootDat, aes(x= days,y=difference,color = "difference")) + 
  geom_line(data=bootDat, aes(x= days,y=difference,color="difference")) 
gg14<-gg14+facet_wrap(~labels)
gg14<- gg14+ labs(x = "days",y = "average contrast change", title =
                    "Bootstrap Performance Per Day")
grid.arrange(gg13, gg14, nrow=2)
sub19<- subset(bootDat,labels == "sub19")
lmDiffboot1<- lm(difference ~ days, data=sub19)
(lmDiffboot1_Summary <- summary(lmDiffboot1))

sub44<- subset(bootDat,labels == "sub44")
lmDiffboot2<- lm(difference ~ days, data=sub44)
(lmDiffboot2_Summary <- summary(lmDiffboot2))

sub92<- subset(bootDat,labels == "sub92")
lmDiffboot3<- lm(difference ~ days, data=sub92)
(lmDiffboot3_Summary <- summary(lmDiffboot3))

KTN<- subset(bootDat,labels == "KTN")
lmDiffboot4<- lm(difference ~ days, data=KTN)
(lmDiffboot4_Summary <- summary(lmDiffboot4))




#### Process hit/miss rate ####
temp3<- list.files(pattern="*performanceRates")
temp3<-temp3[temp3!="sub19_day4"]
performanceRates <- ldply(temp3, read_csv)
performanceRates$X1 <- NULL




grouped<-performanceRates %>%
  dplyr::group_by(subject,trialEye) %>%
  dplyr::summarise(hit=sum(hitTrack),fA=sum(falsePosTrack),
                   miss=sum(falseNegTrack),corrRej=sum(corrRejTrack)) 

test2<-dprime(grouped$hit,grouped$fA,n_miss=grouped$miss,n_cr=grouped$corrRej)
grouped<- data.frame(grouped,test2$dprime)
grid.table(grouped)

groupedPct<-performanceRates %>%
  dplyr::group_by(subject,trialEye) %>%
  dplyr::summarise(hit=sum(hitTrack),fA=sum(falsePosTrack),
                   miss=sum(falseNegTrack),corrRej=sum(corrRejTrack),
                   total = sum(hit,fA,miss,corrRej),
                   pct_hit = hit/total,
                   pct_hit_Signal = hit/ sum(hit,miss)) 
grid.table(groupedPct)


blurryEye<- subset(performanceRates, trialEye == "blurryEye")
nonBlurryEye<- subset(performanceRates, trialEye == "nonBlurryEye")

#### Start processing rivalry data ####
#read in all .csv files and combine into one 
setwd("/Users/navar135/Documents/UMN_Research/Projects/Diplopia/Pilot_Data/prepostCSV")

temp1 <- list.files(pattern="*preXpostAdapt")
preXpostResults <- ldply(temp1, read_csv)
preXpostResults$X1 <- NULL
temp2<-list.files(pattern="*preXpostTimePoints")
preXpostTimePoints <- ldply(temp2, read_csv)
preXpostTimePoints$X1 <- NULL
 preXpostTimePoints<- subset(preXpostTimePoints,subject !="KTN_day1")

preAdapt<-subset(preXpostTimePoints,phase=="preAdapt")
postAdapt<- subset(preXpostTimePoints,phase=="postAdapt")

#plot rivalry percent  
gg2 <- ggplot() + 
  geom_line(data = preAdapt, 
            aes(x = timePoints, y = pct_be, color = "pct_be")) + 
  geom_point(data = preAdapt, 
             aes(x = timePoints, y = pct_be, color = "pct_be")) +
  geom_line(data = preAdapt, 
            aes(x = timePoints, y = pct_nbe, color = "pct_nbe")) + 
  geom_point(data = preAdapt, 
             aes(x = timePoints, y = pct_nbe, color = "pct_nbe")) + 
  geom_line(data = preAdapt, 
            aes(x = timePoints, y = pct_mix, color = "pct_mix")) + 
  geom_point(data = preAdapt, 
            aes(x = timePoints, y = pct_mix, color = "pct_mix"))  
#gg2<- gg2 + xlim(0,600) 
gg2<- gg2 + labs(x = "time (s)",y = "% time seeing each eye", title = 
                   "Pre Adaptation") 
gg2<- gg2+ facet_wrap(~subject)

gg3<-ggplot() + 
  geom_line(data = postAdapt, 
            aes(x = timePoints, y = pct_be, color = "pct_be")) + 
  geom_point(data = postAdapt, 
             aes(x = timePoints, y = pct_be, color = "pct_be")) +
  geom_line(data = postAdapt, 
            aes(x = timePoints, y = pct_nbe, color = "pct_nbe")) + 
  geom_point(data = postAdapt, 
             aes(x = timePoints, y = pct_nbe, color = "pct_nbe")) + 
  geom_line(data = postAdapt, 
            aes(x = timePoints, y = pct_mix, color = "pct_mix")) + 
  geom_point(data = postAdapt, 
             aes(x = timePoints, y = pct_mix, color = "pct_mix"))  
#gg3<- gg3 + xlim(0,600) 
gg3<- gg3 + labs(x = "time (s)",y = "% time seeing each eye", title = 
                   "Post Adaptation") 
gg3<- gg3+ facet_wrap(~subject)
grid.arrange(gg2, gg3, nrow=2)

##
test3<-preXpostTimePoints %>%
  dplyr::group_by(subject,phase) %>%
  dplyr::summarise(sum_be=sum(pct_be),sum_nbe=sum(pct_nbe),sum_mix=sum(pct_mix),
                   totpct_be = sum_be/(sum_be+sum_nbe+sum_mix),
                   totpct_nbe = sum_nbe/(sum_be+sum_nbe+sum_mix),
                   totpct_mix=sum_mix/(sum_be+sum_nbe+sum_mix))

test3$sum_be<-NULL
test3$sum_nbe<-NULL
test3$sum_mix<-NULL
test3<- melt(test3, id.vars = c("subject", "phase"),
             measure.vars = c("totpct_be", "totpct_nbe", "totpct_mix"))
gg10<-ggplot(data=test3,aes(x=variable,y=value,fill=phase)) + 
  geom_bar(stat="identity", position=position_dodge())+ 
  scale_fill_discrete(breaks=c("preAdapt","postAdapt"))
gg10<- gg10 + facet_wrap(~subject) 
gg10