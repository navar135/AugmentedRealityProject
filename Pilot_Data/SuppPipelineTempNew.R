## this script is processing the data of the monocular 
## suppression project and creating different csv files 
## for each datatype( pre/adapt/post)
## By: Karen T. Navarro
## Date: 02/28/2020
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
#clear out current environment
rm(list = ls(all.names = TRUE))

#set current directory
setwd("/Users/navar135/Documents/UMN_Research/Projects/Diplopia/Pilot_Data/")

files<- as.character(c("matFiles/AdaptationDiplopiaDat_Sub001_practice_day1_25-Feb-2020_12-27-18.mat", #could the file be corrupted?? crashing r
                       "matFiles/AdaptationDiplopiaDat_Sub001_practice_day2_blur_26-Feb-2020_12-20-01.mat",
                       "matFiles/AdaptationDiplopiaDat_Sub001_practice_day2_noBlur_26-Feb-2020_11-43-55.mat",
                       "matFiles/AdaptationDiplopiaDat_Sub001_day3_27-Feb-2020_16-18-16.mat",
                       "matFiles/AdaptationDiplopiaDat_Sub001_day4_28-Feb-2020_17-38-55.mat",
                       "matFiles/AdaptationDiplopiaDat_sub002_practice_noblur_day1_02-Mar-2020_12-03-43.mat",                       # "matFiles/AdaptationDiplopiaDat_sub002_practice_noblur_day2_03-Mar-2020_13-27-10.mat",
                       "matFiles/AdaptationDiplopiaDat_sub002_practice_noblur_day2_03-Mar-2020_13-27-10.mat",
                       "matFiles/AdaptationDiplopiaDat_sub002_practice_blur_day2_03-Mar-2020_14-02-52.mat",
                        "matFiles/AdaptationDiplopiaDat_sub002_day3_04-Mar-2020_18-40-11.mat",
                        "matFiles/AdaptationDiplopiaDat_sub002_day4_05-Mar-2020_14-04-32.mat",
                       "matFiles/AdaptationDiplopiaDat_sub002_day5_06-Mar-2020_13-52-52.mat",
                        "matFiles/AdaptationDiplopiaDat_sub003_practice_day1_03-Mar-2020_15-32-23.mat",
                        "matFiles/AdaptationDiplopiaDat_sub003_practice_day2_noblur_04-Mar-2020_12-44-39.mat",
                        "matFiles/AdaptationDiplopiaDat_sub003_day2_blur_04-Mar-2020_13-21-05.mat",
                        "matFiles/AdaptationDiplopiaDat_sub003_day3_05-Mar-2020_16-24-35.mat",
                        "matFiles/AdaptationDiplopiaDat_sub003_day4_06-Mar-2020_16-45-20.mat",
                       "matFiles/AdaptationDiplopiaDat_sub006_day1_practice_06-Mar-2020_17-41-32.mat"
                       
                       ))
subjects<- c("Sub001_day1","Sub001_day2","Sub001_day2noBlur", "Sub001_day3","Sub001_day4",
             "Sub002_day1", "Sub002_day2noBlur", "Sub002_day2", "Sub002_day3","Sub002_day4","Sub002_day5",
             "Sub003_day1","Sub003_day2noBlur", "Sub003_day2","Sub003_day3","Sub003_day4",
             "Sub006_day1"
             )
days <- c("day1","day2","day2noBlur", "day3","day4",
          "day1","day2noBlur", "day2","day3","day4","day5",
          "day1","day2noBlur","day2","day3","day4",
          "day1")
#### processes detection task data ####
for (k in 2:length(files)) {
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
  rt<- rt - dat$stTime
  totTime <- (dat$endTime - dat$stTime)
  correct<- dat$trials$correct
  correct<- as.numeric(correct[1:length(depths)])
  butPress<- dat$trials$button
  butPress <- as.numeric(butPress[1:length(depths)])
  
  subject <-
    as.vector(matrix(subjects[k], nrow = length(depths)))
  day <-
    as.vector(matrix(days[k], nrow = length(depths)))
  deprivedEye <-
    as.numeric(matrix(dat$exp$depeye, nrow = length(depths)))
  index <-
    as.numeric(matrix(1:length(depths), nrow = length(depths))) 
 
  blurDat <-
    data.frame(
      index,
      subject,
      day,
      deprivedEye,
      depths,
      decEye,
      sndDelay,
      rt,
      butPress,
      correct
    )
  
  
  write.csv(blurDat, paste0('SupDat_', subjects[k], '.csv'))
  rm(list=setdiff(ls(), c("files","subjects","k","days")))
}

