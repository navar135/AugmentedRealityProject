## This code checks rivalry performance
##By: Karen T. Navarro
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


setwd("/Users/navar135/Documents/UMN_Research/Projects/Diplopia/Pilot_Data/")

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
                       "matFiles/AdaptationDiplopiaDat_sub003_day4_06-Mar-2020_16-45-20.mat"
                       
                       #"matFiles/AdaptationDiplopiaDat_sub006_day1_practice_06-Mar-2020_17-41-32.mat"
                       
))
subjects<- c("Sub001_day1","Sub001_day2",
             #"Sub001_day2noBlur", 
             "Sub001_day3","Sub001_day4",
             #"Sub002_day1", 
             #"Sub002_day2noBlur", 
             "Sub002_day2", "Sub002_day3","Sub002_day4","Sub002_day5",
             #"Sub003_day1",
             #"Sub003_day2noBlur", 
             "Sub003_day2","Sub003_day3","Sub003_day4"
             #"Sub006_day1"
)

#### processes detection task data ####
for (k in 2:length(files)){
  #read in data and variables
  dat <- read.mat(files[k])
  #process preBR
  rivTimesPre<-unlist(dat$multiRivResults$times[1:5], recursive = F)
  rivTimesPre <- -(rivTimesPre[1] - rivTimesPre)
  rivButPre<-unlist(dat$multiRivResults$keys[1:5], recursive = F)
  subjectPre <-
    as.vector(matrix(subjects[k], nrow = length(rivButPre)))
  rivalryPre<- data.frame(subjectPre,rivTimesPre,rivButPre)
  rivalryPre<- dplyr::filter(rivalryPre, rivButPre != 99)
  
  #find duration spent in each key press
  occurrencePre <- replicate(length(rivalryPre$rivButPre), 0)
  for (i in 1:length(rivalryPre$rivTimesPre)){
    occurrencePre[i] = rivalryPre$rivTimesPre[i + 1] - rivalryPre$rivTimesPre[i]
    if (i == length(rivalryPre$rivTimesPre)){
      occurrencePre[i] = round(rivalryPre$rivTimesPre[i], digits = -2) - rivalryPre$rivTimesPre[i]
    }
  }
  rivalryPre$durationOnEye <- occurrencePre
  rivalryPre<- dplyr::filter(rivalryPre, durationOnEye > 0)
  
  #get porportion of time spent on each eye every minute
  all <-
    c(seq(0, round(
      tail(rivalryPre$rivTimesPre, n = 1), digits = -2
    ), by = 60))
  if (tail(rivalryPre$rivTimesPre, n = 1) > tail(all,n=1)){
    newVal <-tail(all,n=1)+60
    all<-append(all,newVal)
  }
  rivalryPre <- subset(rivalryPre, rivTimesPre < 310)
  rivalryPre<- subset(rivalryPre, durationOnEye <310)
  lTrack = replicate(length(all) - 1, 0)
  pct_L = replicate(length(all) - 1, 0)
  rTrack = replicate(length(all) - 1, 0)
  pct_R = replicate(length(all) - 1, 0)
  mixTrack = replicate(length(all) - 1, 0)
  pct_mix = replicate(length(all) - 1, 0)
 #compare current time with next time to find how long seeing one direction
   for (j in 1:(length(rivalryPre$rivTimesPre))) {
    for (i in 1:length(all))
    {
      if (rivalryPre$rivTimesPre[j] >= all[i] &
          rivalryPre$rivTimesPre[j] < all[i + 1])
      {
        if (rivalryPre$rivButPre[j] == 1)
        {
          lTrack[i] <- lTrack[i] + rivalryPre$durationOnEye[j]
          pct_L[i] <- lTrack[i]/60
        }
        else if (rivalryPre$rivButPre[j] == 2)
        {
          rTrack[i] <- rTrack[i] + rivalryPre$durationOnEye[j]
          pct_R[i] <- rTrack[i] / 60
        }
        else if (rivalryPre$rivButPre[j] == 3)
        {
          mixTrack[i] <- mixTrack[i] + rivalryPre$durationOnEye[j]
          pct_mix[i] <- mixTrack[i] / 60
        }
      }
    }
  }
  timePoints <-
    c(seq(60, round(
      tail(rivalryPre$rivTimesPre, n = 1), digits = -2
    ), by = 60))
  if (tail(rivalryPre$rivTimesPre, n = 1) > tail(timePoints,n=1)){
    newVal <-tail(timePoints,n=1)+60
    timePoints<-append(timePoints,newVal)
  }
  #necessary info for dataframe
  subject <-
    as.vector(matrix(subjects[k], nrow = length(timePoints)))
  phase <-
    as.vector(matrix('rivalryPre', nrow = length(timePoints)))
  pct_L <- pct_L[1:length(timePoints)]
  pct_R <- pct_R[1:length(timePoints)]
  pct_mix <- pct_mix[1:length(timePoints)]

  #create new dataframe
  pctEyePre <- 
    data.frame(subject, phase, timePoints, pct_L, pct_R, pct_mix)
  pctEye<-pctEyePre
  #### process postBR ####
  #first check if these lists are empty
  rivTimesPost<-unlist(dat$multiRivResults$times[6:11], recursive = F)
  if (length(rivTimesPost) ==0){
    remove(rivTimesPost)
  }
  #only process if they exist
  if (exists("rivTimesPost")) {
    rivTimesPost <- -(rivTimesPost[1] - rivTimesPost)
    rivButPost<-unlist(dat$multiRivResults$keys[6:11], recursive = F)
    subjectPost <-
      as.vector(matrix(subjects[k], nrow = length(rivButPost)))
    rivalryPost<- data.frame(subjectPost,rivTimesPost,rivButPost)
    rivalryPost<- dplyr::filter(rivalryPost, rivButPost != 99)

      
    occurrencePost <- replicate(length(rivalryPost$rivButPost), 0)
    for (i in 1:length(rivalryPost$rivTimesPost)){
      occurrencePost[i] = rivalryPost$rivTimesPost[i + 1] - rivalryPost$rivTimesPost[i]
      if (i == length(rivalryPost$rivTimesPost)){
        occurrencePost[i] = round(rivalryPost$rivTimesPost[i], digits = -2) - rivalryPost$rivTimesPost[i]
        }
    }
    rivalryPost$durationOnEye <- occurrencePost
    #the post timings can start really late specially if you did an extra pre trial so
    #filter those trials out and reprocess timing
    if (tail(rivalryPost$rivTimesPost, n = 1) > 600) {
      rivalryPost <- dplyr::filter(rivalryPost, rivTimesPost > 600)
      rivalryPost$rivTimesPost <- rivalryPost$rivTimesPost-rivalryPost$rivTimesPost[1]
    }
    #get porportion of time spent on each eye every minute
    dur <- tail(rivalryPost$rivTimesPost, n = 1) - (rivalryPost$rivTimesPost[1])
    all <-
      c(seq(0, round(dur, digits = -2), by = 60))
    if (tail(rivalryPost$rivTimesPost, n = 1) > tail(all,n=1)){
      newVal <-tail(all,n=1)+60
      all<-append(all,newVal)
    }
    #make empty lists to track duration on each eye every minute
    lTrack = replicate(length(all) - 1, 0)
    pct_L = replicate(length(all) - 1, 0)
    rTrack = replicate(length(all) - 1, 0)
    pct_R = replicate(length(all) - 1, 0)
    mixTrack = replicate(length(all) - 1, 0)
    pct_mix = replicate(length(all) - 1, 0)
    #find timing by comparing current time with next time and find the percent 
    #of time spent seeing one direction over the other
    for (j in 1:(length(rivalryPost$rivTimesPost))) {
      for (i in 1:length(all))
      {
        if (rivalryPost$rivTimesPost[j] >= all[i] &
            rivalryPost$rivTimesPost[j] < all[i + 1])
        {
          if (rivalryPost$rivButPost[j] == 1)
          {
            lTrack[i] <- lTrack[i] + rivalryPost$durationOnEye[j]
            pct_L[i] <- lTrack[i]/60
          }
          else if (rivalryPost$rivButPost[j] == 2)
          {
            rTrack[i] <- rTrack[i] + rivalryPost$durationOnEye[j]
            pct_R[i] <- rTrack[i] / 60
          }
          else if (rivalryPost$rivButPost[j] == 3)
          {
            mixTrack[i] <- mixTrack[i] + rivalryPost$durationOnEye[j]
            pct_mix[i] <- mixTrack[i] / 60
          }
        }
      }
    }
    timePoints <-
      c(seq(round(rivalryPost$rivTimesPost[1],digits = -2)+60, round(
        tail(rivalryPost$rivTimesPost, n = 1), digits = -2
      ), by = 60))
    if (tail(rivalryPost$rivTimesPost, n = 1) > tail(timePoints,n=1)){
      newVal <-tail(timePoints,n=1)+60
      timePoints<-append(timePoints,newVal)
    }
    subject <-
      as.vector(matrix(subjects[k], nrow = length(timePoints)))
    phase <-
      as.vector(matrix('rivalryPost', nrow = length(timePoints)))
    #create new dataframe
    pctEyePost <-
      data.frame(subject, phase, timePoints, pct_L, pct_R, pct_mix)
    pctEye<-rbind(pctEyePre,pctEyePost)
  }
  write.csv(pctEye, paste0('pctBinRiv_', subjects[k], '.csv'))
  rm(list=setdiff(ls(), c("files","subjects","k")))
}