#### process truck task data ####
files<- as.character(c("matFiles/AdaptationDiplopiaDat_Sub001_practice_day1_25-Feb-2020_12-27-18.mat", #could the file be corrupted?? crashing r
                       "matFiles/AdaptationDiplopiaDat_Sub001_practice_day2_blur_26-Feb-2020_12-20-01.mat",
                       #"matFiles/AdaptationDiplopiaDat_Sub001_practice_day2_noBlur_26-Feb-2020_11-43-55.mat",
                       "matFiles/AdaptationDiplopiaDat_Sub001_day3_27-Feb-2020_16-18-16.mat",
                       "matFiles/AdaptationDiplopiaDat_Sub001_day4_28-Feb-2020_17-38-55.mat",
                      # "matFiles/AdaptationDiplopiaDat_sub002_practice_noblur_day1_02-Mar-2020_12-03-43.mat",                       # "matFiles/AdaptationDiplopiaDat_sub002_practice_noblur_day2_03-Mar-2020_13-27-10.mat",
                      # "matFiles/AdaptationDiplopiaDat_sub002_practice_noblur_day2_03-Mar-2020_13-27-10.mat",
                       "matFiles/AdaptationDiplopiaDat_sub002_practice_blur_day2_03-Mar-2020_14-02-52.mat",
                       "matFiles/AdaptationDiplopiaDat_sub002_day3_04-Mar-2020_18-40-11.mat",
                       "matFiles/AdaptationDiplopiaDat_sub002_day4_05-Mar-2020_14-04-32.mat",
                      "matFiles/AdaptationDiplopiaDat_sub002_day5_06-Mar-2020_13-52-52.mat",
                      
                       #"matFiles/AdaptationDiplopiaDat_sub003_practice_day1_03-Mar-2020_15-32-23.mat",
                      # "matFiles/AdaptationDiplopiaDat_sub003_practice_day2_noblur_04-Mar-2020_12-44-39.mat",
                       "matFiles/AdaptationDiplopiaDat_sub003_day2_blur_04-Mar-2020_13-21-05.mat",
                       "matFiles/AdaptationDiplopiaDat_sub003_day3_05-Mar-2020_16-24-35.mat",
                      "matFiles/AdaptationDiplopiaDat_sub003_day4_06-Mar-2020_16-45-20.mat",
                      
                      "matFiles/AdaptationDiplopiaDat_sub006_day1_practice_06-Mar-2020_17-41-32.mat"
                      
))
subjects<- c("Sub001_day1","Sub001_day2",
             #"Sub001_day2noBlur", 
             "Sub001_day3","Sub001_day4",
             #"Sub002_day1", 
             #"Sub002_day2noBlur", 
             "Sub002_day2", "Sub002_day3","Sub002_day4","Sub002_day5",
             #"Sub003_day1",
             #"Sub003_day2noBlur", 
             "Sub003_day2","Sub003_day3","Sub003_day4",
             "Sub006_day1"
)
days <- c("day1","day2",
          #"day2noBlur",
          "day3","day4",
          #"day1","day2noBlur",
          "day2","day3","day4","day5",
          #"day1","day2noBlur",
          "day2","day3","day4",
          "day1")

for (k in 2:length(files)) {
  #read in data and variables
  dat <- read.mat(files[k])
  if (length(dat$allRivtimesPre) !=0) {
    rtPre<- -(dat$allRivtimesPre[1] - dat$allRivtimesPre)
    butPressPre <- dat$allrivkeysPre
    truckDirPre <- dat$alltrueDirectionPre
    depEyePre <-
      as.numeric(matrix(dat$exp$depeye, nrow = length(truckDirPre)))
    subjectPre <-
      as.vector(matrix(subjects[k], nrow = length(truckDirPre)))
    daysPre<-
      as.vector(matrix(days[k], nrow = length(truckDirPre)))
    preAdapt <-
      data.frame(subjectPre,
                 daysPre,
                 rtPre,
                 butPressPre,
                 truckDirPre,
                 depEyePre)
    preAdapt <- subset(preAdapt, rtPre <= 600)
    preAdapt$phase <-
      as.vector(matrix('preAdapt', nrow = length(preAdapt$rtPre)))
    colnames(preAdapt) <-
      c(
        "subject",
        "day",
        "rt",
        "butPress",
        "truckDir",
        "depEye",
        "phase"
      )
  }
  if (length(dat$allRivtimesPost)!=0) {
    rtPost<- -(dat$allRivtimesPost[1] - dat$allRivtimesPost)
    butPressPost <- dat$allrivkeysPost
    truckDirPost <- dat$alltrueDirectionPost
    depEyePost <-
      as.numeric(matrix(dat$exp$depeye, nrow = length(truckDirPost)))
    subjectPost <-
      as.vector(matrix(subjects[k], nrow = length(truckDirPost)))
    daysPost<-
      as.vector(matrix(days[k], nrow = length(truckDirPost)))
    #combine postAdapt into a dataframe
    postAdapt <-
      data.frame(
        subjectPost,
        daysPost,
        rtPost,
        butPressPost,
        truckDirPost,
        depEyePost
      )
    postAdapt$phase <-
      as.vector(matrix('postAdapt', nrow = length(postAdapt$rtPost)))
    colnames(postAdapt) <-
      c(
        "subject",
        "day",
        "rt",
        "butPress",
        "truckDir",
        "depEye",
        "phase"
      )
  }
  if (exists("preAdapt")) {
    preXpostAdapt <- preAdapt
    if (exists("postAdapt")){
      preXpostAdapt <- rbind(preAdapt, postAdapt)
  }}


## decode nonBlurry and blurry eye
#explore binocular rivalry
leftDir <- subset(preXpostAdapt, butPress == 1)
rightDir <- subset(preXpostAdapt, butPress == 2)
#decode when seeing mixture
mixDir <- subset(preXpostAdapt, butPress == 3)
if (length(mixDir$butPress) != 0) {
  mixDir$rivDir <-
    as.factor(as.vector(matrix("mix", nrow = length(mixDir$subject))))  
}
#decode when seeing normal eye
leftDirxTrueL <- subset(leftDir, truckDir == 1)
rightDirxTrueR <- subset(rightDir, truckDir == 2)
nonBlurryEyeRiv <- rbind(leftDirxTrueL, rightDirxTrueR)
#nonBlurry
nonBlurryEyeRiv$rivDir <- as.factor(as.vector(
  matrix("nonBlurryEye", nrow = length(nonBlurryEyeRiv$subject))))

#decode when seeing blurry eye
leftDirxTrueR <- subset(leftDir, truckDir == 2)
rightDirxTrueL <- subset(rightDir, truckDir == 1)
blurryEyeRiv <- rbind(leftDirxTrueR, rightDirxTrueL)

#blurryEye
if (length(blurryEyeRiv$butPress) != 0){
blurryEyeRiv$rivDir <-
  as.vector(matrix("blurryEye", nrow = length(blurryEyeRiv$subject)))
blurryEyeRiv$rivDir <- as.factor(blurryEyeRiv$rivDir)

preXpostAdapt <- rbind(nonBlurryEyeRiv, blurryEyeRiv, mixDir)
preXpostAdapt$subject <- as.factor(preXpostAdapt$subject)
preXpostAdapt$phase <- as.factor(preXpostAdapt$phase)
} else {
  if (length(mixDir$butPress) != 0){
    preXpostAdapt <- rbind(nonBlurryEyeRiv,mixDir)
  }else{
    preXpostAdapt <- nonBlurryEyeRiv
  }
  preXpostAdapt$subject <- as.factor(preXpostAdapt$subject)
  preXpostAdapt$phase <- as.factor(preXpostAdapt$phase)
}

##calculate time spent seeing each eye after each button press
#break apart for timing analysis
preAdapt <- subset(preXpostAdapt, phase == "preAdapt")
preAdapt <- preAdapt[order(preAdapt$rt), ]
postAdapt <- subset(preXpostAdapt, phase == "postAdapt")
postAdapt <- postAdapt[order(postAdapt$rt), ]
if (length(preAdapt$subject)!=0) {
  occurrencePre <- replicate(length(preAdapt$rivDir), 0)
  for (i in 1:length(preAdapt$rt)) {
    occurrencePre[i] = preAdapt$rt[i + 1] - preAdapt$rt[i]
    if (i == length(preAdapt$rt)) {
      occurrencePre[i] = round(preAdapt$rt[i], digits = -2) - preAdapt$rt[i]
    }
  }
  preAdapt$durationOnEye <- occurrencePre
  preAdapt<-dplyr::filter(preAdapt, durationOnEye > 0)
  
  #get porportion of time spent on each eye every minute
  all <-
    c(seq(0, round(
      tail(preAdapt$rt, n = 1), digits = -2
    ), by = 60))
  if (tail(preAdapt$rt, n = 1) > tail(all,n=1)){
    newVal <-tail(all,n=1)+60
    all<-append(all,newVal)
  }
  preAdapt <- subset(preAdapt, rt < 600)
  
  beTrack = replicate(length(all) - 1, 0)
  pct_be = replicate(length(all) - 1, 0)
  nbeTrack = replicate(length(all) - 1, 0)
  pct_nbe = replicate(length(all) - 1, 0)
  mixTrack = replicate(length(all) - 1, 0)
  pct_mix = replicate(length(all) - 1, 0)
  for (j in 1:(length(preAdapt$rt))) {
    for (i in 1:length(all))
    {
      if (preAdapt$rt[j] >= all[i] &
          preAdapt$rt[j] < all[i + 1])
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
      tail(preAdapt$rt, n = 1), digits = -2
    ), by = 60))
  if (tail(preAdapt$rt, n = 1) > tail(timePoints,n=1)){
    newVal <-tail(timePoints,n=1)+60
    timePoints<-append(timePoints,newVal)
  }
  subject <-
    as.vector(matrix(subjects[k], nrow = length(timePoints)))
  day <-
    as.vector(matrix(days[k], nrow = length(timePoints)))
  phase <-
    as.vector(matrix('preAdapt', nrow = length(timePoints)))
  #create new dataframe
  pctEyePre <-
    data.frame(subject, day, phase, timePoints, pct_be, pct_nbe, pct_mix)
  
}
#repeat for postAdaptation data
if (length(postAdapt$subject)!=0) {
  occurrencePost <- replicate(length(postAdapt$rivDir), 0)
  for (i in 1:length(postAdapt$rt)) {
    occurrencePost[i] = postAdapt$rt[i + 1] - postAdapt$rt[i]
    if (i == length(postAdapt$rt)) {
      occurrencePost[i] = round(postAdapt$rt[i], digits = -2) - postAdapt$rt[i]
    }
  }
  postAdapt$durationOnEye <- occurrencePost
  
  #get porportion of time spent on each eye every minute
  all <-
    c(seq(0, round(
      tail(postAdapt$rt, n = 1), digits = -2
    ), by = 60))
  postAdapt <- subset(postAdapt, rt < 600)
  if (tail(postAdapt$rt, n = 1) > tail(all,n=1)){
    newVal <-tail(all,n=1)+60
    all<-append(all,newVal)
  }
  beTrackPost = replicate(length(all) - 1, 0)
  pct_bePost = replicate(length(all) - 1, 0)
  nbeTrackPost = replicate(length(all) - 1, 0)
  pct_nbePost = replicate(length(all) - 1, 0)
  mixTrackPost = replicate(length(all) - 1, 0)
  pct_mixPost = replicate(length(all) - 1, 0)
  postAdapt <- subset(postAdapt, rt < 600)
  for (j in 1:(length(postAdapt$rt))) {
    for (i in 1:length(all))
    {
      if (postAdapt$rt[j] >= all[i] &
          postAdapt$rt[j] < all[i + 1])
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
      tail(postAdapt$rt, n = 1), digits = -2
    ), by = 60))
  if (tail(postAdapt$rt, n = 1) > tail(timePoints,n=1)){
    newVal <-tail(timePoints,n=1)+60
    timePoints<-append(timePoints,newVal)
  }
  subject <-
    as.vector(matrix(subjects[k], nrow = length(timePoints)))
  day <-
    as.vector(matrix(days[k], nrow = length(timePoints)))
  phase <-
    as.vector(matrix('postAdapt', nrow = length(timePoints)))
  #create new dataframe
  pctEyePost <-
    data.frame(subject,
               day,
               phase,
               timePoints,
               pct_bePost,
               pct_nbePost,
               pct_mixPost)
  colnames(pctEyePost) <-
    c("subject",
      "day",
      "phase",
      "timePoints",
      "pct_be",
      "pct_nbe",
      "pct_mix")
}
if (exists("pctEyePre")){
  preXpostTimePoints <- pctEyePre
  preXpostAdapt <- preAdapt
  if (exists("pctEyePost")){
  preXpostTimePoints <- rbind(pctEyePre, pctEyePost)
  preXpostAdapt <- rbind(preAdapt, postAdapt)
} }
# if (exists("pctEyePre")) {
#   preXpostTimePoints <- pctEyePre
#   preXpostAdapt <- preAdapt
# }else if (exists("pctEyePost")) {
#   preXpostTimePoints <- pctEyePost
#   preXpostAdapt <- postAdapt
# }

write.csv(preXpostAdapt, paste0('preXpostAdapt_', subjects[k], '.csv'))
write.csv(preXpostTimePoints,
          paste0('preXpostTimePoints_', subjects[k], '.csv'))
rm(list=setdiff(ls(), c("files","subjects","k","days")))
}