####plot data
temp <- list.files(pattern="*pctBinRiv")
binRiv <- ldply(temp, read_csv)
binRiv$X1 <- NULL

pctEyePre<-subset(binRiv,phase=="rivalryPre")
pctEyePost<- subset(binRiv,phase=="rivalryPost")
pctEyePost<- dplyr::filter(pctEyePost, subject != "Sub002_day2")
gg2 <- ggplot() + 
  geom_line(data = pctEyePre, 
            aes(x = timePoints, y = pct_L, color = "pct_L")) + 
  geom_point(data = pctEyePre, 
             aes(x = timePoints, y = pct_L, color = "pct_L")) +
  geom_line(data = pctEyePre, 
            aes(x = timePoints, y = pct_R, color = "pct_R")) + 
  geom_point(data = pctEyePre, 
             aes(x = timePoints, y = pct_R, color = "pct_R")) + 
  geom_line(data = pctEyePre, 
            aes(x = timePoints, y = pct_mix, color = "pct_mix")) + 
  geom_point(data = pctEyePre, 
             aes(x = timePoints, y = pct_mix, color = "pct_mix"))  
gg2<- gg2 + labs(x = "time (s)",y = "% time seeing each eye", title = 
                   "Pre Adaptation") 
gg2<- gg2+ facet_wrap(~subject)
gg3<-ggplot() +
  geom_line(data = pctEyePost,
            aes(x = timePoints, y = pct_L, color = "pct_L")) +
  geom_point(data = pctEyePost,
             aes(x = timePoints, y = pct_L, color = "pct_L")) +
  geom_line(data = pctEyePost,
            aes(x = timePoints, y = pct_R, color = "pct_R")) +
  geom_point(data = pctEyePost,
             aes(x = timePoints, y = pct_R, color = "pct_R")) +
  geom_line(data = pctEyePost,
            aes(x = timePoints, y = pct_mix, color = "pct_mix")) +
  geom_point(data = pctEyePost,
             aes(x = timePoints, y = pct_mix, color = "pct_mix"))
gg3<- gg3 + labs(x = "time (s)",y = "% time seeing each eye", title =
                   "Post Adaptation")
gg3<- gg3+ facet_wrap(~subject)
grid.arrange(gg2, gg3, nrow=2)

